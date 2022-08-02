---
# Installs a TemplateVM for Windows 11 Desktop and does some basic configuration
Create Windows 11 Desktop TemplateVM:
  qvm.vm:
    - name: windows-template
    - prefs:
      - netvm: sys-firewall
      - label: blue
      - memory: 12000
      - maxmem: 12000
      - include-in-backups: true
      - vcpus: 4
      - mac: auto
      - virt-mode: hvm

  qvm.start:
    - name: windows-template
    - drive: <string>
    - hddisk: <string>
    - cdrom: dom0:/usr/local/iso/<YOUR_INSTALLER.ISO>
    - custom-config: <string>
    - flags:
        - no-guid
        - debug
        - install-windows-tools
