# Install  Virtual  Box on Ubunti 18.04

## Clean System

```
sudo apt-get update
sudo apt-get upgrade
```


## Add Repo

Now, you need to add Oracle VirtualBox PPA to Ubuntu system. You can do this by running the below command on your system.

```
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
```

## install Virtual Box

If you have already installed an older version of VirtualBox, Below command will update it automatically.


```
sudo apt-get update
sudo apt-get install virtualbox-5.2
```            
