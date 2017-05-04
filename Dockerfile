FROM openjdk:8u121-jre-alpine

ARG CONT_IMG_VER
ENV CONT_IMG_VER ${CONT_IMG_VER:-v0}
ARG CONT_IMG_UTC_DATETIME
ENV CONT_IMG_UTC_DATETIME ${CONT_IMG_UTC_DATETIME:-Thu Jan  1 00:00:00 UTC 1970}

ADD complete/target/gs-rest-service-0.1.0.jar app.jar
RUN sh -c 'touch /app.jar'

ENTRYPOINT ["java", "-jar", "/app.jar"]
