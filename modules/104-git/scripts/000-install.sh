#!/usr/bin/env bash
if  [ -x "$(command -v git)" ]; then
	echo "Configuring git"
	# Setting sensible defaults for configuration values in git
	echo "   core.longpaths true"
	git config --global core.longpaths true
	echo "   core.autocrlf input"
	git config --global core.autocrlf input
	echo "   core.fileMode false"
	git config --global core.fileMode false
	echo "   credential.helper store"
	git config --global credential.helper store
fi