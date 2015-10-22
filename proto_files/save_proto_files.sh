#!/usr/bin/env bash

# remove previous backup of protofiles.
rm -rf ./proto_files.tar.gz
cd ..
# pack all files under proto_classes in a tar.gz file.
tar -cvzf ./proto_files/proto_files.tar.gz proto_classes
cd proto_files