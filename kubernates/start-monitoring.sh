#!/bin/bash

# Script to start the Spring Boot application and monitoring stack

echo "Starting Spring Boot Application and Monitoring Stack"
echo "===================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker to run the monitoring stack."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose to run the monitoring stack."
    exit 1
fi

# Start the Spring Boot application in the background
echo "Starting Spring Boot application..."
./mvnw spring-boot:run > app.log 2>&1 &
APP_PID=$!

# Wait for the application to start
echo "Waiting for the application to start..."
sleep 10

# Check if the application is running
if ! curl -s http://localhost:8083/actuator/health > /dev/null; then
    echo "Error: Spring Boot application failed to start. Check app.log for details."
    kill $APP_PID
    exit 1
fi

echo "Spring Boot application started successfully on port 8083."

# Start Prometheus and Grafana
echo "Starting Prometheus and Grafana..."
docker compose up -d

# Check if containers are running
if [ $(docker compose ps -q | wc -l) -ne 2 ]; then
    echo "Error: Failed to start all containers. Check docker-compose logs."
    echo "Stopping Spring Boot application..."
    kill $APP_PID
    exit 1
fi

echo "Monitoring stack started successfully."
echo

# Print access information
echo "Access Information:"
echo "==================="
echo "Spring Boot Application: http://localhost:8083"
echo "Spring Boot Actuator: http://localhost:8083/actuator"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000 (login with admin/admin)"
echo

echo "To stop everything:"
echo "1. Press Ctrl+C to stop this script"
echo "2. Run: docker-compose down"
echo "3. Kill the Spring Boot app: kill $APP_PID"
echo

echo "Monitoring logs (press Ctrl+C to exit):"
echo "======================================="
docker compose logs -f