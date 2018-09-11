#! /usr/bin/env bash
# Script for setting up a machine

# Determine whether this is a virtual or physical machine
echo -n "Checking if this is a virtual machine..."
hostnamectl | grep "Chassis: vm" > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "YES"
    IS_VM=1
else
    echo "NO"
    IS_VM=0
fi

# Check if sudo is installed
echo -n "Checking if sudo is installed..."
dpkg -s sudo > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo -e "NO\n"
    echo "To install sudo: as root, do 'apt-get install sudo; adduser $(whoami) sudo; shutdown -r now'"
    echo "Exiting..."
    exit 1
else
    echo "OK"
fi

# Install VirtualBox Additions
if [[ ${IS_VM} -eq 1 ]]; then
    echo -n "Checking if VirtualBox Additions are installed..."
    if [[ $? -ne 0 ]]; then
        echo -e "NO\n"
        echo -e "To install VirtualBox Additions:"
        echo -e "\tGo to Devices -> Optical Drives -> Remove disk from virtual drive (force unmount if needed)"
        echo -e "\tGo to Devices -> Insert Guest Additions CD image"
        echo -e "\tAs root, do 'sh /media/cdrom/VBoxLinuxAdditions.run'"
        echo -e "\tRestart the VM"
        echo -e "Exiting..."
        exit 1
    else
        echo "OK"
    fi
fi

#Add LastPass to browser
#GPG keys
#SSH keys

# Run apt-get update/upgrade/dist-upgrade
echo "Updating and installing packages..."
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install vim git python-pip python-virtualenv texlive texlive-latex-extra gnupg2 build-essential linux-headers-$(uname -r) git-crypt virtualenvwrapper gem ruby-dev dirmngr openconnect tmux texlive-publishers
sudo apt-get dist-upgrade

# Install hiera stuff for eyaml functionality
sudo gem install hiera hiera-eyaml hiera-eyaml-gpg gpgme puppet-lint 

# Install newer version of yamllint
sudo pip install yamllint

# For physical computers, install vagrant and virtualbox
if [[ ${IS_VM} -eq 0 ]]; then
    echo -n "Installing vagrant and virtualbox..."
    echo "NOT IMPLEMENTED"
fi

# Things to do manually at the end
echo ""
read -d '' STUFF <<"EOF"
Other things to do manually:
- Change terminal shortcuts
    - Shift + arrow for moving between tabs
    - Ctrl + Shift + arrow for moving tab positions
- Change terminal color scheme
- Change settings
    - Set Ctrl+Alt+T as a custom shortcut for starting new terminal
    - Turn display off after 15 minutes
- Add ultimate trust to CGCA GPG keys
    - Do 'gpg2 --edit-key "Name", then "trust", 5, y'
EOF
echo "${STUFF}"

exit

Set up git-crypt
git repositories:
    cd $HOME
    git clone --config core.hooksPath=.githooks git@github.com:tprestegard/linux-setup.git; cd linux-setup; git-crypt unlock; ./install
    cd $HOME
    git clone --config core.hooksPath=.githooks git@github.com:tprestegard/notes.git; cd notes; git-crypt unlock
    cd $HOME; mkdir work; cd work
    git clone --config core.hooksPath=.githooks git@git.ligo.org:cgca-computing-team/cgca-config.git
    mkdir gracedb; cd gracedb
    git clone git@git.ligo.org:lscsoft/gracedb.git
    git clone git@git.ligo.org:lscsoft/gracedb-client.git
    git clone git@git.ligo.org:tanner.prestegard/gracedb.git fork_gracedb
    mkdir ../lvalert; cd ../lvalert
    git clone git@git.ligo.org:lscsoft/lvalert.git
    git clone git@git.ligo.org:lscsoft/lvalert-overseer.git
git configuration:
    git config --global core.editor vim
    git config --global user.name "Tanner Prestegard"
    git config --global user.email "tanner.prestegard@ligo.org"
    git config --global gpg.program gpg2
    git config --global user.signingkey 1C3ED495
    git config --global commit.gpgsign true
    For linux-setup: git config --local user.email "tprestegard@gmail.com"
Set up ldg-client
    wget http://www.lsc-group.phys.uwm.edu/lscdatagrid/doc/ldg-client.sh -O /tmp/ldg-client.sh && sudo bash /tmp/ldg-client.sh
