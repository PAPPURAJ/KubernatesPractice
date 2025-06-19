# Spring Boot Actuator Guide

This guide explains how to check and use Spring Boot Actuator endpoints in this application.

## Actuator Configuration

The application has Spring Boot Actuator configured with the following settings in `application.properties`:

```properties
# Enable all actuator endpoints
management.endpoints.web.exposure.include=*
# Show full health details
management.endpoint.health.show-details=always
# Enable health probes
management.health.probes.enabled=true
```

## Accessing Actuator Endpoints

The application runs on port 8083, so all actuator endpoints are available at:

```
http://localhost:8083/actuator
```

### Common Actuator Endpoints

Here are the most commonly used actuator endpoints and how to access them:

1. **Health Check**
   - URL: `http://localhost:8083/actuator/health`
   - Description: Shows application health information
   - Example response:
     ```json
     {
       "status": "UP",
       "components": {
         "diskSpace": {
           "status": "UP",
           "details": {
             "total": 250685575168,
             "free": 100685575168,
             "threshold": 10485760
           }
         }
       }
     }
     ```

2. **Info**
   - URL: `http://localhost:8083/actuator/info`
   - Description: Displays arbitrary application info

3. **Metrics**
   - URL: `http://localhost:8083/actuator/metrics`
   - Description: Shows metrics information
   - For specific metric: `http://localhost:8083/actuator/metrics/{metric.name}`
   - Example: `http://localhost:8083/actuator/metrics/jvm.memory.used`

4. **Environment**
   - URL: `http://localhost:8083/actuator/env`
   - Description: Exposes properties from Spring's ConfigurableEnvironment

5. **Beans**
   - URL: `http://localhost:8083/actuator/beans`
   - Description: Displays a complete list of all Spring beans in your application

6. **Mappings**
   - URL: `http://localhost:8083/actuator/mappings`
   - Description: Displays a list of all @RequestMapping paths

7. **Loggers**
   - URL: `http://localhost:8083/actuator/loggers`
   - Description: Shows and modifies the configuration of loggers in the application

## Using Actuator with cURL

You can use cURL to check actuator endpoints from the command line:

```bash
# Check all available actuator endpoints
curl http://localhost:8083/actuator

# Check application health
curl http://localhost:8083/actuator/health

# Check specific metrics
curl http://localhost:8083/actuator/metrics/http.server.requests
```

## Using Actuator in Kubernetes

In Kubernetes environments, the actuator health endpoint is particularly useful for:

1. **Liveness Probes**: To determine if an application is running
   ```yaml
   livenessProbe:
     httpGet:
       path: /actuator/health/liveness
       port: 8083
     initialDelaySeconds: 30
     periodSeconds: 10
   ```

2. **Readiness Probes**: To determine if an application can receive traffic
   ```yaml
   readinessProbe:
     httpGet:
       path: /actuator/health/readiness
       port: 8083
     initialDelaySeconds: 30
     periodSeconds: 10
   ```

## Monitoring with Prometheus and Grafana

Spring Boot Actuator can expose metrics in a format that Prometheus can scrape:

1. Add the Micrometer Prometheus registry dependency:
   ```xml
   <dependency>
     <groupId>io.micrometer</groupId>
     <artifactId>micrometer-registry-prometheus</artifactId>
   </dependency>
   ```

2. Access Prometheus-formatted metrics at:
   ```
   http://localhost:8083/actuator/prometheus
   ```

3. Configure Prometheus to scrape this endpoint and visualize metrics in Grafana.

## Security Considerations

Since all actuator endpoints are exposed (`management.endpoints.web.exposure.include=*`), consider:

1. Restricting access to actuator endpoints in production
2. Using Spring Security to protect sensitive endpoints
3. Exposing only necessary endpoints in production environments