#!/bin/bash

files=$(ls .config | grep .txt)

for file in ${files[@]}
do
if [[ $(echo $file | cut -d "." -f 1) == "key" ]]
then
    key=$(echo $file | cut -d "." -f 1 | tr a-z A-Z)
else
    key=$(echo $file | cut -d "." -f 1 | cut -d "_" -f 2 | tr a-z A-Z)_KEY
fi 

files=$(ls)
for file in ${files[@]}
do
# Set config in heroku if AppName is found
if [[ $file == "whoami" ]]
then
if [[ $(heroku config:set --app $(cat whoami) $key=$(cat .config/$file)) ]]
then
echo "Sucess...$key set"
else
echo "Error...$key not set"
fi
done 
fi
done