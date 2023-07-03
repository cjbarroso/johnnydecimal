#!/usr/bin/env bash
# Lists all files in the JD hierarchy
# Complement with the config of rofi-file-browser-extended to get a set of actions
# to operate on files and directories quickly

BASEDIR=${1:-~/JD}

rofi -modi file-browser-extended -show file-browser-extended  \
  -file-browser-dir $BASEDIR \
  -file-browser-depth 6 \
#  -file-browser-hide-parent \
  -file-browser-no-descend \
#  -show-icons 
