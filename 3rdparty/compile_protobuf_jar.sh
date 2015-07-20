#!/usr/bin/env bash

tar xvf protobuf-2.6.1.tar.gz

# check we have correct version of protoc. Not sure if this script will work everywhere. I'm not familiar with shell scripting.
if protoc --version | grep 2.6.1
then
    echo "correct version of protoc"
else
    echo "incorrect version of protoc"
fi

# ok, let's generate the *.java files for protobuf
cd protobuf-2.6.1/java
protoc --java_out=src/main/java -I../src ../src/google/protobuf/descriptor.proto
# compile
mkdir bin

if [ "$#" -eq 1 ]
then
    usewin="$1"
else
    usewin=0 # use linux rt.jar.
fi
echo "use windows rt.jar: $usewin"


if [ "$usewin" -eq 0 ]
then
    echo "use linux rt.jar"
    javac -d bin -source 1.6 -target 1.6 -bootclasspath ../../jre_16/rt.jar src/main/java/com/google/protobuf/*.java
    jar cvf ../../protobuf-java-2.6.1.jar -C bin .
else
    # use windows. it gives you same jar, in the end! (You can expand two jars and examine)
    echo "use windows rt.jar"
    javac -d bin -source 1.6 -target 1.6 -bootclasspath ../../jre_16/rt_win.jar src/main/java/com/google/protobuf/*.java
    jar cvf ../../protobuf-java-2.6.1_win.jar -C bin .
fi
cd ../..
rm -rf protobuf-2.6.1