FROM debian:latest
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install openjdk-17-jdk
#RUN apt-get -y install iproute2
RUN apt-get -y install net-tools
RUN apt-get -y install curl
RUN mkdir -p /opt/software/
RUN mkdir -p /opt/software/data/
RUN mkdir -p /opt/software/data/input
RUN mkdir -p /opt/software/hadoop

WORKDIR /opt/software/hadoop
# Configuracion para conectarnos a Hadoop
COPY ./config/core-site.xml core-site.xml
COPY ./config/hdfs-site.xml hdfs-site.xml



WORKDIR /opt/software
# Si la URL de los binarios de nifi cambiase, buscar la nueva y modificarla
RUN wget https://archive.apache.org/dist/nifi/1.22.0/nifi-1.22.0-bin.zip
RUN unzip nifi-1.22.0-bin.zip
RUN rm nifi-1.22.0-bin.zip
WORKDIR /opt/software/nifi-1.22.0/conf
RUN mv nifi.properties nifi_bck.properties
# Modificamos el fichero que contiene la configuracion del servidor jetty para que permita conexiones
# externas mas alla de la de localhost
# En concreto se modifica la propiedad que restringe las interfaces de las cuales pueden provenir peticiones
RUN sed 's/nifi.web.https.host=127.0.0.1/nifi.web.https.host=0.0.0.0/' nifi_bck.properties > nifi.properties

# Movemos el conector de impala del host local al contenedor

WORKDIR /opt/software/nifi-1.22.0/lib
COPY ./config/ImpalaJDBC41.jar ImpalaJDBC41.jar

WORKDIR /opt/software/nifi-1.22.0/bin
ENV JAVA_HOME /usr/lib/jvm/java-1.17.0-openjdk-amd64
RUN ./nifi.sh set-single-user-credentials tfm_user dqmaturitylv
RUN ./nifi.sh start

