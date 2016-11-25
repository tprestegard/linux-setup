# Files and documentation for setting up Linux on my personal computers

## Getting the repository
Clone the repository using SSH: git clone git@github.com:tprestegard/linux-setup.git

## Distributing the files in the repository
Run the install script.
 * Description of install script.
 * Handling of currently existing files.

Reverting the install.

## Encrypting and decrypting files
Encrypting: gpg2 --recipient "Tanner Prestegard" --out .pypirc.encrypted --encrypt .pypirc

Decrypting: gpg2 --out .pypirc --decrypt .pypirc.encrypted

## Making commits and pushing to the remote repo
Sign with GPG key:

## Other stuff to set up

### Personal
git
Thunderbird
Chrome
LastPass
GNUpg - disable gnome-keyring, add "use-agent" to gpg.conf
Enigmail
PlayOnLinux
Debian only - GNOME: no top-left-hot-corner
Music player (Rhythmbox or Banshee) + Last.fm plugin
pip
emacs
Unity Tweak Tool
Laptops only: lid close setting

### Work-only
TeamSpeak (plus launcher)
ligo-proxy-init
Django
VMWare
Remote Desktop
Openconnect7: install gettext, libssl-dev, libxml2-dev. Add /usr/local/sbin to PATH, /usr/local/lib to LD_LIBRARY_PATH. Add vpnc-script and chmod u+x.
virtualenv
virtualenvwrapper
