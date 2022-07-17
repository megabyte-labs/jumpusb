#!/bin/bash
# https://gitlab.com/megabyte-labs/jumpusb/-/raw/master/ventoy/scripts/qubes/qubes.sh
# https://github.com/endeavouros-team/endeavouros-xfce4-theming
sudo qubesctl --show-output state.sls update.qubes-dom0
sudo qubes-dom0-update -y kernel-latest
sudo qubes-dom0-update -y qubes-template-fedora-36
sudo qubes-dom0-update -y qubes-template-debian-11
sudo qubes-dom0-update -y qubes-template-debian-11-minimal
sudo qubes-dom0-update -y qubes-template-debian-10-minimal
sudo qubes-dom0-update -y qubes-repo-contrib
sudo qubes-dom0-update -y qubes-repo-templates
sudo qubes-dom0-update -y qubes-windows-tools
sudo qubes-dom0-update --clean -y
sudo qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm
sudo qubesctl --show-output --skip-dom0 --standalones state.sls update.qubes-vm

# https://github.com/Jeeppler/qubes-cheatsheet/blob/master/qubes-cheatsheet.md

sudo qubesctl state.sls qvm.usb-keyboard
sudo qubesctl state.sls qvm.usb-mouse
sudo qubesctl state.sls qvm.sys-usb
sudo echo "sys-keyboard dom0 ask,default_target=dom0" >> /etc/qubes-rpc/policy/qubes.InputKeyboard
sudo echo "sys-mouse dom0 ask,default_target=dom0" >> /etc/qubes-rpc/policy/qubes.InputMouse

sudo qubes-dom0-update qubes-u2f-dom0
sudo qvm-service --enable work qubes-u2f-proxy
sudo echo "$anyvm sys-usb allow,user=root" > /etc/qubes-rpc/policy/u2f.Authenticate
sudo echo "$anyvm sys-usb allow,user=root" > /etc/qubes-rpc/policy/u2f.Register

# GUI-VM / GPU Passthrough
sudo qubesctl top.enable qvm.sys-gui-gpu
sudo qubesctl top.enable qvm.sys-gui-gpu pillar=True
sudo qubesctl --all state.highstate
sudo qubesctl top.disable qvm.sys-gui-gpu
sudo qubesctl state.sls qvm.sys-gui-gpu-attach-gpu
# Reboot

# Split GPG
sudo qubes-dom0-update qubes-gpg-split-dom0

# Add HVM (add --property virt_mode=hvm if you want to use a kernel from within the qube)
qvm-create opnsense --class TemplateVM --label orange
qvm-prefs opnsense memory 8192
qvm-prefs opnsense maxmem 8192
qvm-prefs opnsense kernel ''
qvm-prefs opnsense virt_mode hvm
qvm-prefs opnsense linux-stubdom ''
qvm-prefs opnsense debug true
qvm-features opnsense video-model cirrus
qvm-volume extend opnsense:root 120g
qvm-start opnsense --cdrom=dom0:/usr/local/iso/opnsense.iso
# Restart after installation ends
qvm-start opnsense
qvm-prefs opnsense debug false
qvm-prefs opnsense qrexec_timeout 300
qvm-prefs opnsense guivm dom0


qvm-create --class=DispVM -l green opnsense-dvm
qvm-prefs opnsense-dvm autostart true
qvm-prefs opnsense-dvm netvm sys-net
qvm-prefs opnsense-dvm provides_network true
qvm-features opnsense-dvm appmenus-dispvm ''
