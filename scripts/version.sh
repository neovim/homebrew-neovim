#!/bin/bash


# #
# Variables definitions
TMP_DIR=/tmp

NEOVIM_URI="git@github.com:neovim/neovim.git"




echo "Updating NeoVim version based on last commit from neovim repository..."

if [ -d "$TMP_DIR/neovim" ]; then

    echo "Found temporary neovim repository.";
    pushd "$TMP_DIR/neovim";
        echo "Updating repository with remote"
        git pull origin master;
        git remote update;
    popd;
else
    echo "Cloning neovim repository to temporary directory:"
    pushd $TMP_DIR;
        git clone $NEOVIM_URI;
    popd;
fi;
