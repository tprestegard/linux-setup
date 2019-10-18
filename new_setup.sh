#! /usr/bin/env bash
# Script for setting up a machine
# TODO: add cloning/setup of Tortuga repos
# TODO: add manual setup of Univa repos behind VPN

# Print things to do before running this script
read -d '' STUFF <<"EOF"
Things to do before running this script:
  1. Set up sudo:
  2. Install Google Chrome
     (Add repo and signing key, then do 'sudo apt-get install google-chrome-stable')
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
sudo apt-get install vim git python-pip python3-pip python-virtualenv texlive texlive-latex-extra gnupg2 build-essential linux-headers-$(uname -r) git-crypt virtualenvwrapper tmux texlive-publishers git-crypt tox curl awscli docker-compose
sudo apt-get dist-upgrade

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
# Add user to docker group
sudo usermod -aG docker ${USERNAME}

# Run cleanup
echo "Cleaning up..."
sudo apt-get autoremove


# Set up git repositories -----------------------------------------------------
echo ""
echo "Setting up git repositories..."

# Don't need to do this repo (linux-setup), obviously
# notes
cd $HOME
echo -n "Setting up notes repository..."
if [[ ! -d "notes" ]]; then
    git clone --config core.hooksPath=.githooks git@github.com:tprestegard/notes.git > /dev/null
    git config --local user.email "tprestegard@gmail.com"
    git config --local user.signingkey E70E3FE26E9D0292
    cd notes
    git-crypt unlock > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

# LIGO repos
cd $HOME
if [[ ! -d "ligo" ]]; then
    echo -n "Creating $HOME/ligo directory..."
    mkdir ligo
    echo "DONE"
fi
cd ligo

# cgca-config repo
echo -n "Setting up cgca-config repository..."
if [[ ! -d "cgca-config" ]]; then
    git clone https://git.ligo.org/cgca-computing-team/cgca-config.git > /dev/null
    cd cgca-config
    git config --local user.email "tanner.prestegard@ligo.org"
    git config --local user.signingkey 01299B361C3ED495
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi
# GraceDB repos
if [[ ! -d "gracedb" ]]; then
    echo -n "Setting up $(HOME)/ligo/gracedb directory..."
    mkdir gracedb
    echo "DONE"
fi
cd gracedb
echo -n "Setting up gracedb repository..."
if [[ ! -d "gracedb" ]]; then
    git clone https://git.ligo.org/lscsoft/gracedb.git > /dev/null
    cd gracedb
    git config --local user.email "tanner.prestegard@ligo.org"
    git config --local user.signingkey 01299B361C3ED495
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up gracedb-client repository..."
if [[ ! -d "gracedb-client" ]]; then
    git clone https://git.ligo.org/lscsoft/gracedb-client.git > /dev/null
    cd gracedb-client
    git config --local user.email "tanner.prestegard@ligo.org"
    git config --local user.signingkey 01299B361C3ED495
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up gracedb-aws-deploy repository..."
if [[ ! -d "gracedb-aws-deploy" ]]; then
    git clone https://git.ligo.org/cgca-computing-team/gracedb-aws-deploy.git > /dev/null
    cd gracedb-aws-deploy
    git config --local user.email "tanner.prestegard@ligo.org"
    git config --local user.signingkey 01299B361C3ED495
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi

# Univa github repos
cd $HOME
if [[ ! -d "univa" ]]; then
    echo -n "Creating $HOME/univa directory..."
    mkdir univa
    echo "DONE"
fi
cd univa
echo -n "Setting up tortuga repository..."
if [[ ! -d "tortuga" ]]; then
    git clone git@github.com:UnivaCorporation/tortuga.git > /dev/null
    cd tortuga
    git config --local user.email "tprestegard@univa.com"
    git config --local user.signingkey 95289B36EA2F4460
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi
echo -n "Setting up tortuga-kit-awsadapter repository..."
if [[ ! -d "tortuga-kit-awsadapter" ]]; then
    git clone git@github.com:UnivaCorporation/tortuga-kit-awsadapter.git > /dev/null
    cd tortuga-kit-awsadapter
    git config --local user.email "tprestegard@univa.com"
    git config --local user.signingkey 95289B36EA2F4460
    echo "DONE"
    cd ../
else
    echo "ALREADY SETUP"
fi

# Git configuration
echo -n "Setting up global git configuration..."
git config --global core.editor vim
git config --global user.name "Tanner Prestegard"
git config --global gpg.program gpg2
git config --global commit.gpgsign true
# Don't set up email or signingkey by default - force myself to set up email and signing key separately for each one
#git config --global user.email "tprestegard@univa.com"
#git config --global user.signingkey 95289B36EA2F4460

# Install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
[[ ! -f /etc/apt/sources.list.d/kubernetes.list ]] && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install Google Cloud SDK
[[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]] && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk

# Install fish shell and select as default
sudo apt-get install fish
[[ ! "${SHELL}" =~ "fish" ]] && chsh -s $(which fish)

# Install virtualfish
sudo pip install virtualfish

# Things to do manually at the end
echo ""
read -d '' STUFF <<"EOF"
You're all set!  Other things to do manually:
  - Log out and log back in so your group memberships are re-evaluated
  - Change terminal shortcuts
    - Shift + arrow for moving between tabs
    - Ctrl + Shift + arrow for moving tab positions
  - Change terminal color scheme
  - Change settings
    - Set Ctrl+Alt+T as a custom shortcut for starting new terminal
    - Turn display off after 15 minutes
  - Set up Univa VPN
EOF
echo "${STUFF}"
echo ""
