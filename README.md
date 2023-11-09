Este es el repositorio de código asociado al TFM de Valentín Barquero Saucí.



## Despliegue de la infraestructura mediante Docker
Para constituir desplegar la arquitectura propuesta en el TFM se requiere tener instalado el software Docker.

En concreto para este TFM, se ha instalado Docker Desktop sobre Windows.

### 1. Creando la red
En primer lugar, se procede a crear una subred denominada dq-maturity-network que permitirá asignar IPs estáticas a los contenedores. De otro modo, estas direcciones cambiarían con cada arranque de los contenedores.

````
docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 dq-maturity-network
````
### 2. Despligue de Nifi

Se creará la imagen de Nifi a partir del fichero Dockerfile situado en /nifi/docker. A tal fin, se debe lanzar el siguiente comando
````
docker build --no-cache -t nifi-image ./nifi/docker
````
Para crear el contenedor e instanciar de este modo la imagen anterior, se lanzará el siguiente comando:
````
docker run -dit --net dq-maturity-network --ip 172.18.0.3 -p 8443:8443 --name nifi-container nifi-image
````
Una vez arrancado el contenedor hay que establecer los credenciales para acceder a Nifi. Si no se hiciese esto,
habría que revisar los ficheros de logs para ver el user/password generado.

Nótese que es preciso sustituir `<user>` y `<password>` por el nombre de user y la password que se desee (12 caracteres minimo).
````
docker exec -d nifi-container ./nifi.sh set-single-user-credentials <user> <password>
````
Posteriormente para arrancar Nifi, lanzaremos el siguiente comando.

````
docker exec -d nifi-container ./nifi.sh start
````

Si el comando de arranque del servicio de Nifi se hace desde la sentencia CMD en el Dockerfile, el contenedor se ejecutará para iniciar Nifi, pero después se apagará. Eso es debido a que no se espera a que el servidor arranque (asíncrono). Para evitar problemas, es mejor arrancar el contenedor y dejarlo en background para a posteriori iniciar el servicio de nifi.

Se recomienda esperar a que el servidor de Nifi se encuentre completamente cargado, pudiendo tardar en torno a un minuto.

### 2. Despligue de Kogito

Es preciso situarse en la carpeta raiz del proyecto de la aplicación de Kogito.

````
cd sample-kogito
````
Posteriormente, se construye el fichero JAR de la aplicación mediante el siguiente comando asociado a Maven.

````
./mvnw clean package
````

Se procede a construir la imagen de Docker a partir de uno de los Dockerfile predefinidos en el arquetipo de la aplicación.

````
docker build -f src/main/docker/Dockerfile.jvm -t quarkus/sample-kogito-jvm .
````

Se realiza el arranque del contenedor kogito-container que desplegará la aplicación de Kogito.
````
docker run -dit --net dq-maturity-network --ip 172.18.0.4 -p 8080:8080 --name kogito-container quarkus/sample-kogito-jvm
````

### 3. Despligue de cloudera/quickstart

Es preciso descargar la imagen mediante el siguiente comando.
````
docker pull cloudera/quickstart:latest
````

Posteriormente, se procede a arrancar el contenedor asociado a la imagen de cloudera/quickstart (denominado cloudera-container).
````
docker run --name cloudera-container --hostname=quickstart.cloudera --privileged=true -t -i -d --publish-all=true --net dq-maturity-network --ip 172.18.0.2 -p8888:8888 -p7180:7180 -p21050:21050 -p8022:8022 -p8020:8020 -p50470:50470 -p50070:50070 cloudera/quickstart /usr/bin/docker-quickstart
````

Nótese que todos los comandos que se han lanzado sobre el daemon de Docker contienen los parámetros de configuración necesarios para permitir la comunicación entre los 3 contenedores, además del acceso desde el host a cualquiera de ellos a través de localhost.

## Directorio de servicios

A continuación, se destacan las distintas direcciones mediante las cuales se habilita el acceso desde la máquina host a los servicios desplegados en los contenedores.

- Acceso a Nifi https://localhost:8443/nifi
- Swagger UI para interactuar con la API que genera Kogito: http://localhost:8080/q/swagger-ui
- Hue para acceder a Impala y al sistema de archivos HDFS desde GUI: http://localhost:8888/

Para consultar las credenciales por defecto que permiten entrar a hue, se recomienda revisar el siguiente enlace: https://docs.cloudera.com/documentation/enterprise/5-4-x/topics/quickstart_vm_administrative_information.html

## Simulación del caso de estudio

Una vez desplegada la arquitectura y tras haber comprobado que se tiene acceso a los servicios comentados en la anterior sección, es posible realizar la ejecución del pipeline desarrollado.

### 1. Cargar pipeline 
Cargar en Nifi la plantilla del proceso ETL desarrollado, la cual es /nifi/flow/dq-flow_template_nifi.xml

### 2. Cargar el fichero de datos

Crear la carpeta /input en la ruta /user/hive/ y subir el dataset a HDFS. Ambas cosas se pueden hacer desde Hue.

Esto es, el dataset, que se encuentra en la ruta /dataset de este repositorio, debe cargarse a la ruta /user/hive/input del sistema de archivos de HDFS.

### 3. Ejecutar el proceso

Ejecutar el proceso de Nifi y verificar que los ficheros se han generado en la ruta /user/hive/indonesia_covid19 de HDFS.

### 4. Crear base de datos (esquema de base de datos) y estructura de tabla

Desde Impala (GUI de Hue) lanzar los scripts siguientes, los cuales están disponibles en la ruta /cloudera/impala:

1. create_db_schema.sql
2. create_dmn_table.sql

Tras esto, se podrán lanzar consultas SQL sobre los datos enriquecidos.