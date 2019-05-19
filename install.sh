#! /bin/bash

sudo adduser andrea
sudo usermod -aG sudo andrea

sudo adduser leone
sudo usermod -aG sudo leone


sudo apt-get  update 
sudo apt-get -y upgrade
sudo apt-get install -y vim 
sudo apt-get install -y tmux
sudo apt-get install -y git 
sudo apt-get install -y curl
sudo apt-get install -y neovim
sudo apt-get install -y sqlite3
# Latex may yake a while
sudo apt-get install -y texlive-full

# packages necessary to add a new repository over HTTPS
sudo apt install -y apt-transport-https 
sudo apt install -y software-properties-common
# packages need by R devtools 
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y libxml2-dev

# R ---------------------------------
# https://linuxize.com/post/how-to-install-r-on-ubuntu-18-04/
# Enable the CRAN repository 
# TODO automate ubuntu version 
#ubu_version=$(lsb_release -sc)

# TODO key does not work
# R install anyway with a warn
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# add CRAN to source.list
#r_repo="'deb https://cloud.r-project.org/bin/linux/ubuntu '$ubu_version'-cran35/'"
#sudo add-apt-repository $repo

sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'


# update config 
sudo apt update

# install R base 
sudo apt install -y r-base
sudo apt install -y r-base-dev

# upgrade to R 3.5 ... mah 
sudo apt-get update
sudo apt-get dist-upgrade

# R packages
# TODO automate R version 
mkdir ~/R
mkdir ~/R/x86_64-pc-linux-gnu-library/
mkdir ~/R/x86_64-pc-linux-gnu-library/3.5







echo "install.packages('devtools', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('tidyverse', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('roxygen2', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('forecast', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('hts', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('zoo', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('microbenchmark', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save
echo "install.packages('testthis', lib=\"~/R/x86_64-pc-linux-gnu-library/3.5\"  ,repos=\"https://cran.rstudio.com\")" | R --no-save


devtools::install_github('tidyverts/fable')
devtools::install_github('tidyverts/tsibble')
devtools::install_github('tidyverts/fasster')
devtools::install_github('tidyverts/tsibbledata')






echo "devtools::install_github('jalvesaq/colorout')" | R --no-save





# dots repository
mkdir ~/dev
cd ~/dev
git clone https://github.com/andreaspano/dots.git
cd ~/

# link dots
ln -s ~/dev/dots/.Rprofile .
ln -s ~/dev/dots/.bash_aliases .
ln -s ~/dev/dots/.bashrc .
ln -s ~/dev/dots/.tmux.conf .
ln -s ~/dev/dots/.vimrc .



# R Studio ------------------------
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.1335-amd64.deb
sudo gdebi rstudio-server-1.1.463-amd64.deb


# insync --------------------------
# key 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
# add repo TODO add dist and version as variables
sudo echo "deb http://apt.insynchq.com/ubuntu  bionic non-free contrib" | sudo tee  /etc/apt/sources.list.d/insync.list

# install
sudo apt-get update
sudo apt-get install insync


# data dir
sudo mkdir /mnt/data
sudo ln -s /mnt/data /data
sudo addgroup  dev
sudo usermod -aG dev  andrea
sudo usermod -aG dev leone
sudo chgrp -R dev /data
sudo chmod -R 770 /data


