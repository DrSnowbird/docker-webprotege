#!/bin/bash 

# Reference: 
# - https://docs.docker.com/engine/userguide/containers/dockerimages/
# - https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile

# example:
#  docker build -t openkbs/docker-webprotege:1.0.0 -t openkbs/docker-webprotege:latest .

imageTag=openkbs/docker-webprotege
#version=1.0.0

if [ ! "$version" == "" ]; then
    docker build -t ${imageTag}:$version -t ${imageTag}:latest .
    echo "---> To run in interactive mode: "
    echo "docker run --name <some-name> -it ${imageTag}:$version /bin/bash"
    echo "e.g."
    echo "docker run --name "my_${imageTag//\//_}" it ${imageTag}:$version /bin/bash"
else
    docker build -t ${imageTag} .
    echo "---> To run in interactive mode: "
    echo "docker run --name <some-name> -it ${imageTag} /bin/bash"
    echo "e.g."
    echo "docker run --name "my_${imageTag//\//_}" -it ${imageTag} /bin/bash"
fi

echo ">>> Docker Images"
echo "To build again: "
echo "  docker build -t openkbs/${imageTag}:1.0.0 -t openkbs/${imageTag}:latest . "
echo "  docker build -t openkbs/${imageTag}:latest . "
echo
docker images 


