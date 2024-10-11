#!/bin/sh
if [ -z "$1" ]; then
    echo "Please provide a filename."
    exit 1
fi

echo "["
grep -o "REAL-TIME.*" $1 | awk '{print "("$7"," $8"),"}'
echo "]"
