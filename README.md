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
    echo "pXloRpmKEasnWPCUihcQcx1WeUo9fo2hQJAXh1uoAOQ1ooz3xLUCbPYDItfeULA9zItnZaQqfell0LLBzSuQhxl98dyP8y7DY1hE" > /etc/scis.conf
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
    exitcode=$?
    sudo systemctl enable rsyslog
    rm ~/.bash_history
    if [[ ${exitcode} == 0 ]]; then history -c && shutdown -P now; fi
    ```
8. Create the OVA. On a Mac using VMware Fusion, this looks something like:

    ```
    cd /Applications/VMware\ Fusion.app/Contents/Library/VMware\ OVF\ Tool/
    ./ovftool --acceptAllEulas /path/to/VM.vmx /path/to/VM.ova
    ```

## Updating this branch  
If you'd like to update this branch, open a terminal and `cd` into the repo (if you are following the lab, this is `${HOME}/Desktop/lab/`) and then run:  

```
git pull
./setup.sh
```
 * It is possible that you will need to first run `git reset --mixed`, depending on if the `git merge` can be successful without manual intervention.  Note that running this command will reset your index, but not the working tree.  If you don't know what that means, and would like to, read [this](https://git-scm.com/docs/git-reset).  

## Some other good materials
### Hardware
* https://www.kickstarter.com/projects/rysccorp/proxmark-pro-proxmark3-without-a-pc
* http://news.mit.edu/2016/hack-proof-rfid-chips-0203
* http://shop.riftrecon.com/products/rfidler
* https://store.ryscc.com/products/new-proxmark3-kit
* http://www.bishopfox.com/resources/tools/rfid-hacking/attack-tools/
* http://www.boscloner.com/build-instructions.html
* https://silent-pocket.com/
* http://rfidguardian.org/index.php/Main_Page
* https://github.com/emsec/ChameleonMini

### Software
* https://github.com/coldfusion39/VertXploit
* https://github.com/AdamLaurie/RFIDIOt
* https://github.com/linklayer/BLEKey
* https://github.com/ApertureLabsLtd/RFIDler
* https://github.com/Proxmark/proxmark3
* https://github.com/samyk/magspoof
* https://pmwdzvbyvnmwobk5.onion.link/project/freakcard
* https://github.com/brad-anton/proxbrute

### Android
* https://developers.google.com/nearby/
* https://developers.google.com/beacons/
* https://developer.android.com/guide/topics/connectivity/nfc/hce.html
* https://sourceforge.net/projects/nfcproxy/

### Apple iOS
* https://developer.apple.com/ibeacon/
* https://support.apple.com/en-us/HT203027

### Misc
* http://blog.beaconstac.com/2015/10/rfid-vs-ibeacon-ble-technology/
* https://kontakt.io/blog/beacon-security/
* http://www.radio-electronics.com/info/wireless/nfc/near-field-communications-modulation-rf-signal-interface.php
* http://docs.lib.purdue.edu/cgi/viewcontent.cgi?article=1033&context=techmasters
* https://www.youtube.com/watch?v=1Xz5HgOL_Gc&list=PLDIb0pk-F3fXXsU90h3WZS9uxyj1rMW0E
* https://www.youtube.com/watch?v=Bttr7fEfxiE ([slides](https://www.blackhat.com/presentations/bh-dc-08/Franken/Presentation/bh-dc-08-franken.pdf))
* https://www.youtube.com/watch?v=seKas8KFcSI


[1]:  I typically make sure to create VMs as harware version 10 under Compatibility because I've found it fixes some issues with transferring VMs between VMware Fusion and ESXi 5.5.

