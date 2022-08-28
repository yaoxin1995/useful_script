#!/usr/bin/env bash

sudo apt-get install cloud-image-utils qemu

# This is already in qcow2 format.
img=ubuntu-22.04-server-cloudimg-amd64.img
if [ ! -f "$img" ]; then
  wget "https://cloud-images.ubuntu.com/releases/22.04/release/${img}"

  # sparse resize: does not use any extra space, just allows the resize to happen later on.
  # https://superuser.com/questions/1022019/how-to-increase-size-of-an-ubuntu-cloud-image
  qemu-img resize "$img" +30G
fi

user_data=user-data.img
# For [ ! -f "$user_data" ] syntax
# https://linuxize.com/post/bash-check-if-file-exists/
# username: ubuntu
# password: asdfqwer
if [ ! -f "$user_data" ]; then
  # For the password.
  # https://stackoverflow.com/questions/29137679/login-credentials-of-ubuntu-cloud-server-image/53373376#53373376
  # https://serverfault.com/questions/920117/how-do-i-set-a-password-on-an-ubuntu-cloud-image/940686#940686
  # https://askubuntu.com/questions/507345/how-to-set-a-password-for-ubuntu-cloud-images-ie-not-use-ssh/1094189#1094189
  # How does "cat << EOF" work in bash?
  # https://stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash
  cat >user-data <<EOF
#cloud-config
users:
  - name: root
    ssh_pwauth: True
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWyftpHCVBpj5B2fse3UgcV9wFUMcQQOsFAyzKu9LgG3Jix+A+xqaC9bAjkZ9Gwt6biSnKXga8aSF8vE2YjcQInLDz3pmqB33jU1ABjIyztTRoWzICSokElSF7DxhNEOqz9R/4zA/c+dWfsNU1SsG+/WXEArXIN3dOGLsrRYu1ervZeh8FZ/JBE5QqcAKwkEogQfw0Wl7iZr0J+4fQDVq6y5T2A2pPDw3T66UW61cITg3td5zH8K646GNtsrpRjQc3F4LV0SGUCei61iE3cSAhwbPwtjIya1c9p1ZqAtf10ryBr1oTUBKd2xPkRQe512TdJcboQsvZRZPu5OJ+0NuRCTZaTsW2iD25U4OO+4ofMxXSRJMY0aJq1TPuJNNzAkYusUwEI59to+ZG9FyqXHAr+PJGWAm9O5Ch82u2iT3NOss5numdcdGtoUWk74gk0iwMs2EmNkKRu0R9StNM0JFB6x08kH7umd1w4U5o8XphCFNiQknODI3kQPS5Db7RXsE= jing@wei-HP-ProDesk-600-G1-TWR
chpasswd:
  list: |
    root:root
  expire: False      

EOF
  cloud-localds "$user_data" user-data
fi

qemu-system-x86_64 \
  -drive "file=${img},format=qcow2" \
  -drive "file=${user_data},format=raw" \
  -device rtl8139,netdev=net0 \
  -enable-kvm \
  -m 8G \
  -netdev user,id=net0 \
  -smp 3 \
  -vga virtio \
  -nographic\
  -cpu host
;

