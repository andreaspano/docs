# run shint proxy

Ref: https://www.shinyproxy.io/getting-started/


## check java 

shoud openjdk version "1.8....

```
java -version 
```

## Check docker installation
Check that docker is installed see docker-howto 

## Check docker configuration 
Check docker conf file /etc/default/docker
Min eis all commented out 

## Install

Pull and install shiny proxy

```
git clone git@github.com:openanalytics/shinyproxy-template.git
sudo docker build -t openanalytics/shinyproxy-template .
```

## Testing 

Running the image for testing purposes outside ShinyProxy on port 5555 can be done using e.g.

```
sudo docker run -it -p 5555:3838 openanalytics/shinyproxy-template
```

