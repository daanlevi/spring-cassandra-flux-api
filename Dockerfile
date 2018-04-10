FROM openjdk:8-jdk-alpine
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
            vim \
            bash
COPY /target/fluxapi-0.0.1-SNAPSHOT.jar /home/fluxapi-0.0.1-SNAPSHOT.jar
EXPOSE 8080
CMD ["java", "-jar", "/home/fluxapi-0.0.1-SNAPSHOT.jar"]
