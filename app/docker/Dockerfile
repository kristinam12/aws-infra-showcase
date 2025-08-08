# Use lightweight OpenJDK 17 image
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the built JAR from your local machine into the container
COPY ../target/taskapi-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080 (default for Spring Boot apps)
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
