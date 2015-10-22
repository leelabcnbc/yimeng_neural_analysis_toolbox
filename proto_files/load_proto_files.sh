#!/usr/bin/env bash

cd ..
# remove existing proto class directory.
rm -rf proto_classes
# extract all previous files.
tar -xvf ./proto_files/proto_files.tar.gz
cd proto_files