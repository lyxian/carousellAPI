#!/usr/bin/bash

# Run this to setup venv and env

# Initialize venv
if [[ $# -ne 1 ]]
then
echo -e "Please provide only one argument for the name of venv:\n.scripts/venv.sh [NAME]"
return 1
else
deactivate
python3 -m venv $1
. $1/bin/activate
fi

# Append to venv config
echo "set -a
source $PWD/.env
set +a" >> $PWD/$1/bin/activate

# Create .env
files=$(ls .config | grep .txt)
## Remove existing .env
if [[ $(cat .env) ]]
then
echo -n "" > .env
echo "Overwriting existing .env..."
else
echo "Creating new .env..."
fi
## Export secrets from .config
for file in ${files[@]}
do
if [[ $(echo $file | cut -d "." -f 1) == "key" ]]
then
    key="$(echo $file | cut -d "." -f 1 | tr a-z A-Z)=$(cat .config/$file)"
else
    key="$(echo $file | cut -d "." -f 1 | cut -d "_" -f 2 | tr a-z A-Z)_KEY=$(cat .config/$file)"
fi 
echo $key >> .env
done

deactivate
. $1/bin/activate

# Install Packages
if packages=$(cat requirements.txt)
then
for package in ${packages[@]}
do
pip install $package
# echo "pip install $package"
done
else
echo "No requirements.txt found, exiting without installing packages..."
return 1
fi

# Freeze Requirements
pip freeze > requirements.txt