#! /usr/bin/env bash
# Reference:
# https://github.com/Cockatrice/Cockatrice/wiki/Compiling-Cockatrice-(Linux)#ubuntu-1604-and-later
set -e

# Check if user is root
if [[ "${EUID}" != 0 ]]; then
    echo "Please run this script as root. Exiting..."
    exit 1
fi

# Install dependencies
apt-get install git \
    build-essential \
    g++ \
    cmake \
    libprotobuf-dev \
    protobuf-compiler \
    qt5-default \
    qttools5-dev \
    qttools5-dev-tools \
    qtmultimedia5-dev \
    libqt5multimedia5-plugins \
    libqt5svg5-dev \
    libqt5sql5-mysql \
    libqt5websockets5-dev

# Clone repo
git clone git://github.com/Cockatrice/Cockatrice

# Build
cd Cockatrice
mkdir build
cd build
cmake .. -DWITH_SERVER=1
make package
