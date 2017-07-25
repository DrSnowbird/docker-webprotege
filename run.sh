#!/bin/bash -x

if [ $# -lt 1 ]; then
    echo "Usage: "
    echo "  ${0} [<repo-name/repo-tag>] "
    echo "e.g."
    echo "  ${0} openkbs/docker-webprotege"
fi

## -- mostly, don't change this --
MY_IP=`ip route get 1|awk '{print$NF;exit;}'`

function displayPortainerURL() {
    port=${1}
    echo "... Go to: http://${MY_IP}:${port}"
    #firefox http://${MY_IP}:${port} &
    if [ "`which google-chrome`" != "" ]; then
        /usr/bin/google-chrome http://${MY_IP}:${port} &
    else
        firefox http://${MY_IP}:${port} &
    fi
}

##################################################
#### ---- Mandatory: Change those ----
##################################################
baseDataFolder=~/data-docker
imageTag=${1:-"openkbs/docker-webprotege"}

PACKAGE=docker-webprotege
GRAPHDB_HOME=/usr/${PACKAGE}

CATALINA_HOME=${CATALINA_HOME:-/tomcat}

## -- Don't change this --
PACKAGE=`echo ${imageTag##*/}|tr "/\-: " "_"`

## -- Volume mapping --
docker_volume_data1=/data/webprotege
docker_volume_data2=${CATALINA_HOME}/webapps
docker_volume_data3=/data/db
local_docker_data1=${baseDataFolder}/${PACKAGE}/data/webprotege
local_docker_data2=${baseDataFolder}/${PACKAGE}/${CATALINA_HOME}/webapps
local_docker_data3=${baseDataFolder}/${PACKAGE}/data/mongodb

## -- local data folders on the host --
mkdir -p ${local_docker_data1}
mkdir -p ${local_docker_data2}
mkdir -p ${local_docker_data3}

#### ---- ports mapping ----
docker_port1=8080
local_docker_port1=38080

##################################################
#### ---- Mostly, you don't need change below ----
##################################################
## -- mostly, don't change this --

#instanceName=my-${2:-${imageTag%/*}}_$RANDOM
#instanceName=my-${2:-${imageTag##*/}}
instanceName=`echo ${imageTag}|tr "/\-: " "_"`

#### ----- RUN -------
# docker logs -f ${instanceName} &

echo "---------------------------------------------"
echo "---- Starting a Container for ${imageTag}"
echo "---------------------------------------------"
docker-compose up -d

#### ---- Display IP:Port URL ----
displayPortainerURL ${local_docker_port1}
echo "webprotege_data=${local_docker_data1}"
echo "mongodb_data=${local_docker_data2}"

