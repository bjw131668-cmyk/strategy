# Zhuge Liang memorial popup - Windows installer
# 1) Scheduled task: every day at 07:00
# 2) Startup-folder shortcut: every time you sign in (turn on the PC)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $here 'index.html'
if (-not (Test-Path $html)) { throw "index.html not found next to this script: $html" }
$uri = ([System.Uri]$html).AbsoluteUri

# Prefer Edge "app mode" (a clean window without tabs/address bar); fall back to the default browser.
$edge = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if ($edge) {
  $exe  = $edge
  $argStr = "--app=`"$uri`" --window-size=1000,920"
} else {
  $exe  = "$env:WINDIR\explorer.exe"
  $argStr = "`"$html`""
}

# 1) Daily 07:00
$taskName = 'ZhugeLiang-Sangso'
$action   = New-ScheduledTaskAction -Execute $exe -Argument $argStr
$trigger  = New-ScheduledTaskTrigger -Daily -At '07:00'
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings `
  -Description 'Shows the Zhuge Liang memorial (sangso) every morning at 07:00' -Force | Out-Null

# 2) At sign-in (Startup folder shortcut - no admin rights needed)
$startup = [Environment]::GetFolderPath('Startup')
$lnkPath = Join-Path $startup 'ZhugeLiang-Sangso.lnk'
$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut($lnkPath)
$lnk.TargetPath = $exe
$lnk.Arguments = $argStr
$lnk.WorkingDirectory = $here
$lnk.Description = 'Zhuge Liang memorial'
$lnk.Save()

Write-Host ''
Write-Host 'Installed.' -ForegroundColor Green
Write-Host "  - Daily 07:00 : Task Scheduler > $taskName"
Write-Host "  - At sign-in  : $lnkPath"
Write-Host ''
Write-Host 'Opening it once now so you can check...'
Start-Process -FilePath $exe -ArgumentList $argStr
