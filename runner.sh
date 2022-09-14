#!/bin/bash

export SSDIR=/scores/samples

echo ""
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"
echo "Enter full name of csound.csd file to compile"
echo ""
read -e -r -p "Enter score name: " SCORE
printf "csd: %s\n" "$SCORE"

docker run -v $(pwd)/scores:/scores -it mjladd/csound /usr/local/bin/csound "$SCORE"
