#!/usr/bin/env bash
# Create a new JD number in the provided location

PARENTDIR=$1
if [ -z "$PARENTDIR" ]; then
  echo "ERROR: Base directory not provided"
  exit 1
fi 

# First we find the last directory in directory
LAST=$(ls -1 "$PARENTDIR" | sort | tail -n1 | awk '{print $1}')

# Now we separate the AREA part from the ID part
readarray -d . -t strarr <<< "$LAST"

# Calculate new JDID to suggest on directory creation
AREA=${strarr[0]}
PREID=$(( ${strarr[1]} + 1))
NEWID=$(printf "$AREA.%02d" $PREID)

newdirname=$(zenity --entry --title "New directory name" --entry-text "$NEWID " --text "Enter new directory name")

mkdir -p "$PARENTDIR/$newdirname"

