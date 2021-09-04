FROM maven:3.6.0-jdk-11-slim
COPY src /home/ec2-user/thebest/src
COPY target/helloworld-0.0.1-SNAPSHOT.jar /target/helloworld-0.0.1-SNAPSHOT.jar
COPY pom.xml /home/ec2-user/thebest
RUN mvn -f /home/ec2-user/thebest/pom.xml clean package

#
# Package stage
#
FROM openjdk:8-jdk-alpine
COPY --from=build /home/ec2-user/thebest//target/helloworld-0.0.1-SNAPSHOT.jar /home/ec2-user/thebest//target/helloworld-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ARG JAR_FILE=target/helloworld-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
