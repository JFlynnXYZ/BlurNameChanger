#include "stdafx.h"
#include "CustomHooks.h"

typedef BOOL(WINAPI*GetUserNameA_t)(
	LPSTR                 lpBuffer,
	LPDWORD               pcbBuffer);

GetUserNameA_t OriginalGetUserNameA;

BOOL WINAPI GetUserNameA_Wrapper(
	LPSTR                 lpBuffer,
	LPDWORD               pcbBuffer
)
{
	HANDLE hFile = CreateFile(L"Driver", GENERIC_READ, 0, NULL,
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) 
	{
		return OriginalGetUserNameA(lpBuffer, pcbBuffer);
	}

	DWORD fileSize = GetFileSize(hFile, NULL);
	if (fileSize == INVALID_FILE_SIZE) 
	{ 
		CloseHandle(hFile); 
		return OriginalGetUserNameA(lpBuffer, pcbBuffer); 
	}

	char buffer[17] = {};
	DWORD bytesRead;
	if (!ReadFile(hFile, buffer, 16, &bytesRead, NULL)) 
	{ 
		CloseHandle(hFile); 
		return OriginalGetUserNameA(lpBuffer, pcbBuffer); 
	}

	buffer[bytesRead] = '\0';
	CloseHandle(hFile);

	if (*pcbBuffer < bytesRead + 1) 
	{
		return OriginalGetUserNameA(lpBuffer, pcbBuffer);
	}
	strcpy_s(lpBuffer, *pcbBuffer, buffer);
	*pcbBuffer = static_cast<DWORD>(bytesRead);
	return TRUE;
}

void SetupHooks()
{
	// Create a console for Debug output
	// AllocConsole();

	// Setup hooks here, see examples below
	OriginalGetUserNameA = HookFunction("ADVAPI32.dll", "GetUserNameA", &GetUserNameA_Wrapper);
}

