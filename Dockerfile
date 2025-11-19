FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the packaged jar file into the container
COPY target/*.jar app.jar

# Expose internal port (Spring Boot runs on 8080)
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
