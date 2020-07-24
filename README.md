# linux-setup
Repo containing files and ansible configuration for setting up my Linux workstations.


## Instructions
* Make sure sudo is installed and user account can use it
* Install packages
  ```
  sudo apt-get install vim git ansible gnupg2
  ```
* Add GPG and SSH keys: `gpg2 --import keys.gpg`
* Clone this repo
  ```
  git clone  git@gitlab.com:tprestegard/linux-setup.git
  ```
* Run `ansible-playbook`
  ```
  ansible-playbook --connection=local --inventory 127.0.0.1, --limit 127.0.0.1 ansible/local.yaml -i ansible/hosts --ask-become-pass
  # NOTE: comma in inventory is important
  ```


## Final manual steps
* Change terminal shortcuts anad color scheme
* Set up LastPass in Chrome: enable native messaging (Click icon -> Account Options -> About LastPass)
* Set up Chrome bookmarks
* Set up Thunderbird
* Copy music and personal directory from external hard drive
* Any graphics card or wireless drivers
* Install games in Lutris
* Build/install Cockatrice


## Other useful info
See all ansible facts:
```
ansible -m setup 127.0.0.1
```
