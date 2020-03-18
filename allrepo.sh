#!/bin/bash 
ACCESS_TOKEN=2b512c8a30c85cce5c77cb6674a44b11011c9bab
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
