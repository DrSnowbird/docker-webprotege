#!/bin/bash 

# Reference: https://docs.docker.com/engine/userguide/containers/dockerimages/

echo "Usage: "
echo "  ${0} <repo-name/repo-tag>"
echo
imageTag=${1:-openkbs/openrefine}

docker ps -a

containerID=`docker ps |grep "${imageTag}"|awk '{print $1}'`
echo "containerID=$containerID"

docker commit -m "initial image" ${containerID} ${imageTag}

docker push ${imageTag}

