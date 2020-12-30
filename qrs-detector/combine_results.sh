#!/bin/bash

if [ ! -e eval1.txt -o ! -e eval2.txt ]; then
  echo "missing eval1.txt and eval2.txt"
  exit
fi

sumstats eval1.txt eval2.txt | tee results.txt
rm eval1.txt eval2.txt