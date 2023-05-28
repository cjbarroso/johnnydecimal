#!/usr/bin/env bash
# Create a new JD number in the provided location

PARENTDIR=$1
if [ -z "$PARENTDIR" ]; then
  echo "ERROR: Base directory not provided"
  exit 1
fi 
newfilename=$(zenity --entry --title "New file name (including extension)" --text "Enter new file name")
# touch is not optional
touch "$PARENTDIR/$newfilename"
mimeo "$PARENTDIR/$newfilename"