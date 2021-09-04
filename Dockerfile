FROM maven:3.6.0-jdk-11-slim
COPY dummy-spring-boot-main /home/dummy-spring-boot-main
COPY target/helloworld-0.0.1-SNAPSHOT.jar /target/helloworld.jar
COPY pom.xml /home/dummy-spring-boot-main
RUN mvn -f /home/dummy-spring-boot-main/pom.xml clean package

#
# Package stage
#
FROM openjdk:8-jdk-alpine
COPY --from=build /home/dummy-spring-boot-main/target/helloworld-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.jar
EXPOSE 8080
ARG JAR_FILE=target/helloworld-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
