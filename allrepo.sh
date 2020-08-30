#!/bin/bash 
ACCESS_TOKEN=1fca92a05bb78ebc23afe7c1fdbb0ecc511f9a2a
ORG_NAME=SDGGroup
BASE_DIR=/home/andrea/dev

repos=$(curl -u ${ACCESS_TOKEN}:x-oauth-basic -s https://api.github.com/orgs/${ORG_NAME}/repos\?per_page\=200  | grep full_name | cut -f 2 -d":"| tr -d '" ,' )

cd $BASE_DIR

echo "$repos"| while IFS= read -r repo; do 
  
  #echo "working with" \'$repo\'

  local_dir="${repo//$ORG_NAME\//}"

  if [[ -d "$local_dir" ]]
  then
    cd $local_dir
    echo "Pulling $local_dir"
    git pull
    cd ..

  else
    echo "Cloning git@github.com:$repo" in $(pwd)
    git clone "git@github.com:$repo"
  fi

done
