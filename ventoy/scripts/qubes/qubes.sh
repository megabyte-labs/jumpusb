#!/bin/bash
https://github.com/endeavouros-team/endeavouros-xfce4-theming
https://www.whonix.org/wiki/Qubes/Install#Update_dom0
sudo qubesctl --show-output state.sls update.qubes-dom0
sudo qubes-dom0-update --clean -y
sudo qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm
sudo qubesctl --show-output --skip-dom0 --standalones state.sls update.qubes-vm
