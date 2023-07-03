#!/usr/bin/env bash
# Create a new JD number in the provided location

PARENTDIR=$1
if [ -z "$PARENTDIR" ]; then
  logger "ERROR: Base directory not provided"
  exit 1
fi 
logger $PARENTDIR
newfilename=$(zenity --entry --title "New file name (including extension)" --text "Enter new file name")
# touch is not optional
touch "$PARENTDIR/$newfilename"
/usr/bin/vendor_perl/mimeopen  "$PARENTDIR/$newfilename"
