# 🚀 Spring Boot JAR Deployment on Kubernetes with Minikube

This guide shows you how to set up a local Kubernetes environment with Minikube and deploy a Java (Spring Boot) JAR application from scratch—including environment config, secrets, and automatic pod scaling.

---

## 📋 Table of Contents

* [1. Prerequisites](#1-prerequisites)
* [2. Install Minikube & kubectl](#2-install-minikube--kubectl)
* [3. Start Minikube](#3-start-minikube)
* [4. Prepare Your Application JAR & Config](#4-prepare-your-application-jar--config)
* [5. Create Kubernetes YAML Manifests](#5-create-kubernetes-yaml-manifests)
* [6. Deploy to Kubernetes](#6-deploy-to-kubernetes)
* [7. Access Your Application](#7-access-your-application)
* [8. Enable Pod Autoscaling (Optional)](#8-enable-pod-autoscaling-optional)
* [9. Useful kubectl Commands](#9-useful-kubectl-commands)
* [10. Cleanup](#10-cleanup)

---

## 1. Prerequisites

* A Linux, macOS, or Windows (WSL2/Hyper-V) computer
* [Docker](https://docs.docker.com/get-docker/) installed and running
* Java application packaged as a JAR (e.g. `KubernatesPractice-0.0.1-SNAPSHOT.jar`)
* Internet connection

---

## 2. Install Minikube & kubectl

**Install kubectl:**

```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

**Install Minikube:**

```bash
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
```

> For Mac/Windows, use the official [installation instructions](https://minikube.sigs.k8s.io/docs/start/).

---

## 3. Start Minikube

```bash
minikube start
```

(Optional, recommended for autoscaling):

```bash
minikube addons enable metrics-server
```

---

## 4. Prepare Your Application JAR & Config

1. **Build your JAR** (Maven example):

   ```bash
   ./mvnw clean package
   ```

   Your JAR will be in the `target/` directory.

2. **Create an app folder and copy your JAR:**

   ```bash
   mkdir -p /home/docker/app
   cp target/KubernatesPractice-0.0.1-SNAPSHOT.jar /home/docker/app/
   ```

3. **Create your config file** (`application-prod.properties`) as needed.

---

## 5. Create Kubernetes YAML Manifests

Create the following files in your project directory.

---

### a. **ConfigMap (for non-secret config)**

Create `app-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  gfbd_db_schema: "your_schema_name"
  # Add more key-value pairs as needed
```

---

### b. **Secret (for sensitive data)**

Create `db-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  gfbd_db_pass: <BASE64_ENCODED_PASSWORD>
  # Add more as needed
```

*To generate base64:*

```bash
echo -n 'your_db_password' | base64
```

---

### c. **Jasypt Secret (for encryption password)**

Create `jasypt-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: jasypt-secret
type: Opaque
data:
  JASYPT_ENCRYPTOR_PASSWORD: <BASE64_ENCODED_JASYPT_PASSWORD>
```

---

### d. **Deployment (deploys your JAR as a pod)**

Create `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-boot-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spring-boot-app
  template:
    metadata:
      labels:
        app: spring-boot-app
    spec:
      containers:
        - name: spring-boot-app
          image: openjdk:17-jdk-slim
          command:
            - "java"
            - "-jar"
            - "/app/KubernatesPractice-0.0.1-SNAPSHOT.jar"
            - "--spring.config.location=file:/config/application-prod.properties"
          ports:
            - containerPort: 8081
          env:
            - name: SPRING_DATASOURCE_URL
              valueFrom:
                configMapKeyRef:
                  name: db-config
                  key: SPRING_DATASOURCE_URL
            - name: gfbd_db_schema
              valueFrom:
                configMapKeyRef:
                  name: app-config
                  key: gfbd_db_schema
            - name: gfbd_db_pass
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: gfbd_db_pass
            - name: JASYPT_ENCRYPTOR_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: jasypt-secret
                  key: JASYPT_ENCRYPTOR_PASSWORD
            - name: JASYPT_ENCRYPTOR_ALGORITHM
              value: PBEWithMD5AndDES
          volumeMounts:
            - name: jar-volume
              mountPath: /app
            - name: config-volume
              mountPath: /config
      volumes:
        - name: jar-volume
          hostPath:
            path: /home/docker/app
            type: Directory
        - name: config-volume
          configMap:
            name: app-config
```

---

### e. **Service (for network access)**

Create `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-boot-app-service
spec:
  selector:
    app: spring-boot-app
  type: NodePort
  ports:
    - port: 8081
      targetPort: 8081
      nodePort: 32081  # Optional: Set your own NodePort (range 30000-32767)
```

---

## 6. Deploy to Kubernetes

Apply all the manifests:

```bash
kubectl apply -f app-config.yaml
kubectl apply -f db-secret.yaml
kubectl apply -f jasypt-secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

---

## 7. Access Your Application

1. **Get the NodePort of your service:**

   ```bash
   kubectl get svc
   ```

   Find the `PORT(S)` column for your service (e.g. `8081:32081/TCP`).

2. **Get your Minikube IP:**

   ```bash
   minikube ip
   ```

3. **Open in browser:**

   ```
   http://<minikube-ip>:<node-port>
   ```

   Example: If Minikube IP is `192.168.49.2` and NodePort is `32081`,
   visit: `http://192.168.49.2:32081`

---

## 8. Enable Pod Autoscaling (Optional)

1. **Add resource requests/limits to your Deployment:**

   ```yaml
   resources:
     requests:
       cpu: "100m"
       memory: "256Mi"
     limits:
       cpu: "500m"
       memory: "512Mi"
   ```

   Add under your `containers:` section.

2. **Enable metrics server (if not already):**

   ```bash
   minikube addons enable metrics-server
   ```

3. **Create an HPA:**

   ```bash
   kubectl autoscale deployment spring-boot-app --cpu-percent=50 --min=1 --max=10
   ```

4. **Check HPA status:**

   ```bash
   kubectl get hpa
   ```

---

## 9. Useful kubectl Commands

* List all deployments:

  ```bash
  kubectl get deployments
  ```
* List all pods:

  ```bash
  kubectl get pods
  ```
* List all services:

  ```bash
  kubectl get svc
  ```
* See pod details:

  ```bash
  kubectl describe pod <pod-name>
  ```
* View logs:

  ```bash
  kubectl logs <pod-name>
  ```
* Delete all resources (cleanup):

  ```bash
  kubectl delete -f service.yaml
  kubectl delete -f deployment.yaml
  kubectl delete -f app-config.yaml
  kubectl delete -f db-secret.yaml
  kubectl delete -f jasypt-secret.yaml
  ```

---

## 10. Cleanup

To remove everything:

```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f app-config.yaml
kubectl delete -f db-secret.yaml
kubectl delete -f jasypt-secret.yaml
```

To stop Minikube:

```bash
minikube stop
```

To delete the Minikube VM:

```bash
minikube delete
```

---

## 📚 References

* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
* [Spring Boot](https://spring.io/projects/spring-boot)

---

Happy Coding! 🎉
