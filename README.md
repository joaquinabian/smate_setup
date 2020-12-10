# smate_setup

Setting-up additional programs and personal configurations to the official stellarmate image.

## Procedure

This is work in progress. Many changes are expected.
Most variables (IPs, etc) are hardcoded

In PC WIN

- Burn SD card with Stellarmate OS using Balena Etcher

In Raspi

- Put SD on Raspi and switch it on
- Stellarmate starts on Hotspot mode

In Ubuntu

- Switch PC from Network wifi to *stellarmate* wifi
- Connect with VNC Client
  - VNC Server: 10.250.250.1
  - Name: smate_hotspot
  - Password: ?
- Files -> Other Files -> Locations -> STELLARMATE (single touch) --(Opening takes time)--> Pictures --Connect as Anonymous--(Opening takes time)-->
- Copy/Paste **smate_setup** folder from **Home/programas/** to **smb://stellarmate.local/pictures/**

In Raspi

- close KStars
- Open terminal.
  - Edit --> Preferences --> Display --> Scrollback lines = 2000
  - Do:

    ``` bash
    >> cd Pictures
    >> sudo find smate_setup -type f -iname "*.sh" -exec chmod +x {} \;  # is sudo necessary ?
    >> cd smate_setup
    >> sudo ./smate_setup.sh
    ```
