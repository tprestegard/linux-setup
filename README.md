# Files and documentation for setting up Linux on my personal computers

## Getting the repository
Clone the repository using SSH: git clone git@github.com:tprestegard/linux-setup.git

## Distributing the files in the repository
First, decrypt any encrypted files.
 * config (ssh config files)

## Propagating changes in your files to your local repository.

## Making commits and pushing to the remote repo
Sign with GPG key:

## Encrypting and decrypting files
gpg2 --out config.encrypted --recipient "Tanner Prestegard" --encrypt config
gpg2 --out config.dec --decrypt config.encrypted

