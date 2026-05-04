# MuchToDo Containerization and Kubernetes Deployment

This project demonstrates the containerization of a Go-based API and its orchestration using Kubernetes (Kind).

## Project Structure
- Dockerfile: Multi-stage build for the Go backend.
- docker-compose.yml: For local development and testing.
- /kubernetes:
    - /mongodb: Deployment, Service, PVC, and ConfigMaps for the database.
    - /backend: Deployment, Service, Secrets, and ConfigMaps for the API.
    - ingress.yaml: Routing configuration.

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Kind (Kubernetes in Docker)
- Kubectl

### Deployment Steps
1. Automated Setup:
   Run the deployment script to build the image, load it into Kind, and apply manifests:
   ```bash
   chmod +x k8s-deploy.sh
   ./k8s-deploy.sh


2. Manual Verification: 
   Check if the pods are running and the backend is connected to MongoDB:


   ```bash
   kubectl get pods -n muchtodo-ns
   kubectl logs -l app=backend-api -n muchtodo-ns
   ```

   The logs must show: "Successfully connected to MongoDB."  

3. Accessing the Application:
Forward the service port to your local machine:

   ```bash
   kubectl port-forward -n muchtodo-ns svc/backend-service 8080:8080
   Visit http://localhost:8080/health in your browser.




### Testing with Docker Compose
To run the stack in Docker directly:

```Bash
docker-compose up -d --build
Access the API at http://localhost:8080.
```

### Cleanup
To remove all Kubernetes resources created:

```Bash
./k8s-cleanup.sh



