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
       # git pull origin master;
       # git remote update;
    popd;
else
    echo "Cloning neovim repository to temporary directory:"
    pushd $TMP_DIR;
        git clone $NEOVIM_URI;
    popd;
fi;


function find_version ()
{

    if [ ! -f "CMakeLists.txt" ]; then
        echo "CMakeLists.txt not found. Aborting.";
        exit 1;
    fi;

    echo $(grep "set($1" CMakeLists.txt | cut -d " " -f 2 | tr -d ")");
}

echo "Finding nvim current version..."
pushd "$TMP_DIR/neovim";
    MAJOR=$(find_version NVIM_VERSION_MAJOR);
    MINOR=$(find_version NVIM_VERSION_MINOR);
    PATCH=$(find_version NVIM_VERSION_PATCH);
popd

echo "Current version: $MAJOR.$MINOR.$PATCH";
