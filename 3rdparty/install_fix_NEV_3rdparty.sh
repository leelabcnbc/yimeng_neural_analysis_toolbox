#!/usr/bin/env bash

# remove existing dirs
rm -rf matoff_076
unzip matoff_076_4apr14.zip
# move required files to +fix_NEV
mv matoff_076/CortexExplorer/ce_read_cortex_index.m ../+fix_NEV
mv matoff_076/CortexExplorer/ce_read_cortex_record.m ../+fix_NEV
# fix some permission problems before removing.
chmod -R u+w matoff_076
rm -rf matoff_076
