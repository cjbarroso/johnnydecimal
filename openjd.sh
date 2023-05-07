#!/usr/bin/env bash
# First argument is the operation
# Remaining are arguments for the selected operation

BASE=~/JD
COMMAND=open
set -e

allowed_ops=("cp" "mv" "ln" "ls" "rm" "ls" "open" "addurl" "init" "editinfo" )

function errcho(){ >&2 echo ERROR: $@; }
# takes a JD number and returns a path to the base directory

function getjddir() {
    # get first JD id
    JDID1=$(echo $1 | awk -F'.' 'END {print $1"."$2}')
    
    TGT_DIR=$(find $BASE -type d -name "$JDID1*"|head -n1)
    
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
    TGT_SUBDIR=$(find "$TGT_DIR" -type d -name "$JDID2*"|head -n1)
    
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
        exit 1
    fi
    echo $URL
}

function usage() {
    echo "Usage: $0 <operation> {<AA.CC>|<AA.CC.AA.CC>} <object>"
}

function check_arguments() {
    # Checks arguments
    # First argumne
    # Checks:
    # - First argument: Operation
    # - Second argument: JD number
    # - Third argument: Object for the operation
    # - Nth arguments: Depends on command
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
esac


# check_input $1 || exit 4

# function jncd() {
# HOLA=$(getjddir "$1") || exit 1
# }

# function jnopen() {
# TGT_DIR=$(getjddir "$1")|| exit 1
# TGTFILE=$(getjdinfofile "$TGT_DIR") || exit 2
# URL=$(getjdfield "$TGTFILE") || exit 3
# }

# #TGT_DIR=$(getjddir "$1")|| exit 1


# [[ ! -z $? ]] && exit $?

# URL=$(getjdfield "$TGTFILE") || exit 3
# echo $URL

# all cases except unary operator can be found with find
# echo $LEN

# $COMMAND $URL  
# valor=$(yq '.url' info.yaml)
#echo "999999999999999"
#echo $valor
#echo "999999999999999"
#Print each value of Array with the help of loop  
# for (( n=0; n < ${#strarr[*]}; n++ ))  
# do  
# echo "${strarr[n]}"  
# done  

# extract url with yq