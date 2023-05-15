#!/usr/bin/env bash
BASEDIR=${1:-~/JD}

rofi -modi file-browser-extended -show file-browser-extended  \
  -file-browser-dir $BASEDIR \
  -file-browser-depth 6 \
  -file-browser-only-dirs \
  -file-browser-hide-parent \
  -file-browser-no-descend \
  -show-icons 