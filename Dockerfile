FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/dummy-spring-boot-main/src
COPY pom.xml /home/dummy-spring-boot-main
RUN mvn -f /home/dummy-spring-boot-main/pom.xml clean package

#
# Package stage
#
FROM openjdk:11-alpine
COPY --from=build /home/dummy-spring-boot-main/target/demo-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]