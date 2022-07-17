#!/bin/bash
# https://gitlab.com/megabyte-labs/jumpusb/-/raw/master/ventoy/scripts/qubes/qubes.sh
# https://github.com/endeavouros-team/endeavouros-xfce4-theming
sudo qubesctl --show-output state.sls update.qubes-dom0
sudo qubes-dom0-update kernel-latest
sudo qubes-dom0-update qubes-template-fedora-36
sudo qubes-dom0-update qubes-template-debian-11
sudo qubes-dom0-update qubes-template-debian-11-minimal
sudo qubes-dom0-update qubes-template-debian-10-minimal
sudo qubes-dom0-update qubes-repo-contrib
sudo qubes-dom0-update qubes-repo-templates
sudo qubes-dom0-update qubes-windows-tools
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
