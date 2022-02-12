# VLAN Setup

https://engineerworkshop.com/blog/raspberry-pi-vlan-how-to-connect-your-rpi-to-multiple-networks/

1. Configure switch port as hybrid (untagged for main LAN and tagged for VLAN 10)
1. Ensure 8021q kernel support: `modinfo 8021q`
1. `sudo apt install vlan`
1. `sudo nano /etc/network/interfaces.d/vlans`
    ```
    auto eth0.10
    iface eth0.10 inet manual
    vlan-raw-device eth0
    ```
    use format `<physicalNIC>.<PVID>`
1. ```sudo nano /etc/dhcpcd.conf```
   ```
   # Static IP LAN
   interface eth0
   static ip_address=192.168.0.2/24
   static routers=192.168.0.1
   static domain_name_servers=9.9.9.9 9.9.9.9
   
   # Static IP VLAN 10
   interface eth0.10
   static ip_address=192.168.10.2/24
   static routers=192.168.10.1
   static domain_name_servers=
   ```
1. ```sudo reboot```
1. ```hostname -I``` Ensure it returns the new VLAN IP
