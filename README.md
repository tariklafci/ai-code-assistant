# AI Code Assistant

A Python-based assistant that takes natural language prompts and returns generated Python code along with a short title — powered by a local LLM (LLaMA 2 via Ollama) and deployable on Kubernetes.

---

## Features

- Prompt → Python Code + Title
- Uses LLaMA 2 via Ollama (local LLM, no API keys)
- Simple Flask + HTML frontend
- Dockerized and ready for Kubernetes
- Deployable via:
  - Helm chart

---

## Project Structure

```
.
├── api/              # Flask backend (app.py, job.py, etc.)
├── web/              # Static HTML/CSS frontend
├── chart/            # Helm chart (deployment & service)
├── requirements.txt  # Python dependencies
└── Dockerfile
```

---

## Prerequisites

- Docker
- Minikube
- kubectl


## Run with Docker

```bash
docker build -t ai-code-assistant . (inside the project main folder)
docker run -p 5000:5000 ai-code-assistant (This will download a 3.6GB model, so it may take some time for the website to become available.)
```

Open [http://localhost:5000](http://localhost:5000) in your browser.

---

## Run on Kubernetes (Minikube)

### Option 1: Your Local Docker Build (pullPolicy is defined as: IfNotPresent inside values.yaml, if you build your own build, it will use local build.)

```bash
minikube start --memory=7302 --cpus=4
eval $(minikube docker-env)
docker build -t ai-code-assistant . (inside the project main folder)
```
### Option 2: My DockerHub Build (pullPolicy is defined as: IfNotPresent inside values.yaml, if you do not build with docker build -t, it will automatically download the tariklafci/ai-code-assistant build from DockerHub.)
```bash
minikube start --memory=7302 --cpus=4
```

### Step 2: Deploy with Helm

```bash
helm install ai-code ./chart
minikube service ai-code-assistant (This will download a 3.6GB model with your own build, so it may take some time for the website to become available.)
minikube ip (You can visit the output of this code to reach to the website.)
```

To uninstall:

```bash
helm uninstall ai-code
```

---
