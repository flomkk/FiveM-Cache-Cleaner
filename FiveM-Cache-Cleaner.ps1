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

# ######################################################################
function Get-FiveMInstallPath {
    $proc = Get-Process -Name "FiveM" -ErrorAction SilentlyContinue
    if ($proc -and $proc.Path) {
        return Split-Path $proc.Path -Parent
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
        return $entry.InstallLocation
    }

    # throw "FiveM Installation konnte nicht gefunden werden."
    Write-Host "  FiveM Installation konnte nicht gefunden werden." -ForegroundColor Red
}

$fivemInstallPath = Get-FiveMInstallPath
$cachePath = Join-Path $fivemInstallPath "data\cache"
# ######################################################################

# $cachePath = Join-Path $env:LocalAppData "FiveM\FiveM.app\data\cache"
Write-Host "  Suche nach FiveM in $cachePath" -ForegroundColor Yellow

if (Test-Path $cachePath) {
    Write-Host "  Leere Cache-Verzeichnis: $cachePath" -ForegroundColor Yellow
    Remove-Item $cachePath -Recurse -Force
    Write-Host "  Cache erfolgreich geleert." -ForegroundColor Green
} else {
    Write-Host "  Cache-Verzeichnis nicht gefunden. Falls dies ein Fehler ist, dann melde es flomkk" -ForegroundColor Red
}

Write-Host ""
Read-Host -Prompt "  Drücke ENTER zum Beenden"
