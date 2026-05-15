# DevOps Case Study

This repository contains a DevOps case study for deploying two different project types:

1. A MERN Stack application
2. A Python ETL project

The MERN application includes a React frontend, an Express.js backend, and a MongoDB database.  
The Python project includes an `ETL.py` script that is scheduled to run every hour using Kubernetes CronJob.

---

## 1. Project Overview

The goal of this project is to demonstrate containerization, orchestration, CI/CD, infrastructure as code, and deployment practices.

This project includes:

- Dockerfiles for frontend, backend, and Python ETL
- Docker Compose configuration for local containerized deployment
- Kubernetes manifests for orchestration
- Kubernetes CronJob for scheduled Python ETL execution
- GitHub Actions workflow for CI/CD validation
- Terraform files for AWS infrastructure provisioning
- Screenshots showing the running system

---

## 2. Architecture

The MERN application architecture is:

```text
User Browser
    |
    v
React Frontend
    |
    v
Express.js Backend API
    |
    v
MongoDB Database
```

The Python ETL architecture is:

```text
Kubernetes CronJob
    |
    v
ETL.py
    |
    v
GitHub API
```

---

## 3. Technologies Used

- React
- Node.js
- Express.js
- MongoDB
- Python
- Docker
- Docker Compose
- Kubernetes
- Kubernetes CronJob
- GitHub Actions
- Terraform
- AWS EC2

---

## 4. Project Structure

```text
DevOps Case/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── k8s/
│   ├── namespace.yaml
│   ├── mongo.yaml
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── python-cronjob.yaml
│
├── mern-project/
│   ├── client/
│   │   ├── Dockerfile
│   │   └── ...
│   └── server/
│       ├── Dockerfile
│       └── ...
│
├── python-project/
│   ├── Dockerfile
│   ├── ETL.py
│   └── requirements.txt
│
├── screenshots/
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
│
├── docker-compose.yml
└── README.md
```

---

## 5. Local Development

### Backend

```bash
cd mern-project/server
npm install
npm start
```

The backend runs on:

```text
http://localhost:5050
```

Healthcheck endpoint:

```text
http://localhost:5050/healthcheck
```

### Frontend

```bash
cd mern-project/client
npm install
npm start
```

The frontend runs on:

```text
http://localhost:3000
```

### MongoDB

MongoDB can be started locally using Docker:

```bash
docker run -d --name devops-mongo -p 27017:27017 mongo:7
```

MongoDB runs on:

```text
mongodb://localhost:27017
```

---

## 6. Docker Deployment

Each component has its own Dockerfile.

### Backend Docker Build

```bash
docker build -t devops-backend:local ./mern-project/server
```

### Frontend Docker Build

```bash
docker build -t devops-frontend:local --build-arg REACT_APP_API_URL=http://localhost:5050 ./mern-project/client
```

### Python ETL Docker Build

```bash
docker build -t devops-etl:local ./python-project
```

### Python ETL Docker Test

```bash
docker run --rm devops-etl:local
```

Expected output:

```text
<Response [200]>
```

This confirms that the Python ETL container can successfully reach the GitHub API.

---

## 7. Docker Compose Deployment

Docker Compose is used to run the MERN stack locally with a single command.

```bash
docker compose up --build
```

The Docker Compose setup includes:

- React frontend
- Express.js backend
- MongoDB database

Frontend URL:

```text
http://localhost:3000
```

Backend URL:

```text
http://localhost:5050
```

MongoDB connection inside Docker Compose:

```text
mongodb://mongodb:27017
```

To stop the Docker Compose environment:

```bash
docker compose down
```

---

## 8. Kubernetes Deployment

Kubernetes manifests are located in the `k8s/` directory.

