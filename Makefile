SERVICE_NAME=<repo_name>/fluxapi
VERSION=latest
DOCKERIMAGE = "$(SERVICE_NAME):$(VERSION)"
ENVIRONMENT = "test"

build:
		mvn package

docker: build
		docker build --no-cache -t $(SERVICE_NAME) .
		docker tag $(SERVICE_NAME) $(DOCKERIMAGE)

image: docker
		docker push $(DOCKERIMAGE)

run:
		docker-compose up

prepair:
	helm install --namespace $(ENVIRONMENT) --name cassandra incubator/cassandra
	kubectl port-forward cassandra-cassandra-0 9042:9042 -n $(ENVIRONMENT)
	./create_db.sh

deploy:
	helm install --namespace $(ENVIRONMENT) --name fluxapi ./fluxapi

clean:
	rm -rf target/
