# Spring Boot Actuator Guide for Kubernetes Practice Application

This repository contains a Spring Boot application with Actuator enabled, along with resources to help you understand and use Spring Boot Actuator.

## What is Spring Boot Actuator?

Spring Boot Actuator is a sub-project of Spring Boot that adds production-ready features to your application. It provides endpoints that help you monitor and manage your application when it's running in production.

## Resources in this Repository

1. **ActuatorGuide.md**: A comprehensive guide explaining how to use Spring Boot Actuator, including:
   - Available endpoints and their purposes
   - How to access endpoints
   - Using Actuator with Kubernetes
   - Security considerations

2. **check-actuator.sh**: An executable script that demonstrates how to check Actuator endpoints using cURL.

3. **PrometheusGrafanaGuide.md**: A detailed guide for monitoring your application with Prometheus and Grafana, including:
   - Setting up Prometheus and Grafana using Docker Compose
   - Accessing and using Prometheus
   - Accessing and using Grafana
   - Creating custom dashboards
   - Common metrics to monitor

4. **BrowserAccessGuide.md**: A step-by-step guide explaining how to access all components from your web browser:
   - Accessing the Spring Boot application
   - Accessing Spring Boot Actuator endpoints
   - Accessing and navigating Prometheus
   - Accessing and navigating Grafana
   - Troubleshooting access issues

5. **docker-compose.yml**: Ready-to-use Docker Compose configuration for setting up Prometheus and Grafana.

6. **start-monitoring.sh**: An all-in-one script that starts both the Spring Boot application and the monitoring stack (Prometheus and Grafana) with a single command.

## How to Use These Resources

### 1. Start the Application

First, make sure the application is running:

```bash
./mvnw spring-boot:run
```

The application will start on port 8083.

### 2. Read the Guide

Open `ActuatorGuide.md` to learn about Spring Boot Actuator and how it's configured in this application:

```bash
less ActuatorGuide.md
# or open it in your favorite text editor
```

### 3. Run the Check Script

Use the provided script to check the Actuator endpoints:

```bash
./check-actuator.sh
```

This script will:
- Verify the application is running
- List all available Actuator endpoints
- Check key endpoints and display their output

**Note**: The script requires `curl` and `jq` to be installed. If `jq` is not installed, you can install it with:
```bash
# For Debian/Ubuntu
sudo apt-get install jq

# For Red Hat/CentOS
sudo yum install jq

# For macOS
brew install jq
```

### 4. Set Up Monitoring with Prometheus and Grafana

To monitor your application with Prometheus and Grafana, you have two options:

#### Option 1: Use the all-in-one script (recommended)

Run the provided script to start both the application and the monitoring stack:

```bash
./start-monitoring.sh
```

This script will:
- Start the Spring Boot application
- Start Prometheus and Grafana
- Verify that everything is running
- Show access information for all components

#### Option 2: Manual setup

If you prefer to start components individually:

1. Start the Spring Boot application:
   ```bash
   ./mvnw spring-boot:run
   ```

2. Start the monitoring stack:
   ```bash
   docker-compose up -d
   ```

3. Access Prometheus at:
   ```
   http://localhost:9090
   ```

4. Access Grafana at:
   ```
   http://localhost:3000
   ```
   Login with username `admin` and password `admin`

For detailed instructions, see the `PrometheusGrafanaGuide.md` file:
```bash
less PrometheusGrafanaGuide.md
# or open it in your favorite text editor
```

### 5. Access All Components from Your Browser

For a comprehensive guide on how to access all components (Spring Boot application, Actuator, Prometheus, and Grafana) from your web browser:

```bash
less BrowserAccessGuide.md
# or open it in your favorite text editor
```

This guide provides:
- Direct URLs for all components
- Step-by-step navigation instructions
- Login credentials where needed
- Troubleshooting tips for access issues

## Actuator Configuration

The application has Actuator configured in `src/main/resources/application.properties` with:

```properties
# Enable all actuator endpoints
management.endpoints.web.exposure.include=*
# Show full health details
management.endpoint.health.show-details=always
# Enable health probes
management.health.probes.enabled=true
```

## Kubernetes Integration

This application is configured to work well with Kubernetes, with health probes enabled that can be used for liveness and readiness probes in your Kubernetes deployments.

See the `ActuatorGuide.md` file for specific examples of how to configure Kubernetes probes to use Spring Boot Actuator endpoints.

## Additional Resources

- [Spring Boot Actuator Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Spring Boot Actuator API](https://docs.spring.io/spring-boot/docs/current/actuator-api/htmlsingle/)
- [Kubernetes Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
- [Micrometer Prometheus Registry](https://micrometer.io/docs/registry/prometheus)
