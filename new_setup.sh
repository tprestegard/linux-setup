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
     git clone --config core.localhookspath=.githooks core.hookmergestrategy=1 git@github.com:tprestegard/linux-setup.git
     cd linux-setup
     git-crypt unlock
     ./install
  8. Set up Univa VPN and connected to it
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
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
sudo apt-get install vim git python-pip python3-pip python-virtualenv texlive texlive-latex-extra gnupg2 build-essential linux-headers-$(uname -r) git-crypt virtualenvwrapper tmux texlive-publishers git-crypt tox curl awscli docker.io docker-compose jq -y > /dev/null
sudo apt-get dist-upgrade -y > /dev/null

# Add user to docker group
echo "Adding user ${USERNAME} to docker group..."
sudo usermod -aG docker ${USERNAME}

# Run cleanup
echo "Cleaning up..."
sudo apt-get autoremove > /dev/null


# Set up git repositories -----------------------------------------------------
echo ""
echo "Setting up git repositories..."

###############################################################################
# PERSONAL REPOS ##############################################################
###############################################################################
# TODO set up functions for doing all this stuff
# TODO add other personal repos
# notes repo
cd $HOME
if [[ ! -d "personal" ]]; then
    echo -n "Creating $HOME/personal directory..."
    mkdir personal
    echo "DONE"
fi
cd personal
echo -n "Setting up notes repository..."
if [[ ! -d "notes" ]]; then
    git clone git@github.com:tprestegard/notes.git > /dev/null
    cd notes
    git config --local user.email "tprestegard@gmail.com"
    git config --local user.signingkey E70E3FE26E9D0292
    git-crypt unlock > /dev/null
    echo "DONE"
else
    echo "ALREADY SETUP"
fi

###############################################################################
# LIGO repos ##################################################################
###############################################################################
REPOS=(
    cgca-computing-team/cgca-config
    cgca-computing-team/gracedb-aws-deploy
    tanner.prestegard/gracedb
    tanner.prestegard/gracedb-client
)
cd $HOME
if [[ ! -d "ligo" ]]; then
    echo -n "Creating $HOME/ligo directory..."
    mkdir ligo
    echo "DONE"
fi
cd ligo

for REPO_PATH in "${REPOS[@]}"; do
    REPO=$(basename ${REPO_PATH})
    echo -n "Setting up ${REPO} repository..."
    if [[ ! -d "${REPO}" ]]; then
        git clone git@git.ligo.org:${REPO_PATH}.git > /dev/null
        cd ${REPO}
        git config --local user.email "tanner.prestegard@ligo.org"
        git config --local user.signingkey 01299B361C3ED495

        # Add upstream for gracedb repos
        if [[ ${REPO} =~ "gracedb" ]]; then
            git remote add upstream git@git.ligo.org:lscsoft/${REPO}.git
        fi

        echo "DONE"
        cd ../
    else
        echo "ALREADY SETUP"
    fi
done


###############################################################################
# Univa github repos ##########################################################
###############################################################################
REPOS=(tortuga tortuga-kit-awsadapter tortuga-kit-gceadapter tortuga-kit-azureadapter)
cd $HOME
if [[ ! -d "univa" ]]; then
    echo -n "Creating $HOME/univa directory..."
    mkdir univa
    echo "DONE"
fi
cd univa
for REPO in "${REPOS[@]}"; do
    echo -n "Setting up ${REPO} repository..."
    if [[ ! -d "${REPO}" ]]; then
        git clone git@github.com:UnivaCorporation/${REPO}.git > /dev/null
        cd ${REPO}
        git config --local user.email "tprestegard@univa.com"
        git config --local user.signingkey 95289B36EA2F4460
        echo "DONE"
        cd ../
    else
        echo "ALREADY SETUP"
    fi
done

###############################################################################
# Univa gitlab repos ##########################################################
###############################################################################
REPOS=(
    navops/navops-launch/automation-sdk
    navops/navops-launch/kit-uge
    navops/navops-launch/launch-webui-v2
    navops/navopsctl
    navops/navops-launch/navops-launch
    navops/navops-launch/packer/tortuga
    navops/navops-launch/univa-kit-unisight
    tprestegard/notes
)
# Check if VPN is set up
if ! ifconfig tun0 > /dev/null 2>&1; then
    echo "Univa VPN not connected! Skipping Univa github repos..."
else
    for REPO_PATH in "${REPOS[@]}"; do
        REPO=$(basename ${REPO_PATH})
        echo -n "Setting up ${REPO} repository..."
        if [[ ! -d "${REPO}" ]]; then
            git clone ssh://git@gitlab.tor.univa.com:2222/${REPO_PATH}.git > /dev/null
            cd ${REPO}
            git config --local user.email "tprestegard@univa.com"
            git config --local user.signingkey 95289B36EA2F4460
            echo "DONE"
            cd ../
        else
            echo "ALREADY SETUP"
        fi
    done
fi


# Git configuration
echo -n "Setting up global git configuration..."
git config --global core.editor vim
git config --global user.name "Tanner Prestegard"
git config --global gpg.program gpg2
git config --global commit.gpgsign true
git config --global core.hookspath ~/.githooks/hooks
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

# Install vim plugins
# TODO: skip if already done
## NERDTree
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q

## lightline
git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline

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
  - Set up Slack
  - Set up Zoom
  - Set up bookmarks
EOF
echo -e "${STUFF}\n"
