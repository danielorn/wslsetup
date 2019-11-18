#!/usr/bin/env bash
# If no id_rsa key found, generate it.

echo "Check if  $HOME/.ssh/id_rsa exists"
if [ ! -f ~/.ssh/id_rsa ]; then
	mkdir -p ~/.ssh
	echo "~/.ssh/id_rsa not found, generating"
	ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
fi

echo "Setting permissions 600 on $HOME/.ssh/id_rsa"
chmod 600 ~/.ssh/id_rsa