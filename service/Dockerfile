FROM gradle:7.6.1-jdk17-focal AS BUILD_IMAGE
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
RUN ./gradlew build || return 0
COPY . .
RUN ./gradlew build

FROM openjdk:17-jdk-alpine
ENV APP_HOME=/usr/app/
ENV SPRING_PROFILES_ACTIVE=local,docker
WORKDIR $APP_HOME
COPY --from=BUILD_IMAGE $APP_HOME/build/libs/*.jar $APP_HOME/application.jar
EXPOSE 8080
CMD ["java","-jar","application.jar"]
