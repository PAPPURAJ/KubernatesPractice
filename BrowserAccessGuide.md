# Browser Access Guide

This guide explains how to access all components of the application from your web browser.

## Accessing the Spring Boot Application

The Spring Boot application runs on port 8083 by default.

1. Open your web browser and navigate to:
   ```
   http://localhost:8083
   ```

2. You should see the "Hello World from Spring Boot!" message, which confirms the application is running correctly.

3. You can also access the health check endpoint at:
   ```
   http://localhost:8083/health
   ```
   This should return "UP" if the application is healthy.

## Accessing Spring Boot Actuator

Spring Boot Actuator provides various endpoints to monitor and manage your application.

1. To see all available actuator endpoints, navigate to:
   ```
   http://localhost:8083/actuator
   ```
   This will show a JSON response with links to all available endpoints.

2. Common actuator endpoints:
   - Health information: `http://localhost:8083/actuator/health`
   - Application metrics: `http://localhost:8083/actuator/metrics`
   - Environment variables: `http://localhost:8083/actuator/env`
   - Request mappings: `http://localhost:8083/actuator/mappings`
   - Prometheus metrics: `http://localhost:8083/actuator/prometheus`

3. To view detailed information about a specific metric, append the metric name to the metrics endpoint:
   ```
   http://localhost:8083/actuator/metrics/jvm.memory.used
   ```

## Accessing Prometheus

Prometheus is a monitoring system that collects metrics from your application.

1. Open your web browser and navigate to:
   ```
   http://localhost:9090
   ```

2. You'll see the Prometheus web interface with a query input field.

3. To check if Prometheus is correctly scraping metrics from your application:
   - Click on "Status" in the top menu
   - Select "Targets" from the dropdown
   - You should see the "spring-boot-app" target with state "UP"

4. To query metrics:
   - Return to the main page
   - Enter a metric name in the query field (e.g., `http_server_requests_seconds_count`)
   - Click "Execute"
   - You can view the results as a graph or in table format

5. Common metrics to query:
   - HTTP request count: `http_server_requests_seconds_count`
   - JVM memory used: `jvm_memory_used_bytes`
   - System CPU usage: `system_cpu_usage`

## Accessing Grafana

Grafana provides visualizations for the metrics collected by Prometheus.

1. Open your web browser and navigate to:
   ```
   http://localhost:3000
   ```

2. Log in with the following credentials:
   - Username: `admin`
   - Password: `admin`
   
   Note: On first login, you'll be prompted to change the password. You can skip this step for development environments.

3. After logging in, you'll see the Grafana home dashboard.

4. To access the pre-configured Spring Boot dashboard:
   - Click on "Dashboards" in the left sidebar
   - Select "Spring Boot" folder
   - Open the "Spring Boot Metrics" dashboard

5. The dashboard includes panels for:
   - HTTP Requests Rate
   - HTTP Response Time
   - JVM Memory Usage
   - System CPU Usage

6. You can customize the time range by using the time picker in the top-right corner.

## Troubleshooting Access Issues

If you cannot access any of the components:

1. **Spring Boot Application**:
   - Verify the application is running with `ps aux | grep java`
   - Check the application logs for errors

2. **Prometheus and Grafana**:
   - Verify the containers are running with `docker-compose ps`
   - Check container logs with `docker-compose logs prometheus` or `docker-compose logs grafana`

3. **Network Issues**:
   - Ensure no firewall is blocking the ports
   - Verify the ports are not being used by other applications

## Starting All Components

For convenience, you can use the provided script to start all components:

```bash
./start-monitoring.sh
```

This script will:
- Start the Spring Boot application
- Start Prometheus and Grafana
- Verify that everything is running
- Show access information for all components