#!/usr/bin/env bash
# USAGE:

function usage() {
    echo "Usage: $0 <operation> {<AA.CC>|<AA.CC.AA.CC>} <object>"
    echo "Command list"
    echo "cp <NUMBER> <file> : Copies <file> to <NUMBER>"
    echo "mv <NUMBER> <file>"
    echo "ln <NUMBER> <file>"
    echo "ls <NUMBER>"
    echo "rm <NUMBER> <file>"
    echo "open <NUMBER> <file> : Open the default url from info.yaml in said NUMBER"
    echo "addurl <NUMBER> : Creates/replaces URL on info.yaml at NUMBER"
    echo "init <NUMBER> : Creates an info.yaml at NUMBER, action by default is open the folder"
    echo "editinfo <NUMBER> : Triggers default action to edit info.yaml at NUMBER"
    echo "browse <NUMBER> : Opens a rofi browser with fuzzy search for files in dir"
    echo "code <NUMBER> : Opens directory in vscode"
}

# Allowed operations:
allowed_ops=("cp" "mv" "ln" "ls" "rm" "ls" "open" "addurl" "init" "editinfo" "getdw" "browse" "code" )


BASE=~/JD
COMMAND=xdg-open
# Downloads folder, to get files from
DOWNLOADS=~/Descargas

set -e

function errcho(){ >&2 echo ERROR: $@; }
# takes a JD number and returns a path to the base directory

function getjddir() {
    # get first JD id
    JDID1=$(echo $1 | awk -F'.' 'END {print $1"."$2}')
    # maxdepth required for not capturing deeper hierarchies
    TGT_DIR=$(find $BASE -maxdepth 3 -type d -name "$JDID1*"|head -n1)
    
    if [[ -z $TGT_DIR ]]; then
        errcho "Directory not found"
        exit 1
    fi
    # There is another JDID in the input?
    JDID2=$(echo $1 | awk -F'.' 'END {print $3"."$4}')
    if [[ $JDID2 == "." ]]; then
        echo $TGT_DIR
        return
    fi
    # if continue I use $TGT_DIR as base to find the new subnumber
    # mindepth required for the corner case where the two JDID are equal, i.e "11.01.11.01"
    TGT_SUBDIR=$(find "$TGT_DIR" -mindepth 1 -type d -name "$JDID2*"|head -n1)
    
    if [[ -z $TGT_SUBDIR ]]; then
        errcho "Subirectory not found"
        exit 1
    fi
    # If I reach this point the directory exist

    echo $TGT_SUBDIR
}

# Gets a directory, returns full path to info file
function getjdinfofile() {
    TGT=$(find "$1" -iname info.yaml|head -n1)
    if [[ -z $TGT ]]; then
        errcho "Info file not found"
        exit 1
    fi
    echo $TGT
}

function getjdfield() {
    # INPUT: 
       # $1 full path to info file
       # $2 field to query, defaults to "url"
    # get a value from an JD info file
    # by default the URL

    FIELD=${2:-url}
    URL=$(cat "$1" | yq -N -r ".${FIELD} // \"\" ")
    if [[ -z $URL ]]; then
        errcho "URL not found"
        exit 1aa
    fi
    echo $URL
}

function getdw() {
# Copy the last downloaded file from the downloads folder to the specified JD ID
RECENTER=$(cd ~/Descargas && ls -t | head -n1)
echo $DOWNLOADS/$RECENTER
}

function browsefn() { 
   $COMMAND "$TGT"
}

function codefn() {
# opens a folder in vscode
$VSCODE "$TGT"
}

function check_arguments() {
    # Checks arguments
    # First argumne
    # Checks:
    # - First argument: Operation
    # - Second argument: JD number
    # - Third argument: Object for the operation
    # - NtSTG-backups-FF-111.0.1h arguments: Depends on command
    # -d DELIMITER
    # -t TARGET variable
    # Dont forget the "" around input variable
    
    if [[ $# < 2 ]]; then
        errcho Not enough arguments
        usage
        return 1
    fi

    readarray -d . -t strarr <<< "$2"

    # Only lenghts 2 or 4
    # also, each number is exactly 2 digits
    if [[ ${#strarr[@]}  = 2 ]]; then
        if [[ ${#strarr[0]} != 2 || ${#strarr[1]} != 3 ]]; then
        errcho "invalid lenght of digits"
        usage
        return 1
        fi
    elif [[ ${#strarr[@]}  = 4 ]]; then
    
        if [[ ${#strarr[0]} != 2 || ${#strarr[1]} != 2 || ${#strarr[2]} != 2 || ${#strarr[3]} != 3 ]]; then
        errcho "invalid lenght of digits"
        usage
        return 1
        fi
    else
        errcho "Invalid JD digits"
        usage
    fi

    if [[ ! " ${allowed_ops[*]} " =~ " ${1} " ]]; then
        echo Operation $1 not allowed
        usage
        return 1
    fi
}

# We require at least 2 arguments
check_arguments $* || exit 2

# check if the directory exists
TGT=$(getjddir "$2") || exit 3


   # - First argument: Operation
    # - Second argument: JD number
    # - Third argument: Object for the operation
    # - Nth arguments: Depends on command

case $1 in
  cp)
     cp -v "$3" "$TGT" 
  ;;
  mv)
     mv -v "$3" "$TGT"
  ;;
  ln)
     ln -s "$3" "$TGT"
  ;;
  ls)
     ls "$TGT"
  ;;
  rm)
    rm -v "$TGT/$3"
  ;;
  open)
    INFOFILE=$(getjdinfofile "$TGT") || exit 4
    FIELD=$3
    URL=$(getjdfield "$INFOFILE" url) || exit 5
    $COMMAND "$URL"
    ;;
  addurl)
    touch "$TGT/info.yaml"
    INFOFILE=$(getjdinfofile "$TGT") || exit 4
    yq -i e ".url |= \"$3\" " "$INFOFILE"
  ;;
  init)
  touch "$TGT/info.yaml"
  yq -i e ".url |= \"$TGT\" " "$TGT/info.yaml"
  ;;
  editinfo)
  touch "$TGT/info.yaml"
  open "$TGT/info.yaml"
  ;;
  getdw)
  LAST=$(getdw)
  echo "Last downloaded file:"
  echo "\t" $LAST
  read -n1 -p "Copy it to $TGT  (y/n)? " RESP
  echo ""
  if [[ $RESP == "y" ]]; then
  echo ""
  cp -v "$LAST" "$TGT"
  else
  echo "Cancelled"
  fi
  ;;
  code)
  codefn
  ;;
  browse)
  browsefn
  ;;
  

esac
