#!/bin/bash

PATH_DB=../ltstdb

record=$1
to=$2

copied=

if [ -n "$to" ]; then
  if [ ! -e "${record}.dat" ]; then
    copied=".dat .hea .atr"
  fi
else
  if [ -e "$PATH_DB/${record}m.mat" ]; then
    copied="m.mat .hea .atr"
  else
    copied=".dat .hea .atr"
  fi
fi

if [ -n "$copied" ]; then 
  echo "copying $copied..."
  for e in $copied; do
    cp "$PATH_DB/${record}$e" .
  done
fi

generated=
if [ ! -e "${record}m.mat" ]; then
  generated=1
  if [ -n "$to" ]; then
    echo 'converting to matlab format...'
    wfdb2mat -r $record -t $to > /dev/null
  else
    wfdb2mat -r $record > /dev/null
  fi
fi

echo 'running classifier...'
matlab -nodisplay -nosplash -batch "classifier('$record')" || exit

wrann -r $record -a det < $record.cls

if [ -n "$to" ]; then
  rdann -r $record -a atr -t $to | wrann -r $record -a att
else
  cp $record.atr $record.att
fi

bxb -r $record -a att det -l eval1.txt eval2.txt -o

head -1 eval1.txt
tail -1 eval1.txt

if [ -n "$copied" ]; then
  echo "removing copied $copied..."
  for e in $copied; do
    rm "${record}$e"
  done
fi
if [ -n "$generated" ]; then
  echo 'removing generated files'
  if [ -e "${record}m.mat" ]; then 
    rm "${record}m.mat"
    rm "${record}m.hea"
  fi
fi
rm "${record}.cls"
rm "${record}.det"
rm "${record}.att"

