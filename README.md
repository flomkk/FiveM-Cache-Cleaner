<div align="center">

# FiveM Cache Cleaner

**A lightweight PowerShell utility to automatically detect and clean FiveM's cache.**  
Built for players troubleshooting issues and server admins who want a simple tool to hand out to their community.

[![Version](https://img.shields.io/badge/version-v0.1.0-blue?style=flat-square)](https://github.com/flomkk/FiveM-Cache-Cleaner/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Platform](https://img.shields.io/badge/platform-Windows-0078D6?style=flat-square&logo=windows&logoColor=white)](https://www.microsoft.com/windows)

</div>

---

## About

FiveM Cache Cleaner automatically finds your FiveM installation, terminates any running FiveM processes, and wipes all cache directories. No configuration needed - just run it and you're done.

---

## Features

- Auto-detects your FiveM installation via the running process or the Windows registry
- Safely terminates all FiveM processes before clearing cache to avoid file locks
- Clears all three relevant cache directories: `data\cache`, `data\server-cache`, and `data\server-cache-priv`
- Color-coded console output so you can see exactly what happened
- Two run methods: a `.ps1` script for PowerShell users and a `.bat` launcher for one-click use

---

## Usage

**Option 1 - Batch launcher**

Double-click `FiveM-Cache-Cleaner.bat`. No setup required.

**Option 2 - PowerShell**

Right-click `FiveM-Cache-Cleaner.ps1` and select "Run with PowerShell", or run it from a terminal:

```powershell
.\FiveM-Cache-Cleaner.ps1
```

If you get an execution policy error, run this first:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

---

## Requirements

- Windows 10 / 11
- PowerShell 5.1 or newer (included with Windows by default)
- FiveM installed via the standard installer

---

## How It Works

1. The script checks for a running `FiveM.exe` process to locate the install directory.
2. If FiveM is not running, it falls back to scanning the Windows registry.
3. All FiveM processes are terminated to prevent file locks during deletion.
4. The three cache directories are deleted recursively.
5. The script reports success or any errors for each folder individually.

---

## Files

| File | Description |
|---|---|
| `FiveM-Cache-Cleaner.ps1` | Main PowerShell script |
| `FiveM-Cache-Cleaner.bat` | Batch launcher for one-click execution |

---

## Contributing

Pull requests are welcome. If you find a bug or have a feature request, open an issue.
