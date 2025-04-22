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
docker build -t ai-code-assistant .
docker run -p 5000:5000 ai-code-assistant
```

Open [http://localhost:5000](http://localhost:5000) in your browser.

---

## Run on Kubernetes (Minikube)

### Step 1: Start Minikube

```bash
minikube start --memory=7302 --cpus=4
eval $(minikube docker-env)
docker build -t ai-code-assistant .
```
### Step 2: Deploy with Helm

```bash
helm install ai-code ./chart
minikube service ai-code-assistant-service
```

To uninstall:

```bash
helm uninstall ai-code
```

---
