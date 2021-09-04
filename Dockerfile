FROM maven:3.6.0-jdk-11-slim
COPY thebest /root/thebest
COPY target/helloworld-0.0.1-SNAPSHOT.jar /target/helloworld-0.0.1-SNAPSHOT.jar
COPY pom.xml /root/thebest
RUN mvn -f /root/thebest/pom.xml clean package

#
# Package stage
#
FROM openjdk:8-jdk-alpine
COPY --from=build /root/thebest/target/helloworld-0.0.1-SNAPSHOT.jar /root/thebest/target/helloworld-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ARG JAR_FILE=target/helloworld-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
