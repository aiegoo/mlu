#!/bin/bash

# Docker Jupyter Environment Setup for MLU
# Creates optimized Jupyter Docker container

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_header() { echo -e "${BLUE}[DOCKER]${NC} $1"; }

print_header "Setting up MLU Docker Environment"

# Create Dockerfile for MLU
print_status "Creating optimized Dockerfile..."
cat > Dockerfile.mlu << 'EOF'
# MLU Deep Learning Docker Environment
FROM jupyter/pytorch-notebook:latest

# Switch to root for system installations
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    vim \
    htop \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan user
USER jovyan

# Copy requirements
COPY requirements.txt /tmp/
COPY environments/environment.yml /tmp/

# Install Python packages
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install additional packages for MLU
RUN pip install --no-cache-dir \
    d2l \
    plotly \
    ipywidgets \
    jupyter-dash

# Install Jupyter extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Set working directory
WORKDIR /home/jovyan/work

# Create MLU directory structure
RUN mkdir -p \
    01_foundations \
    02_ml_basics \
    03_deep_learning \
    04_computer_vision \
    05_nlp \
    06_advanced \
    07_projects \
    datasets \
    utils \
    resources

# Copy MLU content
COPY --chown=jovyan:users . .

# Expose Jupyter port
EXPOSE 8888

# Start Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
EOF

# Create docker-compose for easier management
print_status "Creating docker-compose.yml..."
cat > docker-compose.mlu.yml << 'EOF'
version: '3.8'

services:
  mlu-jupyter:
    build:
      context: .
      dockerfile: Dockerfile.mlu
    container_name: mlu-deep-learning
    ports:
      - "8888:8888"
    volumes:
      - .:/home/jovyan/work
      - mlu_data:/home/jovyan/work/datasets
      - mlu_models:/home/jovyan/work/models
    environment:
      - JUPYTER_ENABLE_LAB=yes
      - JUPYTER_TOKEN=${JUPYTER_TOKEN:-[set in .env.mlu]}
    restart: unless-stopped
    networks:
      - mlu-network

  # Optional: TensorBoard service
  tensorboard:
    image: tensorflow/tensorflow:latest
    container_name: mlu-tensorboard
    ports:
      - "6006:6006"
    volumes:
      - ./logs:/logs
    command: tensorboard --logdir=/logs --host=0.0.0.0 --port=6006
    networks:
      - mlu-network
    profiles:
      - tensorboard

volumes:
  mlu_data:
  mlu_models:

networks:
  mlu-network:
    driver: bridge
EOF

# Create environment file for Docker
print_status "Creating Docker environment file..."
cat > .env.mlu << 'EOF'
# MLU Docker Environment Configuration
JUPYTER_TOKEN=
COMPOSE_PROJECT_NAME=mlu
DOCKER_BUILDKIT=1
EOF

# Create startup script
print_status "Creating Docker startup scripts..."

# Linux/Mac startup script
cat > start_mlu_docker.sh << 'EOF'
#!/bin/bash

echo "🐳 Starting MLU Docker Environment..."

# Check if Docker is running
if ! docker ps &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Load environment
if [ -f .env.mlu ]; then
    export $(grep -v '^#' .env.mlu | xargs)
fi

# Start services
docker-compose -f docker-compose.mlu.yml up -d

echo "✅ MLU Docker environment started!"
echo ""
echo "🚀 Access Jupyter Lab:"
echo "   URL: http://localhost:8888"
echo "   Token: ${JUPYTER_TOKEN:-mlu2025}"
echo ""
echo "📚 Quick commands:"
echo "   docker-compose -f docker-compose.mlu.yml logs -f    # View logs"
echo "   docker-compose -f docker-compose.mlu.yml down       # Stop services"
echo "   docker exec -it mlu-deep-learning bash              # Shell access"
EOF

# Windows batch script
cat > start_mlu_docker.bat << 'EOF'
@echo off
echo 🐳 Starting MLU Docker Environment...

REM Check if Docker is running
docker ps >nul 2>nul
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker first.
    exit /b 1
)

REM Start services
docker-compose -f docker-compose.mlu.yml up -d

echo ✅ MLU Docker environment started!
echo.
echo 🚀 Access Jupyter Lab:
echo    URL: http://localhost:8888
echo    Token: mlu2025
echo.
echo 📚 Quick commands:
echo    docker-compose -f docker-compose.mlu.yml logs -f    # View logs
echo    docker-compose -f docker-compose.mlu.yml down       # Stop services
echo    docker exec -it mlu-deep-learning bash              # Shell access
EOF

chmod +x start_mlu_docker.sh

# Create stop script
cat > stop_mlu_docker.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping MLU Docker Environment..."
docker-compose -f docker-compose.mlu.yml down
echo "✅ MLU Docker environment stopped!"
EOF

chmod +x stop_mlu_docker.sh

# Build and start option
echo ""
echo "Docker environment setup complete!"
echo ""
echo "Would you like to build and start the container now? (y/n) [y]: "
read -r start_now

if [[ ${start_now:-y} =~ ^[Yy]$ ]]; then
    print_status "Building MLU Docker image..."
    docker build -f Dockerfile.mlu -t mlu-deep-learning .
    
    print_status "Starting MLU Docker environment..."
    ./start_mlu_docker.sh
    
    echo ""
    echo "🎉 MLU Docker environment is ready!"
    echo "🌐 Access Jupyter Lab: http://localhost:8888"
    echo "🔑 Token: mlu2025"
    echo ""
else
    echo ""
    echo "🔧 To build and start later:"
    echo "   ./start_mlu_docker.sh"
    echo ""
fi

print_status "✅ Docker environment setup complete!"