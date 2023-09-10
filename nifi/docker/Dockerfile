FROM debian:latest
# Algunas dependencias
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install openjdk-17-jdk
RUN apt-get -y install net-tools
RUN apt-get -y install curl

# Creamos las carpetas necesarias
RUN mkdir -p /opt/software/
RUN mkdir -p /opt/software/data/
RUN mkdir -p /opt/software/data/input
RUN mkdir -p /opt/software/hadoop

# Configuracion para conectarnos a Hadoop
WORKDIR /opt/software/hadoop
COPY ./config/core-site.xml core-site.xml
COPY ./config/hdfs-site.xml hdfs-site.xml

# Si la URL de los binarios de nifi cambiase, buscar la nueva y modificarla
WORKDIR /opt/software
RUN wget https://archive.apache.org/dist/nifi/1.22.0/nifi-1.22.0-bin.zip
RUN unzip nifi-1.22.0-bin.zip
RUN rm nifi-1.22.0-bin.zip
WORKDIR /opt/software/nifi-1.22.0/conf
RUN mv nifi.properties nifi_bck.properties
# Modificamos el fichero que contiene la configuracion del servidor jetty para que permita conexiones
# externas mas alla de la de localhost
# En concreto se modifica la propiedad que restringe las interfaces de las cuales pueden provenir peticiones
RUN sed 's/nifi.web.https.host=127.0.0.1/nifi.web.https.host=0.0.0.0/' nifi_bck.properties > nifi.properties

WORKDIR /opt/software/nifi-1.22.0/bin
# Se establece la variable JAVA_HOME necesaria para arrancar nifi
ENV JAVA_HOME /usr/lib/jvm/java-1.17.0-openjdk-amd64

