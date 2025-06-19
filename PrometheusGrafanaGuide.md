# Prometheus and Grafana Monitoring Guide

This guide explains how to use Prometheus and Grafana to monitor your Spring Boot application.

## Prerequisites

- Docker and Docker Compose installed on your machine
- The Spring Boot application running on port 8083

## Setup Overview

The monitoring setup consists of:

1. **Spring Boot Application**: Exposes metrics in Prometheus format at `/actuator/prometheus`
2. **Prometheus**: Collects and stores metrics from the Spring Boot application
3. **Grafana**: Visualizes the metrics collected by Prometheus

## Starting the Monitoring Stack

1. Make sure your Spring Boot application is running:
   ```bash
   ./mvnw spring-boot:run
   ```

2. Start Prometheus and Grafana using Docker Compose:
   ```bash
   docker-compose up -d
   ```

   This command starts both Prometheus and Grafana in detached mode.

3. Verify that the containers are running:
   ```bash
   docker-compose ps
   ```

## Accessing Prometheus

Prometheus is available at:
```
http://localhost:9090
```

### Using Prometheus

1. To verify that Prometheus is scraping metrics from your application, go to:
   ```
   http://localhost:9090/targets
   ```
   
   You should see the `spring-boot-app` target with status `UP`.

2. To query metrics, go to the Prometheus Graph interface:
   ```
   http://localhost:9090/graph
   ```

3. Example queries:
   - HTTP request count: `http_server_requests_seconds_count`
   - JVM memory used: `jvm_memory_used_bytes`
   - System CPU usage: `system_cpu_usage`

## Accessing Grafana

Grafana is available at:
```
http://localhost:3000
```

### Login Credentials

- Username: `admin`
- Password: `admin`

You'll be prompted to change the password on first login, but you can skip this step for development environments.

### Using Grafana

1. After logging in, you'll see the home dashboard.

2. The Spring Boot dashboard is pre-configured and available in the "Spring Boot" folder.
   - Click on "Dashboards" in the left sidebar
   - Select "Spring Boot" folder
   - Open the "Spring Boot Metrics" dashboard

3. The dashboard includes panels for:
   - HTTP Requests Rate
   - HTTP Response Time
   - JVM Memory Usage
   - System CPU Usage

4. You can customize the dashboard by:
   - Adjusting the time range (top-right corner)
   - Adding new panels
   - Modifying existing panels

## Creating Custom Dashboards

To create a custom dashboard:

1. Click the "+" icon in the left sidebar
2. Select "Dashboard"
3. Click "Add new panel"
4. Select Prometheus as the data source
5. Enter a PromQL query (e.g., `http_server_requests_seconds_count`)
6. Configure visualization options
7. Click "Apply"
8. Save the dashboard

## Common Metrics to Monitor

### HTTP Metrics
- Request Rate: `rate(http_server_requests_seconds_count[1m])`
- Average Response Time: `rate(http_server_requests_seconds_sum[1m]) / rate(http_server_requests_seconds_count[1m])`
- Error Rate: `sum(rate(http_server_requests_seconds_count{status=~"5.."}[1m])) / sum(rate(http_server_requests_seconds_count[1m]))`

### JVM Metrics
- Memory Usage: `jvm_memory_used_bytes`
- Garbage Collection: `rate(jvm_gc_pause_seconds_sum[1m])`
- Thread Count: `jvm_threads_live_threads`

### System Metrics
- CPU Usage: `system_cpu_usage` and `process_cpu_usage`
- File Descriptors: `process_files_open_files`

## Stopping the Monitoring Stack

To stop Prometheus and Grafana:

```bash
docker-compose down
```

To stop and remove all data (volumes):

```bash
docker-compose down -v
```

## Troubleshooting

### Prometheus Cannot Connect to Spring Boot Application

If Prometheus cannot scrape metrics from your application:

1. Ensure your application is running and accessible at `http://localhost:8083/actuator/prometheus`
2. Check the Prometheus configuration in `prometheus.yml`
3. For Linux users, you might need to use the Docker network gateway IP instead of `host.docker.internal`

### Grafana Cannot Connect to Prometheus

If Grafana cannot connect to Prometheus:

1. Check that Prometheus is running
2. Verify the Prometheus data source configuration in Grafana
3. Ensure the Docker network is functioning correctly

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
- [Spring Boot Actuator Metrics](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.metrics)