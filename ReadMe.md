# 📦 BlurNameChanger

> *Your documentation is a direct reflection of your software, so hold it to the same standards.*


## 🌟 Highlights

- Allows you to set your name in the game Blur without having to change your Windows
username.


## ℹ️ Overview

Based off of https://github.com/LANCommander/BlurNameChanger I've just cleaned up a 
bit and added some helper scripts.

This uses a DLL hook into DInput and overrides the function for GetUserNameA in the 
Windows API.

I've included 2 scripts as well to help set the name and also to setup firewall 
permissions.

### ✍️ Authors

@JFlynnXYZ
Initial fork from @LANCommander

## ⬇️ Installation

Compile the solution using x86(Win32) and drop the DInput8.dll into the Blur
install location alongside Blur.exe.

For the scripts drop the Scripts folder alongside the the BLUR folder e.g. 
`C:\Games\Scripts` if `C:\Games\BLUR\Blur.exe`.

## 🚀 Usage

For the scripts simply run the bat files when they are in the right location.