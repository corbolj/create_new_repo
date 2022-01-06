#!/bin/bash

git_user=$1
new_repo=$2
git_credentials=~/.git-credentials
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Get git-credentials
credential_line=$(cat $git_credentials | grep $git_user)
IFS=':'; read -a strarr <<< "$credential_line"
IFS='@'; read -a strarr <<< "${strarr[2]}"
git_credential=${strarr[0]}

curl_json="""{\"name\":\"$2\", \"private\":true}"""

curl -u $git_user:$git_credential https://api.github.com/user/repos -d  $curl_json

cd $SCRIPT_DIR/..

if [ -d "$PWD/$2" ]
then
  echo "Directory /path/to/dir exists."
  if [ -d "$PWD/$2/.git" ]
  then
    echo "A repo already exists at $PWD/$2."
    exit 0
  fi
else
  mkdir $PWD/$2
fi

cd $PWD/$2
echo .DS_Store > .gitignore
git init
git remote add origin https://github.com/$1/$2
git add .
git commit -m "initial commit"
