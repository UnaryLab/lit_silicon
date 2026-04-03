#!/usr/bin/env bash
set -eu

# https://unix.stackexchange.com/a/55922
trap 'killall' INT

killall() {
  trap '' INT TERM
  echo "** KILLING CHILDREN **"
  kill -TERM 0
  wait
  echo "** DONE **"
}

for iter in ./$1/*; do
  python -m chopper.profile.merge -t $iter/*.json -o $(basename $iter).pkl &
done
wait

python -m chopper.profile.merge -p *.pkl -o ts.pkl
