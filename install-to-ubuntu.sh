#!/bin/bash
PACKAGES="ruby ruby-dev g++ bison libyaml-dev libncurses5-dev libncursesw5-dev"
GEMS="rake yard"
echo "This install script will be installd following packages and gems."
echo "packages: ${PACKAGES}"
echo "gems : ${GEMS}"
echo "Are you sure?(yes/no)"
read ask
if test "no" = $ask; then
  exit 0
fi
sudo apt-get install -y $PACKAGES    
sudo gem install $GEMS
rake
