#!/usr/bin/env bash
# Opens the default URL given a JD ID

JDBIN=./openjd.sh

jdid=$(zenity --entry --title "Open JDID"s --text "Open default URL for:")

# Check if user clicked "Cancel" or closed the dialog
if [ $? -eq 1 ]; then
  echo "User canceled input"
  exit 1
fi

$JDBIN open $jdid url
# Do something with the input
echo "User entered: $jdid"