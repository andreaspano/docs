# Dockers

## Install docker 

references:

- https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository


basic

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```

add Docker's official GPG key:

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88,
by searching for the last 8 characters of the fingerprint.

```
sudo apt-key fingerprint 0EBFCD88
```

set up the stable repository.

```
sudo add-apt-repository   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
```

install

```
sudo apt-get install docker-ce
```

quick test to make sure all is set up:

```
sudo docker run hello-world
```

## Change installation directotry 


references:

- https://www.crybit.com/change-default-data-image-directory-docker/
- https://stackoverflow.com/questions/40192415/how-permanently-kill-dockerd/40192707

Docker base directory better be inside a large partition as dockers may take a lot of disk space. The default data directory is `/var/lib/docker`
It contains all the data for docker installation, like all the docker images your built or pulled from the hub.


Easy way is symlink `/var/lib/docker` to `/home/docker`

1. stop docker demon

```
sudo systemctl stop docker
```

2. Make sure that there are no docker related processes.

```
ps aux | grep docker
```


3. Move the contents of /var/lib/docker to your new location.

```
sudo mv /var/lib/docker /home/
```

4. Create a softlink to default location.

```
sudo ln -s /home/docker/ /var/lib/docker
```

5. Restart docker daemon.

```
sudo systemctl start docker
```

## Basic Docker commands

An image is an inert, immutable, file that's essentially a snapshot of a container. 
Images are created with the build command, and they'll produce a container when started with run. 
Images are stored in a Docker registry such as registry.hub.docker.com.

## Basic listing and removing:

References: 
- https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/

List all image installed  `docker image ls`
Remove an image `docker image rm <IMAGE ID>`
Force removin an image `docker  rmi -f  <IMAGE ID>` this is useful when an image is referred my multiple dockers

list all dockers `docker container ls -a`
stop a docker `docker stop <CONTAINER ID>`
remove a docker `docker rm <CONTAINER ID>`



## Install R and R-Studio Docker 


reference: 

https://ropenscilabs.github.io/r-docker-tutorial/02-Launching-Docker.html


install rstudio docker with 

```
sudo docker pull  rocker/verse
```

Note that in case the container is not install. Docker tryes to get the container from docker hub

Fire rstudio docker with 
Note port 666 as 8787 may be already taken by local rstudio server 

```
sudo docker run --rm -p 666:8787 -e PASSWORD=tre rocker/verse
```

-  `p` flag specify the port
-  `--rm` flag specify that the container must be deleted after each usage
- `-e`  flag  ... no idea  


Connect to Rstudio at `http://localhost::666`

* usr rstudio 
* pwd <YOUR_PASS>


To attach a persistent volume, the docker requires to be fired with the `-v` (volume) options:
Paths are specified as `local_path:docker_path`

```
sudo docker run --rm -p 666:8787  -v /home/andrea/dev/:/home/rstudio/dev/ -e PASSWORD=tre rocker/verse
```

## Install minimal ubuntu 

create a new dir: `mkdir test` and cd into it

create a new file: `echo 'FROM ubuntu' | tee Dockerfile`

build the docker `docker build -t test .` The docker will be named test. -t stands for --tag

run the docker with `docker run --rm -it test /bin/bash`.

- `--rm`: remove the  container after  shut down 
- `-i` :Keep STDIN open even if not attached
- `-t`  Allocate a pseudo-tty

Note that when building the _test_ container, the _ubuntu_ container will built anyway 

The size of the newly created container is 88.7 Mb

in order to install something extra into the minimal, congigure dockerfile as:

```
FROM ubuntu
RUN apt-get update && apt-get install -y vim
```

## Install minimal ubuntu with R  
References: https://github.com/rocker-org/rocker/tree/master/r-base
Same procedure as minimal ubuntu 
Docker file in `r-base.dkr`












