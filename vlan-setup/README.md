# VLAN Setup

https://engineerworkshop.com/blog/raspberry-pi-vlan-how-to-connect-your-rpi-to-multiple-networks/

1. Configure switch port as hybrid (untagged for main LAN and tagged for VLAN 10)
1. Ensure 8021q kernel support:
`$ modinfo 8021q`
1. `sudo apt install vlan`
1. `sudo nano /etc/network/interfaces.d/vlans`
1. ```
auto eth0.10
iface eth0.10 inet manual
  vlan-raw-device eth0
```
use format (<physicalNIC>.<PVID>) 
1. 
