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

wsl.exe ./setup.sh