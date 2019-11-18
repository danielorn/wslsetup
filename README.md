
# TL;DR

## Install
1. Right click on the `install.bat` file
2. Select "Run as admin"
3. Wait until the installation finnishes
4. From the start menu, launch `Ubuntu 18.04` and start hacking

## Uninstal
To uninstall everything and start from scratch
1. Open start menu, search for "Ubuntu 1804". Right click and select "Uninstall"
2. Remove the following
	- `$HOME/bash_logout`
	- `$HOME/bashrc`
	- `$HOME/.profile`
	- `$HOME/.ssh`
	- `$HOME/.bash_config`
	- `$HOME/bin`

- Remove any additions made to `/c/Windows/System32/drivers/etc/hosts`. (Additions are placed inside guards):

```
Original content of file (do not remove)
####STARTWSLSETUP
WSL SETUP additins (remove this)
####ENDWSLSETUP
```

# The Details

## Installing WSL from scratch

The Windows Subsystem for Linux (WSL from here on) lets developers run GNU/Linux environment, including most command-line tools, utilities, and applications, directly on Windows, unmodified, without the overhead of a virtual machine. [Official documentation of WSL](https://docs.microsoft.com/en-us/windows/wsl/about)

When running `install.bat` the following will happen
1. The script will check you run as admin. If not it will quit
2. The script will check that you have Windows Subsystem for linux enabled. If not it will enable it and quit (to allow for a reboot).
3. Download [Ubuntu 1804](https://aka.ms/wsl-ubuntu-1804)
4. Install Ubuntu 1804
5. Setup sharing of environment variables `USERNAME`, `USERPROFILE` and `DOCKER_HOST` with wsl and windows
6. Reconfigure wsl to mount the windows drive directly under root (i.e `/c`, `/d` etc instead of `/mnt/c`, `/mnt/d` etc). The exact mount configuration can be found in [wsl.conf](wsl.conf)
7. Adding a wsl user with the same name and home folder as the current windows user. The exact procedure can be found in [addwinuser.sh](addwinuser.sh) 
8. Setting the newly created user as default
9. Executes and installs the following modules
	 - [000-default](modules/000-default/README.md)
	 - [010-upgrade](modules/010-upgrade/README.md)
	 - [101-docker](modules/101-docker/README.md)
	 - [102-kubernetes](modules/102-kubernetes/README.md)
	 - [104-git](modules/104-git/README.md)
	 - [105-ssh](modules/105-ssh/README.md)
	 - [106-powershell](modules/106-powershell/README.md)

## Installing only modules
It is possible to install the modules into an existing wsl installation by running `setup.bat`as admin. `setup.bat`is just a wrapper around `setup.sh`

### How to use setup.sh
- Please note that setup.sh should be run as admin to guarantee full functionality (like modifying the windows hostfile etc)

Running setup.sh without any arguments will install all modules. It is also possible to give it an argument to install only one module.

```
## Install all modules
./setup.sh

## Install only the java module
./setup.sh modules/100-java
```

- Backup the following files to `$HOME/.wslbackup`
	- `$HOME/bash_logout`
	- `$HOME/bashrc`
	- `$HOME/.profile`
	- `$HOME/.ssh`
	- `$HOME/.bash_config`
	- `$HOME/bin`
	- `/c/Windows/System32/drivers/etc/hosts`
- Delete the following folders (Only if all modules are installed)
	- `$HOME/.bash_config`
- Remove the previously added config from
	- `$HOME/.ssh/config`
	- `/c/Windows/System32/drivers/etc/hosts`
- Install modules
	- Run all scripts in the `scripts/`folder
	- Copy all binaries from `bin/` to `$HOME/bin`
	- Append files in `ssh`to `$HOME/.ssh/config`
	- Append files in hosts to `/c/Windows/System32/drivers/etc/hosts
	
## Anatomy of a module
To be written


