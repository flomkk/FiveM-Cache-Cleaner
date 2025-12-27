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

Write-Host "  Beende FiveM Prozesse..." -ForegroundColor Yellow
Get-Process FiveM -ErrorAction SilentlyContinue | Stop-Process -Force

function Get-FiveMInstallPath {
    Write-Host "  Suche nach FiveM Installation..." -ForegroundColor Yellow
    $proc = Get-Process -Name "FiveM" -ErrorAction SilentlyContinue
    if ($proc -and $proc.Path) {
        $exeDir = Split-Path $proc.Path -Parent

        if ($exeDir -notmatch "FiveM\.app$") {
            $exeDir = Join-Path $exeDir "FiveM.app"
        }
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
        
        Write-Host "  FiveM Installation gefunden." -ForegroundColor Green
        return $installPath
    }

    Write-Host "  FiveM Installation konnte nicht gefunden werden." -ForegroundColor Red
}

$fivemInstallPath = Get-FiveMInstallPath
$cachePath = Join-Path $fivemInstallPath "data\cache"

if (Test-Path $cachePath) {
    Write-Host "  Leere Cache-Verzeichnis: $cachePath" -ForegroundColor Yellow
    Remove-Item $cachePath -Recurse -Force
    Write-Host "  Cache erfolgreich geleert." -ForegroundColor Green
} else {
    Write-Host "  Cache-Verzeichnis nicht gefunden. Es sieht so aus als wäre dein Cache schon leer!" -ForegroundColor Red
}

Write-Host ""
Read-Host -Prompt "  Drücke ENTER zum Beenden"
