# smate_setup

Setting-up additional programs and personal configurations to the official stellarmate image.  
This code is a first try on bash scripting. Use at your own risk.

## Procedure

This is work in progress. Many changes are expected.
Most variables (IPs, etc) are hardcoded

In Ubuntu (or PC WIN)

- Flash SD card with Stellarmate OS using Balena Etcher
  - see <https://github.com/balena-io/etcher>

In Rasberry pi

- Put SD on Raspi and switch it on
- Stellarmate starts on Hotspot mode

In Ubuntu

- Switch PC from Network wifi to *stellarmate* wifi
- Connect with VNC Client
  - VNC Server: 10.250.250.1
  - Name: smate_hotspot
  - Password: ?
- Files -> Other Files -> Locations -> STELLARMATE (single touch) --(Opening takes time)--> Pictures --Connect as Anonymous--(Opening takes time)-->
- Copy/Paste **smate_setup** folder from **/Home/programas/** to **smb://stellarmate.local/pictures/**

In Rasberry pi (Via VNC)

- Close KStars.
- Open terminal.
  - Edit --> Preferences --> Display --> Scrollback lines = 2000
  - Do:

    ``` bash
    >> cd Pictures
    >> sudo find smate_setup -type f -iname "*.sh" -exec chmod +x {} \;  # is sudo necessary ?
    >> cd smate_setup
    >> sudo ./smate_setup.sh
    ```

## Problems

### 1. wifi driver install fails
  
`install: cannot create regular file '/lib/modules/5.4.72-v7l+/kernel/drivers/net/wireless': No such file or directory`  
An inmediate check shows the directory exists but, next day, after boot, I realise that the actual kernel is **5.4.79-v7l+**.  
I suspect this is because `apt upgrade` did a kernel upgrade but it was only updated in the system after reboot.  
The driver was installed manually with:  
`sudo install-wifi 8812au`  
To prevent this problem, a manual upgrade and reboot should be performed before running smate_setup, but at the beginning there is no wifi available...  
[Howto handle it](https://unix.stackexchange.com/questions/145294/how-to-continue-a-script-after-it-reboots-the-machine)

### 2. Get sudo: unable to resolve host master: System error

When checking hosts:

```bash  
stellarmate@master:~ $ cat /etc/hosts
127.0.0.1 localhost
::1    localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

127.0.1.1 "$NAME"
stellarmate@master:~ $ 
```

This is a bug to be fixed.  
Fixed manually for the moment.

## ToDo

- Fix problerm of wifi-driver-install fails when apt upgrade changes kernel
- Set a method to sync GPS time with system time in raspi master and slave (chrony, python...)
- Change mode to set Static IPs in the dedicated (TP-Link) router.  
  Now static IPs are defined in router. Set it as for Home Network in network manager.
