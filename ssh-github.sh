#!/bin/bash

set -xe
myemail="andrea.spano@quantide.com"

#your personal access token
git_api_token="466a2e7c3f86c2434337cf0f14f5b71b4cffe57d"


#We'll use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:andreaspano/dots.git"
gitrepo_https="https://github.com/andreaspano/dots.git"

#Generating SSH key:
ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 -C "${myemail}" -N ''
sslpub="$(cat ${HOME}/.ssh/id_rsa.pub |tail -1)"

#git API path for posting a new ssh-key:
git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"

#lets name the ssh-key in get after the hostname with a timestamp:
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

#Finally lets post this ssh key:
curl -H "Authorization: token ${git_api_token}" -H "Content-Type: application/json" -X POST -d "{\"title\":\"${git_ssl_keyname}\",\"key\":\"${sslpub}\"}" ${git_api_addkey}
