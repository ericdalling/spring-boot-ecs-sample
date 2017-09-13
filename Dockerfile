FROM openjdk:8u141-jdk

VOLUME /tmp

RUN mkdir -p /home/springboot/app
WORKDIR /home/springboot/app

ADD build/libs/spring-boot-ecs-sample.jar app.jar

ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar" ]