### Apply Kubernetes Resources

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongo.yaml
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
kubectl apply -f k8s/python-cronjob.yaml
```

### Check Kubernetes Pods

```bash
kubectl get pods -n devops-case
```

Expected result:

```text
backend    Running
frontend   Running
mongodb    Running
```

### Check Kubernetes Services

```bash
kubectl get svc -n devops-case
```

Expected services:

```text
backend    NodePort
frontend   NodePort
mongodb    ClusterIP
```

### Local Kubernetes Port Forwarding

Frontend:

```bash
kubectl port-forward svc/frontend 8080:80 -n devops-case
```

Backend:

```bash
kubectl port-forward svc/backend 30050:5050 -n devops-case
```

After port forwarding, the frontend can be accessed from:

```text
http://localhost:8080
```

Backend healthcheck:

```text
http://localhost:30050/healthcheck
```

---

## 9. Python ETL CronJob

The Python ETL script is scheduled using Kubernetes CronJob.

CronJob file:

```text
k8s/python-cronjob.yaml
```

Cron schedule:

```text
0 * * * *
```

This means the ETL job runs at the beginning of every hour.

### Check CronJob

```bash
kubectl get cronjob etl-cronjob -n devops-case
```

### Describe CronJob

```bash
kubectl describe cronjob etl-cronjob -n devops-case
```

### Check ETL Job Logs

```bash
kubectl get jobs -n devops-case
kubectl logs job/<job-name> -n devops-case
```

Successful output example:

```text
<Response [200]>
```

This confirms that `ETL.py` successfully ran and reached the GitHub API.

---

## 10. CI/CD Pipeline

GitHub Actions is used for CI/CD validation.

Workflow file:

```text
.github/workflows/ci-cd.yml
```

The pipeline runs on push and pull request events.

The workflow performs these steps:

1. Checks out the repository
2. Builds the backend Docker image
3. Builds the frontend Docker image
4. Builds the Python ETL Docker image
5. Lists Docker images

This validates that all project components can be built successfully.

---

## 11. AWS Infrastructure with Terraform

Terraform files are located in the `terraform/` directory.

The Terraform configuration provisions:

- AWS EC2 instance
- Security group
- SSH access
- HTTP access
- Kubernetes NodePort access
- 25 GB root disk

### Terraform Commands

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs:

- EC2 public IP
- Frontend URL
- Backend healthcheck URL
- SSH command

---

## 12. Screenshots

Screenshots are stored in the `screenshots/` directory.

Recommended screenshots:

1. Docker Compose running containers
2. Kubernetes pods running
3. Kubernetes services
4. Frontend API Status OK
5. Create Record page
6. Record List page
7. ETL CronJob log output
8. GitHub Actions successful pipeline
9. AWS deployed frontend URL
10. AWS backend healthcheck URL

---

## 13. Challenges and Solutions

### Challenge 1: Hardcoded localhost in frontend

The original frontend code used hardcoded backend URLs such as:

```text
http://localhost:5050
```

This is not suitable for Docker, Kubernetes, or cloud deployment.

Solution:

The frontend was updated to use:

```text
REACT_APP_API_URL
```

This makes the backend API URL configurable for different environments.

---

### Challenge 2: Container networking

Inside Docker and Kubernetes, `localhost` does not always refer to another service.

Solution:

- Docker Compose uses service names such as `mongodb`
- Kubernetes uses services such as `mongodb`, `backend`, and `frontend`

For example, the backend connects to MongoDB in Kubernetes using:

```text
mongodb://mongodb:27017
```

---

### Challenge 3: Python ETL scheduling

The Python script needed to run every hour.

Solution:

A Kubernetes CronJob was created with this schedule:

```text
0 * * * *
```

This schedules `ETL.py` to run every hour.

---

## 14. Acceptance Criteria

### MERN Application

- MongoDB connection works
- Backend endpoints work
- Frontend pages work
- Create Record works
- Record List works

### Python Project

- `ETL.py` runs successfully
- `ETL.py` is scheduled to run every hour using Kubernetes CronJob

---

## 15. Conclusion

This project demonstrates a complete DevOps workflow for a MERN Stack application and a Python ETL project.

The solution includes:

- Containerization with Docker
- Local multi-container deployment with Docker Compose
- Orchestration with Kubernetes
- Scheduled execution with Kubernetes CronJob
- CI/CD validation with GitHub Actions
- AWS infrastructure preparation with Terraform