# Self-elevate the script if it's not already running as admin
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}

# Hashtable with all dotfiles in the repo and the corresponding symlink paths
$dotfiles = @{
  ".gitconfig"    = "~\.gitconfig"
  "settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  "WSL2Proxy.ps1" = "~\WSL2Proxy.ps1"
}

# Go into the 'windows' directory of the repo because the paths in the hashtable are relative to it
Set-Location ~\.dotfiles\windows

# Loop through all dotfiles in the hashtable
foreach ($repo_file in $dotfiles.keys) {
  # -Force: Overwrite existing files with new symlinks
  # -Confirm: Prompt the user before each symlink is created
  New-Item -ItemType SymbolicLink -Path $dotfiles[$repo_file] -Target $repo_file -Force -Confirm
}

Read-Host "`nFinished creating symlinks. Press Enter to close"