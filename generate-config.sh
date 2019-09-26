#!/bin/bash
set -x #echo on

JARFILE=$1
echo "THE JAR IS $JARFILE"

echo 'Create native image configuration files...'
java -agentlib:native-image-agent=config-output-dir=$PWD/config-dir-01/ -jar $JARFILE &
PID01=$!
echo "PID=$PID01"
sleep 15

java -agentlib:native-image-agent=config-output-dir=$PWD/config-dir-02/ -jar $JARFILE &
PID02=$!
echo "PID=$PID02"
sleep 15

echo 'Kill the applications...'
kill $PID01
sleep 10

kill $PID02
sleep 10

echo 'Merge both config dirs...'
native-image-configure generate --input-dir=$PWD/config-dir-01/ --input-dir=$PWD/config-dir-02/ --output-dir=$PWD/merged-config-dir/

echo 'Done'
echo 0