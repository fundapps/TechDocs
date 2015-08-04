#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SAMPLE_DATA_DIR=$DIR/../Sample-ImportFiles

read -p "Enter Username: " USERNAME
read -s -p "Enter Password: " PASSWORD
printf "\n"
read -p "Enter API URL: " API_URL

function API-Post {
  curl -X POST -u $USERNAME:$PASSWORD\
    $API_URL/$1 -H "Content-Type: text/csv"\
    --data-binary "@$2" -o intermediate.xml
}

function API-Get {
  curl -X GET -u $USERNAME:$PASSWORD\
    $API_URL/$1\
     --verbose -o result.xml
}

printf ">>> Uploading Position File.. \n\n"
API-Post "v1/expost/check" "$SAMPLE_DATA_DIR/positions.csv"
printf "\n>>> Server Response (intermediate.xml): "
cat intermediate.xml
RESULT_URL=`cat intermediate.xml | grep -oP '(?<=result>)[^<]+'`
printf "\n\n>>> HTTP GET result url[$RESULT_URL]..\n\n"
API-Get "$RESULT_URL"
printf "\n>>> Result Summary \n\n"
cat result.xml
