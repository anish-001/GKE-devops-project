# GKE DevOps Project

A three-tier task management application deployed on Google Kubernetes Engine (GKE), with CI/CD pipelines and Terraform-based infrastructure.

## Project Structure

- `/Application-Code`
  - `backend` - Node.js + Express + MongoDB REST API
  - `frontend` - React task UI
  - `docker-compose.yml` - local multi-service run
  - `start-mongodb.sh` - helper to run MongoDB in Docker
- `/Kubernetes-Manifests-file`
  - `Database/`, `Backend/`, `Frontend/` - Kubernetes deployments/services
  - `ingress.yaml` - app routing
  - `deploy-all.sh` - full deployment helper
  - `troubleshoot.sh` - quick diagnostics
- `/k8s-file`
  - Deployment files updated by Jenkins image-tag stages
- `/Pipeline-Code`
  - `jenkinsfile-Backend`
  - `jenkinsfile-Frontend`
- `/gke-cluster`
  - Terraform for GKE cluster and related networking/services
- `/Server-TF`
  - Terraform for server/network resources used by the project

## Architecture

- **Frontend**: React app (port `3000`)
- **Backend**: Express API (port `3500`) with health endpoints (`/healthz`, `/ready`, `/started`)
- **Database**: MongoDB (`27017`)
- **Kubernetes namespace**: `three-tier`

## Local Development

### Prerequisites

- Node.js and npm
- Docker

### 1) Start MongoDB

```bash
cd /home/runner/work/GKE-devops-project/GKE-devops-project/Application-Code
./start-mongodb.sh
```

### 2) Run backend

```bash
cd /home/runner/work/GKE-devops-project/GKE-devops-project/Application-Code/backend
npm install
npm run dev
```

### 3) Run frontend

```bash
cd /home/runner/work/GKE-devops-project/GKE-devops-project/Application-Code/frontend
npm install
npm start
```

### Optional: run with Docker Compose

```bash
cd /home/runner/work/GKE-devops-project/GKE-devops-project/Application-Code
docker compose up --build
```

## Deploy to Kubernetes

```bash
cd /home/runner/work/GKE-devops-project/GKE-devops-project/Kubernetes-Manifests-file
chmod +x deploy-all.sh
./deploy-all.sh
```

Check resources:

```bash
kubectl get pods -n three-tier
kubectl get services -n three-tier
```

For troubleshooting:

```bash
chmod +x troubleshoot.sh
./troubleshoot.sh
```

## CI/CD Pipelines

Jenkins pipelines are available for backend and frontend in `/Pipeline-Code`.

Main flow:

1. Checkout code
2. Trivy filesystem scan
3. Build Docker image
4. Push image to Google Artifact Registry
5. Trivy image scan
6. Update deployment image tag in `/k8s-file/*/deployment.yaml`

## Infrastructure as Code

- `/gke-cluster`: provisions GKE and related Google Cloud services
- `/Server-TF`: provisions additional server/network resources

Run Terraform in each directory as needed:

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- Backend uses `MONGO_CONN_STR` and optional `MONGO_USERNAME`/`MONGO_PASSWORD` for DB auth.
- Frontend backend endpoint is controlled by `REACT_APP_BACKEND_URL`.
