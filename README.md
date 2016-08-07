# 2016-08-11 Steel City Information Security Lab
http://www.meetup.com/Steel-City-InfoSec/events/227075388/

## How to clone this branch
* `git clone -b ProximityAttacks --single-branch --recursive https://github.com/JonZeolla/lab`
  * Clone the latest revision of the ProximityAttacks branch, and automatically bring in the related submodules.
* `git clone -b 2016-08-11_SCIS_ProximityAttacks --single-branch --recursive https://github.com/JonZeolla/lab`
  * Clone the revision of the ProximityAttacks branch used during the 2016-08-11 Steel City InfoSec lab.  Cloning any of the pointers (tags) will put you in a detached HEAD state, which is expected.

## How to setup the lab
### Configure the lab manually  
If you'd like to configure this lab on your own system, from the top level of the source code repository run:
`./setup.sh`

### Use the provided Virtual Machine
A VM will be provided for the lab (TODO).  Only **VMWare hypervisors** have been tested with the following configuration.  
##### Login Credentials
* Username:  prox
* Password:  P@ssword

### Configure a new VM for distribution
1. Install Kali 2016.1 in a VM[1]
2. Login as root, then open a terminal
3. (optional) Take a snapshot
4. Run the following commands:

    ```
    apt-get -y update && apt-get -y upgrade
    apt-get -y install open-vm-tools-desktop fuse
    history -c && gnome-session-quit
    ```
5. VM Tools should now be active, allowing you to easily copy and paste into the VM.  Login as root again, then open a terminal and run the following commands:

    ```
    echo -e "# Add additional sbin and bin directories to \$PATH\nexport PATH=\$PATH:\${HOME}/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/devkitpro/devkitARM/bin/\n\n# Include .bashrc if it exists\nif [ -f "\${HOME}/.bashrc" ]; then\n  . "\${HOME}/.bashrc"\nfi\n" > /etc/skel/.bash_profile
    echo -e "# Kali rolling repos\ndeb http://http.kali.org/kali kali-rolling main contrib non-free\n#deb-src http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list
    echo -e "\n\n# Add additional sbin and bin directories to \$PATH\nexport PATH=\$PATH:\${HOME}/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/devkitpro/devkitARM/bin/\n" >> /etc/skel/.profile
    echo "pXloRpmKEasnWPCUihcQcx1WeUo9fo2hQJAXh1uoAOQ1ooz3xLUCbPYDItfeULA9zItnZaQqfell0LLBzSuQhxl98dyP8y7DY1hE" >> /etc/scis.conf
    useradd -m -p $(openssl passwd -1 P@ssword) -s /bin/bash -c "SCIS Proximity Attacks User" -G sudo prox
    history -c && gnome-session-quit
    ```
6. Login as prox and rearrange the Favorites shortcuts as appropriate
7. Open a terminal and run the following commands:

    ```
    sudo systemctl disable rsyslog;sudo systemctl stop rsyslog
    sudo logrotate -f /etc/logrotate.conf
    sudo rm -rf /var/log/*1 /var/log/*old /var/log/*gz
    cd ${HOME}/Desktop
    git clone -b ProximityAttacks --single-branch --recursive https://github.com/JonZeolla/lab
    lab/setup.sh
    sudo systemctl enable rsyslog
    rm ~/.bash_history
    history -c && shutdown -P now
    ```
8. Create the OVA. On a Mac using VMware Fusion, this looks something like:

    ```
    cd /Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/
    ./ovftool --acceptAllEulas /path/to/VM.vmx /path/to/VM.ova
    ```

## Some other good materials
### Hardware
* http://news.mit.edu/2016/hack-proof-rfid-chips-0203
* http://shop.riftrecon.com/products/rfidler
* https://store.ryscc.com/products/new-proxmark3-kit
* http://www.bishopfox.com/resources/tools/rfid-hacking/attack-tools/
* http://www.boscloner.com/build-instructions.html
* https://silent-pocket.com/

### Software
* https://github.com/coldfusion39/VertXploit
* https://github.com/AdamLaurie/RFIDIOt
* https://github.com/linklayer/BLEKey
* https://github.com/ApertureLabsLtd/RFIDler
* https://github.com/Proxmark/proxmark3
* https://github.com/samyk/magspoof
* https://pmwdzvbyvnmwobk5.onion.link/project/freakcard

### Android
* https://developers.google.com/nearby/
* https://developers.google.com/beacons/
* https://developer.android.com/guide/topics/connectivity/nfc/hce.html

### Apple iOS
* https://developer.apple.com/ibeacon/
* https://support.apple.com/en-us/HT203027

### Misc
* http://blog.beaconstac.com/2015/10/rfid-vs-ibeacon-ble-technology/
* https://kontakt.io/blog/beacon-security/
* http://www.radio-electronics.com/info/wireless/nfc/near-field-communications-modulation-rf-signal-interface.php
* http://docs.lib.purdue.edu/cgi/viewcontent.cgi?article=1033&context=techmasters


[1]:  I typically make sure to create VMs as harware version 10 under Compatibility because I've found it fixes some issues with transferring VMs between VMware Fusion and ESXi 5.5.

