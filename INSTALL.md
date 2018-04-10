This describes the project to run a small java app with a casandra db

For this we need the following components to be setup.
* A GCE kubernetes environment.
* Make use of a docker registry can be any of the following
# google container registry
# gitlab omnibus container registry
# Or a more advanced artifactory.
* helm installed inside the kubernetes environment.

# Local installation
# cassandra installation
docker run -p 9042:9042 --name cassandra-dev -d cassandra:3.11
Then connect to the casanda db using cqlsh (on mac install with brew)
brew install cassandra
cqlsh localhost -u cassandra -p cassandra

#Then run the following commands to create the neccesary tables
./create_db.sh

# this should verify that the keyspace is installed
```
 keyspace_name      | durable_writes | replication
--------------------+----------------+-------------------------------------------------------------------------------------
        system_auth |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
      system_schema |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
 system_distributed |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '3'}
             system |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
      system_traces |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
```

# application configuration
export ENVIRONMENT=test
echo " logging.level.org.springframework.web=INFO
logging.level.org.hibernate=ERROR

cassandra.keyspace=recommend
cassandra.hostname=cassandra.$ENVIRONMENT.svc
cassandra.port=9042
cassandra.username=cassandra
cassandra.password=cassandra
" > src/main/resources/application.properties

# application Installation
brew install maven
compile the JAR_FILE
mvn package && java -jar target/app-spring-boot-docker-0.1.0.jar
docker build -t fluxapi .
docker run -ti fluxapi /bin/ash

# Local installation can he done using the docker-compose command
docker-compose up

# Installation on k8s test and production
Installation of helm can be done with the following command:
 helm init
This sets up the helm tiller in the default namespace.
You can see the installed helm charts with:
 helm ls

# Instalation on test
helm install --namespace test --name cassandra incubator/cassandra
helm install --namespace test --name fluxapi ./fluxapi

# Installation on prod
helm install --namespace prod --name cassandra incubator/cassandra
helm install --namespace prod --name fluxapi ./fluxapi

# Todo
Setup k8s infrastructure, gitlab and probably artifactory.
Setup ci/cd pipeline in Gitlab using a gitlab-ci.yml to replace makefile
Application improvements are use an external config file for the Cassandra settings.
Application improvements use a circuit breaker like https://github.com/Netflix/Hystrix
