FROM maven:3.5.4-jdk-8-alpine as maven
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn package
WORKDIR /thebest
COPY --from=maven target/helloworld-0.0.1-SNAPSHOT.jar ./thebest/helloworld-0.0.1-SNAPSHOT.jar
CMD ["java", "-jar", "./helloworld-0.0.1-SNAPSHOT.jar"]

