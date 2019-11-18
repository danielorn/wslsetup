@echo off

rem Make sure script is run with admin privileges

for /f "delims=" %%F in ('powershell -C "(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)"') do set admin=%%F

if %admin%==False (
	echo Script needs to run as admin, please relaunch
	PAUSE
	exit
) else (
	echo You are running as Administrator
) 

rem Enable Optional Windows Feature Microsoft-Windows-Subsystem-Linux

for /f "delims=" %%F in ('powershell -C "(Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State"') do set wslenabled=%%F

if %wslenabled%==False (
	echo Microsoft-Windows-Subsystem-Linux not enabled. Enabling now. Restart required
	powershell -C "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux"
	PAUSE
	exit
) else (
	echo Microsoft-Windows-Subsystem-Linux is enabled
) 

ECHO Downloading Ubuntu 18.04
curl.exe -L -o %USERPROFILE%/Downloads/ubuntu-1804.appx https://aka.ms/wsl-ubuntu-1804

ECHO Installing Ubuntu 18.04
powershell -C "Add-AppxPackage $HOME\Downloads\ubuntu-1804.appx"
ubuntu1804.exe install --root

ECHO Setting WSLENV ...
cmd.exe /c setx WSLENV USERNAME:USERPROFILE/p:DOCKER_HOST
ECHO ... WSLENV is now %WSLENV%

ECHO Configuring windows mount points in WSL
wsl.exe --user root cp wsl.conf /etc/wsl.conf
wsl.exe --terminate Ubuntu-18.04

ECHO Setting up new wsl user %USERNAME% with home directory %USERPROFILE%
wsl.exe --user root ./addwinuser.sh

ECHO Setting user %USERNAME% as defualt user in WSL
ubuntu1804 config --default-user %USERNAME%
wsl.exe --terminate Ubuntu-18.04

wsl.exe chmod +x setup.sh
wsl.exe ./setup.sh

echo Installation is now complete

PAUSE
exit