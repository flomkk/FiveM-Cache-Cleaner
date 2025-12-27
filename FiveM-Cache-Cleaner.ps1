$host.ui.RawUI.WindowTitle = "FiveM Cache Cleaner - Made by flomkk"
Clear-Host

Write-Host ""
Write-Host -ForegroundColor Magenta @"
   ███╗   ██╗ █████╗ ██████╗  ██████╗ ██████╗      ██████╗██╗████████╗██╗   ██╗
   ████╗  ██║██╔══██╗██╔══██╗██╔════╝██╔═══██╗    ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝
   ██╔██╗ ██║███████║██████╔╝██║     ██║   ██║    ██║     ██║   ██║    ╚████╔╝
   ██║╚██╗██║██╔══██║██╔══██╗██║     ██║   ██║    ██║     ██║   ██║     ╚██╔╝
   ██║ ╚████║██║  ██║██║  ██║╚██████╗╚██████╔╝    ╚██████╗██║   ██║      ██║
   ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝      ╚═════╝╚═╝   ╚═╝      ╚═╝
"@

Write-Host -ForegroundColor White "                    Made by flomkk - " -NoNewLine
Write-Host -ForegroundColor White "discord.gg/narcocity"
Write-Host ""

function Get-FiveMInstallPath {
    Write-Host "  [?] Suche nach FiveM Installation..." -ForegroundColor Yellow

    $proc = Get-Process -Name "FiveM" -ErrorAction SilentlyContinue
    if ($proc -and $proc.Path) {
        $exeDir = Split-Path $proc.Path -Parent

        if ($exeDir -notmatch "FiveM\.app$") {
            $exeDir = Join-Path $exeDir "FiveM.app"
        }

        Write-Host "  [+] FiveM Installation über laufenden Prozess gefunden." -ForegroundColor Green
        return $exeDir
    }

    $uninstallRoots = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $entry = Get-ItemProperty $uninstallRoots -ErrorAction SilentlyContinue |
    Where-Object {
        $_.DisplayName -and $_.DisplayName -like "*FiveM*"
    } |
    Select-Object -First 1

    if ($entry.InstallLocation) {
        $installPath = $entry.InstallLocation

        if ($installPath -notmatch "FiveM\.app$") {
            $installPath = Join-Path $installPath "FiveM.app"
        }

        Write-Host "  [+] FiveM Installation gefunden." -ForegroundColor Green
        return $installPath
    }

    Write-Host "  [!] FiveM Installation konnte nicht gefunden werden." -ForegroundColor Red
}

function CloseFiveMProcesses {
    Write-Host "  [?] Beende FiveM Prozesse..." -ForegroundColor Yellow

    $procs = Get-Process FiveM -ErrorAction SilentlyContinue
    if ($procs) {
        $procs | Stop-Process -Force
        Start-Sleep -Seconds 2

        $remaining = Get-Process FiveM -ErrorAction SilentlyContinue
        if ($remaining) {
            Write-Host "  [!] Achtung: Einige FiveM-Prozesse konnten nicht beendet werden!" -ForegroundColor Red
        } else {
            Write-Host "  [+] Alle FiveM-Prozesse wurden erfolgreich beendet." -ForegroundColor Green
        }
    } else {
        Write-Host "  [!] Keine FiveM-Prozesse gefunden." -ForegroundColor DarkYellow
    }
}

function Clear-FiveMCache {
    $fivemInstallPath = Get-FiveMInstallPath
    $cacheFolders = @{
        "Cache"             = Join-Path $fivemInstallPath "data\cache"
        "Server-Cache"      = Join-Path $fivemInstallPath "data\server-cache"
        "Server-Cache-Priv" = Join-Path $fivemInstallPath "data\server-cache-priv"
    }

    CloseFiveMProcesses

    foreach ($name in $cacheFolders.Keys) {
        $path = $cacheFolders[$name]

        if (Test-Path $path) {
            Write-Host "  [?] Leere $name..." -ForegroundColor Yellow
            try {
                Remove-Item $path -Recurse -Force -ErrorAction Stop
                Write-Host "  [+] $name erfolgreich geleert." -ForegroundColor Green
            } catch {
                Write-Host "  [!] Fehler beim Leeren von $name : $_" -ForegroundColor Red
            }
        } else {
            Write-Host "  [!] $name-Verzeichnis nicht gefunden. Es sieht so aus, als wäre es bereits leer!" -ForegroundColor DarkYellow
        }
    }
}

Clear-FiveMCache

Write-Host ""
Read-Host -Prompt "  Drücke ENTER zum Beenden"
