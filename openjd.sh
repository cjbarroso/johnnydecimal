#!/usr/bin/env bash

BASE=~/JD

INPUT=11.01

#if [[ $INPUT == 11* ]]; then
#echo yes
#fi

# -d DELIMITER
# -t TARGET variable
# Dont forget the "" around input variable
readarray -d . -t strarr <<< "$INPUT" 

# array lenght
LEN=${#strarr[@]}

if [[ $LEN < 2 ]]; then
echo "Unary operator not supported (yet)"
exit
fi
# all cases except unary operator can be found with find
# echo $LEN
TGT_DIR=`find $BASE -iname "${INPUT}*"|head -n1`
if [[ -z $TGT_DIR ]]; then
echo "Directory not found"
exit 1
fi
# IF dir cannot be found, error
TGT=$(find "$TGT_DIR" -iname info.yaml|head -n1)
if [[ -z $TGT ]]; then
echo "Info file not found"
exit 2
fi
# If file cannot be found, error
echo $TGT
# valor=$(yq '.url' info.yaml)
#echo "999999999999999"
#echo $valor
#echo "999999999999999"
#Print each value of Array with the help of loop  
# for (( n=0; n < ${#strarr[*]}; n++ ))  
# do  
# echo "${strarr[n]}"  
# done  
