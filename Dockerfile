FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/usr/local/bin:$PATH"

# Install Ollama CLI
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy your code
COPY api/ api/
COPY web/ web/

# Install Python deps
RUN pip install --no-cache-dir -r api/requirements.txt

EXPOSE 5000

# On container start: 
# 1) launch Ollama server
# 2) wait a bit
# 3) pull llama2 model
# 4) exec Flask
CMD ["sh","-c", "\
  ollama serve & \
  sleep 5 && \
  ollama pull llama2 && \
  exec python api/app.py --host 0.0.0.0 --port 5000 \
"]

