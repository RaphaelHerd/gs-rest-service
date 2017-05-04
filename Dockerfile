FROM openjdk:8u121-jre-alpine

ADD complete/target/gs-rest-service-0.1.0.jar app.jar
RUN sh -c 'touch /app.jar'

ENTRYPOINT ["java", "-jar", "/app.jar"]