#!/usr/bin/env bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# Install docker cli
sudo apt-get install docker-ce-cli -y --allow-unauthenticated
sudo groupadd docker
sudo usermod -aG docker $USER
mkdir -p ~/bin

# Creating wrapper for docker-credential-desktop
cat > ~/bin/docker-credential-desktop <<EOF
#!/usr/bin/env bash
cmd.exe /c "$(cmd.exe /c where docker-credential-desktop | tr -d '\r')" "\$@"
EOF
sudo chmod +x ~/bin/docker-credential-desktop


# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose