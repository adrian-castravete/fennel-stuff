#!/bin/sh

FENNEL_DIR=fennel-lang
FENNEL="$FENNEL_DIR/fennel"

if [ -z "$FENNEL" ]
then
  git submodule update --init --recursive
fi

find -iname '*.fnl' | grep -v "\/$FENNEL_DIR\/" | while read IN_FILE
do
  OUT_FILE="${IN_FILE%.fnl}.lua"
  $FENNEL --compile $IN_FILE > $OUT_FILE
done
$FENNEL_DIR/fennel-watch.sh
