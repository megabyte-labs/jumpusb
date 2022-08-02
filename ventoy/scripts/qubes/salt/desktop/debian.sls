---
Debian Desktop Template (Source -> https://app.vagrantup.com/Megabyte/boxes/Debian-Desktop):
  qvm.present:
    - name: debian-desktop
    - template: fedora-21
    - label: yellow
    - mem: 2000
    - vcpus: 4
    - flags:
      - proxy
      - template
