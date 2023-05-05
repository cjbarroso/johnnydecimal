#!/usr/bin/env bash
# Assumes the leaf directories have the complete JD number in the name, like
# 01.11.32.93 if its a leaf inside a directory inside work projects inside Projects
# TODO: Implement more sophistication to query INSIDE projects
BASE=~/JD
COMMAND=open
# set -e

function errcho(){ >&2 echo ERROR: $@; }
# takes a JD number and returns a path to the base directory
function getjddir() {
    TGT_DIR=$(find $BASE -type d -name "$1*"|head -n1)
    if [[ -z $TGT_DIR ]]; then
        errcho "Directory not found"
        exit 1
    fi
    echo $TGT_DIR
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
    # get a value from an JD info file
    # by default the URL
    # INPUT: 
       # $1 full path to info file
       # $2 field to query, defaults to "url"
    FIELD=${2:-url}
    URL=$(cat "$1" | yq -N -r ".${FIELD} // \"\" ")
    if [[ -z $URL ]]; then
        errcho "URL not found"
        exit 1
    fi
    echo $URL
}

function check_input() {
    # -d DELIMITER
    # -t TARGET variable
    # Dont forget the "" around input variable
    if [[ $# < 1 ]]; then
        errcho "JD number required as input"
        return 1
    fi

    readarray -d . -t strarr <<< "$1" 
    # array lenght
    LEN=${#strarr[@]}
    # I use $ (( )) to convert a null to 0 and be able to compare
    # bash conditionals are hard
    if [[ $LEN < 2 || $(( ${strarr[1]} )) == 0 ]]; then
        errcho "Unary operator not supported (yet)"
        return 1
    fi
}
################################################################













check_input $1 || exit 4

TGT_DIR=$(getjddir "$1")|| exit 1

TGTFILE=$(getjdinfofile "$TGT_DIR") || exit 2
# [[ ! -z $? ]] && exit $?

URL=$(getjdfield "$TGTFILE") || exit 3
echo $URL

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