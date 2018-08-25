FROM openkbs/jre-tomcat

MAINTAINER DrSnowbird <DrSnowbird@openkbs.org>

#######################################
#### --- Build Args: ---- ####
#######################################
ARG WEBPROTEGE_VERSION=${WEBPROTEGE_VERSION:-3.0.0}
ENV WEBPROTEGE_VERSION=${WEBPROTEGE_VERSION}

#######################################
#### --- Runtime Java Options ---- ####
#######################################
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
ENV CATALINA_HOME=${CATALINA_HOME:-/tomcat}

## Create the WebProtégé data directory
## see: https://github.com/protegeproject/webprotege/wiki/WebProt%C3%A9g%C3%A9-3.0.0-Installation
ARG WEBPROTEGE_SRV_DATA=/srv/webprotege

ENV WEBPROTEGE_DATA=/data/webprotege

ENV CATALINA_WEBAPPS=${CATALINA_HOME}/webapps

ENV INSTALL_DIR=${CATALINA_WEBAPPS}/ROOT

#TARGET_URL=https://github.com/protegeproject/webprotege/releases/download/v3.0.0/webprotege-3.0.0.war
#TARGET_URL=https://github.com/protegeproject/webprotege/releases/download/v2.6.0/webprotege-2.6.0.war
ENV TARGET_URL=https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}/webprotege-${WEBPROTEGE_VERSION}.war

WORKDIR ${CATALINA_WEBAPPS}

RUN echo ${CATALINA_HOME} \
    && mkdir -p ${WEBPROTEGE_DATA} \
    && mkdir -p ${WEBPROTEGE_SRV_DATA} \
    && cp -r ROOT ROOT.save \
    && rm -rf ROOT/* \
    && wget -q -O webprotege.war ${TARGET_URL} \
    && unzip -q webprotege.war -d ${CATALINA_WEBAPPS}/ROOT \
    && rm webprotege.war \
    && sed -i 's/#mongodb.host=localhost/mongodb.host=mongodb/g' ${CATALINA_WEBAPPS}/ROOT/WEB-INF/classes/webprotege.properties
    
COPY config/webprotege.properties ${CATALINA_WEBAPPS}/ROOT/webprotege.properties

VOLUME ${WEBPROTEGE_DATA}
VOLUME ${CATALINA_WEBAPPS}

EXPOSE 8080

#CMD ["catalina.sh", "run"]
CMD ["/entry.sh", "run"]
