#!/bin/bash

cp /boot/config-5.7.0-rc7-2fef6a08-master .config
make olddefconfig

# With DEBUG_INFO enabled, the resulting .deb file is close to 1 GB in
# size. Disable it to save some space/bandwidth.
scripts/config --disable DEBUG_INFO
scripts/config --enable KVM_EPT_SAMPLE
scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
scripts/config --disable SYSTEM_REVOCATION_KEYS

make -j`nproc`


sudo make modules_install
sudo make install
reboot
