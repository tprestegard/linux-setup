# Files and documentation for setting up Linux on my personal computers

## Getting the repository
Clone the repository using SSH and set up the git hooks:

```bash
git clone --config core.hooksPath=.githooks git@github.com:tprestegard/linux-setup.git
```

If you've already cloned the repository, set up the hooks with:

```bash
git config --local core.hooksPath .githooks
```

### Description of hooks
Change file access permissions for protected files.

### Decrypt protected files
`git-crypt unlock`

## Other stuff to set up

### Personal

* git
* pip
* emacs
* Chrome
* LastPass
* Thunderbird
* Enigmail
* GNUpg - disable gnome-keyring, add "use-agent" to gpg.conf
* PlayOnLinux
* Music player (Rhythmbox or Banshee) + Last.fm plugin
* Unity Tweak Tool
* Laptops only: lid close setting
* Debian only - GNOME: no top-left-hot-corner

### Work-only
* TeamSpeak (plus launcher)
* ligo-proxy-init
* Django
* VMWare
* Remote Desktop
* openconnect7: install gettext, libssl-dev, libxml2-dev. Add /usr/local/sbin to PATH, /usr/local/lib to LD_LIBRARY_PATH. Add vpnc-script and chmod u+x.
* virtualenv
* virtualenvwrapper
