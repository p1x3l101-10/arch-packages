#!/bin/bash

# Variables
BUILDDIR = "$(pwd)/built"

# Setup
mkdir -p "$BUILDDIR"

# List of packages to build
packages=(
  'tor-autosocket'
)

# Get package dependancies
for pkg in ${packages[@]}
do
  deps=($(./build-depresolve.bash $pkg) ${deps[@]})
  makedeps=($(./build-makedepresolve.bash $pkg) ${makedeps[@]})
done

# Ask if we need to uninstall the make dependancies after install
read -p "Do you want to delete make dependancies?[y/N] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]];then
  removeMakeDeps=1
else
  removeMakeDeps=0
fi

# Install dependancies and make dependancies
sudo pacman --asdeps -S ${deps[@]} ${makedeps[@]}

# Builder loop
for pkg in ${packages[@]}
do
  cd "$pkg"
  makepkg
  mv *.pkg.* "$BUILDDIR/"
  cd ..
done

# Install packages
cd $BUILDDIR
sudo pacman -U *.pkg.*

# Remove makedeps
if [ $removeMakeDeps -eq 1];then
  pacman -R ${makedeps[@]}
di
