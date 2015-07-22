#!/usr/bin/env bash

# remove existing dirs
rm -rf NPMK
rm -rf NPMK-3.1.3.0
tar -xvf NPMK-3.1.3.0.tar.gz
# move the inner NPMK folder out by one level.
mv NPMK-3.1.3.0/NPMK .
rm -rf NPMK-3.1.3.0
