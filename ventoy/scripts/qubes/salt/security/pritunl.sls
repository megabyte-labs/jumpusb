---
# This file spins up an HVM TemplateVM and disposable VM for an instance of Pritunl. The Pritunl server
# instance uses the OPNSense NetVM instead of the default sys-net VM.

# Installation script can be found at: https://pritunl.com (make sure the server installation is used and not the client installation)
# sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list << EOF
# deb https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse
# EOF
# sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
# deb https://repo.pritunl.com/stable/apt focal main
# EOF
# sudo apt --assume-yes install gnupg
# wget -qO- https://www.mongodb.org/static/pgp/server-5.0.asc | sudo tee /etc/apt/trusted.gpg.d/mongodb-org-5.0.asc
# gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
# gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
# sudo apt update
# sudo apt --assume-yes install pritunl mongodb-org
# sudo systemctl start pritunl mongod
# sudo systemctl enable pritunl mongod

Clone Ubuntu 20.04 for Pritunl:
  qvm.clone:
    - name: pritunl-template
    - source: ubuntu-20-hvm
    - label: black
