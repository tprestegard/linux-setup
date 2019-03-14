#! /usr/bin/env bash
# Script for setting up a machine


# Print things to do before running this script
read -d '' STUFF <<"EOF"
Things to do before running this script:
  1. Set up sudo:
  2. Install Google Chrome (sudo apt-get install google-chrome-stable)
  3. Add LastPass to Chrome
  4. Set up GPG keys
  5. Set up SSH keys
  6. Install git-crypt (sudo apt-get install git-crypt)
  7. Clone this repository (circular logic) and run the setup script
     cd $HOME
     git clone --config core.hooksPath=.githooks git@github.com:tprestegard/linux-setup.git
     cd linux-setup
     git-crypt unlock
     ./install
EOF
echo "${STUFF}"

# Ask user if they have done this stuff
echo -n "Have you completed these steps (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ]; then
    echo "OK, then do them! Exiting..."
    exit 1
fi

# Still check if sudo is installed
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

# Install VirtualBox Additions
if [[ ${IS_VM} -eq 1 ]]; then
    echo -n "Checking if VirtualBox Additions are installed on this VM..."
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

# Run apt-get update/upgrade/dist-upgrade
echo "Updating and installing packages..."
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install vim git python-pip python-virtualenv texlive texlive-latex-extra gnupg2 build-essential linux-headers-$(uname -r) git-crypt virtualenvwrapper gem ruby-dev dirmngr openconnect tmux texlive-publishers git-crypt tox
sudo apt-get dist-upgrade

# Run cleanup
echo "Cleaning up..."
sudo apt-get autoremove

# Install hiera stuff for eyaml functionality
echo "Installing gems..."
sudo gem install hiera hiera-eyaml hiera-eyaml-gpg gpgme puppet-lint --conservative

# Install newer version of yamllint
echo "Installing newer version of yamllint..."
sudo pip install yamllint

# For physical computers, install vagrant and virtualbox
if [[ ${IS_VM} -eq 0 ]]; then
    echo -n "Installing vagrant and virtualbox..."
    sudo apt-get install vagrant virtualbox -y
fi

# Set up git repositories -----------------------------------------------------
echo ""
echo "Setting up git repositories..."

# Don't need to do this repo (linux-setup), obviously
# notes
cd $HOME
echo -n "Setting up notes repository..."
if [[ ! -d "notes" ]]; then
    git clone --config core.hooksPath=.githooks git@github.com:tprestegard/notes.git > /dev/null
    cd notes
    git-crypt unlock > /dev/null
    git config --local user.email "tprestegard@gmail.com"
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

# Work repos
cd $HOME
if [[ ! -d "work" ]]; then
    echo -n "Creating $HOME/work directory..."
    mkdir work
    echo "DONE"
fi
cd work
echo -n "Setting up cgca-config repository..."
if [[ ! -d "cgca-config" ]]; then
    git clone --config core.hooksPath=.githooks git@git.ligo.org:cgca-computing-team/cgca-config.git > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

# GraceDB repos
if [[ ! -d "gracedb" ]]; then
    echo -n "Setting up $(HOME)/work/gracedb directory..."
    mkdir gracedb
    echo "DONE"
fi
cd gracedb
echo -n "Setting up gracedb repository..."
if [[ ! -d "gracedb" ]]; then
    git clone git@git.ligo.org:lscsoft/gracedb.git > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up gracedb-client repository..."
if [[ ! -d "gracedb-client" ]]; then
    git clone git@git.ligo.org:lscsoft/gracedb-client.git > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up personal fork of gracedb repository..."
if [[ ! -d "fork_gracedb" ]]; then
    git clone git@git.ligo.org:tanner.prestegard/gracedb.git fork_gracedb > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

# LVAlert repos
if [[ ! -d "../lvalert" ]]; then
    echo -n "Setting up $(HOME)/work/lvalert directory..."
    mkdir ../lvalert
    echo "DONE"
fi
cd ../lvalert
echo -n "Setting up lvalert repository..."
if [[ ! -d "lvalert" ]]; then
    git clone git@git.ligo.org:lscsoft/lvalert.git
    echo "DONE"
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up lvalert-overseer repository..."
if [[ ! -d "lvalert-overseer" ]]; then
    git clone git@git.ligo.org:lscsoft/lvalert-overseer.git
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

# Git configuration
echo -n "Setting up git configuration..."
git config --global core.editor vim
git config --global user.name "Tanner Prestegard"
git config --global user.email "tanner.prestegard@ligo.org"
git config --global gpg.program gpg2
git config --global user.signingkey 1C3ED495
git config --global commit.gpgsign true

# Use gmail for linux-setup and notes
cd $HOME/linux-setup
git config --local user.email "tprestegard@gmail.com"
echo "DONE"

# Install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Things to do manually at the end
echo ""
read -d '' STUFF <<"EOF"
You're all set!  Other things to do manually:
  - Set up ldg-client; can be tricky depending on OS.  Here is the command:
      wget http://www.lsc-group.phys.uwm.edu/lscdatagrid/doc/ldg-client.sh -O /tmp/ldg-client.sh && sudo bash /tmp/ldg-client.sh
    You might have to do some editing of the script, changing the repositories, etc.
    You also might need to install osg-ca-certs with this file (or a newer version):
      https://vdt.cs.wisc.edu/svn/certs/trunk/cadist/release/osg-ca-certs-1.74NEW-0.deb
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
echo ""
