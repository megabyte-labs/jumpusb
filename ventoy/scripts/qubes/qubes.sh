#!/bin/bash
# https://gitlab.com/megabyte-labs/jumpusb/-/raw/master/ventoy/scripts/qubes/qubes.sh
# https://github.com/endeavouros-team/endeavouros-xfce4-theming
# TODO: Temporarily disable auto-logout or figure out why USB keyboard events are blocked during install
# TODO: Ask why usb-keyboard causes system to freeze
# https://github.com/Jeeppler/qubes-cheatsheet/blob/master/qubes-cheatsheet.md

# Update system
sudo qubesctl --show-output state.sls update.qubes-dom0
sudo qubes-dom0-update --clean -y
sudo qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm
sudo qubesctl --show-output --skip-dom0 --standalones state.sls update.qubes-vm

# Enable USB VM along with USB keyboard settings
# qvm-clone sys-usb sys-keyboard
sudo qubesctl state.sls qvm.usb-keyboard
# echo "sys-keyboard dom0 ask,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.InputKeyboard

# Show prompt before allowing USB mice
INPUT_MOUSE_RULE="sys-usb dom0 ask,default_target=dom0"
INPUT_MOUSE_FILE="/etc/qubes-rpc/policy/qubes.InputMouse"
if ! grep "$INPUT_MOUSE_RULE" "$INPUT_MOUSE_FILE"; then
  echo "$INPUT_MOUSE_RULE" | sudo tee "$INPUT_MOUSE_FILE"
fi

sudo qubes-dom0-update qubes-template-fedora-36
# sudo qubes-dom0-update qubes-template-debian-11 # Already installed on Qubes 4.1
sudo qubes-dom0-update qubes-template-debian-11-minimal

# U2F
sudo qubes-dom0-update -y qubes-u2f-dom0
sudo qvm-service --enable personal qubes-u2f-proxy
sudo qvm-service --enable work qubes-u2f-proxy
echo "$anyvm sys-usb allow,user=root" | sudo tee /etc/qubes-rpc/policy/u2f.Authenticate
echo "$anyvm sys-usb allow,user=root" | sudo tee /etc/qubes-rpc/policy/u2f.Register
qvm-run --pass-io debian-11 "sudo apt install -y qubes-u2f"
qvm-run --pass-io fedora-36 "sudo dnf install -y qubes-u2f"

# Split GPG
sudo qubes-dom0-update qubes-gpg-split-dom0

# GUI-VM / GPU Passthrough
# sudo qubesctl top.enable qvm.sys-gui
# sudo qubesctl top.enable qvm.sys-gui pillar=True
# sudo qubesctl --all state.highstate
# sudo qubesctl top.disable qvm.sys-gui

# Updates via dom0
sudo qubesctl state.sls qvm.updates-via-whonix dom0

# Reboot

# Add HVM (add --property virt_mode=hvm if you want to use a kernel from within the qube)
#qvm-create opnsense --class TemplateVM --label orange
#qvm-prefs opnsense memory 8192
#qvm-prefs opnsense maxmem 8192
#qvm-prefs opnsense kernel ''
#qvm-prefs opnsense virt_mode hvm
#qvm-prefs opnsense linux-stubdom ''
#qvm-prefs opnsense debug true
#qvm-features opnsense video-model cirrus
#qvm-volume extend opnsense:root 120g
#qvm-start opnsense --cdrom=dom0:/usr/local/iso/opnsense.iso
## Restart after installation ends
#qvm-start opnsense
#qvm-prefs opnsense debug false
#qvm-prefs opnsense qrexec_timeout 300
#qvm-prefs opnsense guivm dom0
#qvm-create --class=DispVM -l green opnsense-dvm
#qvm-prefs opnsense-dvm autostart true
#qvm-prefs opnsense-dvm netvm sys-net
#qvm-prefs opnsense-dvm provides_network true
#qvm-features opnsense-dvm appmenus-dispvm ''
