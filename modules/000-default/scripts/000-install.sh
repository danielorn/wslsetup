#!/bin/bash
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt-get update

sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	lsof \
	software-properties-common \
	lsb-release \
	dirmngr -y