#!/usr/bin/env bash

protoc --java_out=../proto_classes rewarded_trial_template.proto

# then compile Java class files.
javac -cp ../3rdparty/protobuf-java-2.6.1.jar -d ../proto_classes -source 1.6 -target 1.6 -bootclasspath ../3rdparty/jre_16/rt.jar ../proto_classes/com/leelab/monkey_exp/*.java
