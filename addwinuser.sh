#/usr/bin/env bash
useradd -M -d $USERPROFILE -s /bin/bash $USERNAME
echo $USERNAME:$USERNAME | chpasswd
usermod -aG sudo $USERNAME

echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/nopassword
chmod 440 /etc/sudoers.d/nopassword