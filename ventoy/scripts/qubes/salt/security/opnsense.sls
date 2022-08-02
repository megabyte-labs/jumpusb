---
# This file defines a disposable HVM NetVM with OPNSense (along with an HVM TemplateVM)
# that you can use behind sys-net (or as a replacement).

Create OPNSense TemplateVM:
  qvm.vm:
    - name: opnsense-template
    - prefs:
      - netvm: sys-firewall
      - label: orange
      - memory: 8000
      - maxmem: 8000
      - include-in-backups: true
      - vcpus: 2
      - mac: auto
      - virt-mode: hvm
    - flags:
      - proxy
      - hvm-template
      - net
      - standalone

  qvm.start:
    - name: opnsense-template
    - cdrom: dom0:/mnt/jumpusb/iso/opnsense/opnsense-latest.iso
    - flags:
        - no-guid
        - proxy
