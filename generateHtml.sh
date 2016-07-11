#!/usr/bin/env bash

CurrentTime=$(date +%Y%m%d%H%M)
cp index.html backup/index.html."$CurrentTime"
cp template index.html

echo "start convert"
#ruby converty.rb
echo "convert done, you can commit and push it"
