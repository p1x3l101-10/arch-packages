#!/bin/bash

# Setup
mkdir -p built

# List of packages to build
packages=(
  'tor-autosocket'
)

# Get package dependancies


# Builder loop
for pkg in ${packages[@]}
do
  cd $pkg
  makepkg
  
