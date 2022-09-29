#!/bin/bash

# Dot to SVG "compiler" for the project

SRC_DIR="src"
TARGET_DIR="target"

DOT_FILES="$(find $SRC_DIR -type f -name '*.dot')"

rm -rf $TARGET_DIR # cleanup the target dir

for DOT_FILE in $DOT_FILES; do
  echo "Processing $DOT_FILE file..."
  SVG_FILE="$(basename $DOT_FILE | awk -F. '{ print $1 }').svg"
  echo "Generating $SVG_FILE for $DOT_FILE"
  SRC_DOT_DIR="$(dirname $DOT_FILE)"
  OUT_DIR="${TARGET_DIR}/${SRC_DOT_DIR#*/}"
  mkdir -p $OUT_DIR
  cat "${DOT_FILE}" | dot -T svg -o "$OUT_DIR/${SVG_FILE}"
  if [ $? -ne 0 ]; then
    echo "Could not process ${DOT_FILE}, exiting..."
    exit 1
  fi
  echo "Storing it into $OUT_DIR/${SVG_FILE}"
done
