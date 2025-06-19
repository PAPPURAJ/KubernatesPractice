FROM eclipse-temurin:17-jdk-alpine

# Create a group and user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create app directory
WORKDIR /app

# Copy the jar file
COPY target/KubernatesPractice-0.0.1-SNAPSHOT.jar app.jar

# Expose the port
EXPOSE 8080

# Set permissions
RUN chown -R appuser:appgroup /app
USER appuser

# Health check using Spring Boot Actuator
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
  CMD wget -q --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
