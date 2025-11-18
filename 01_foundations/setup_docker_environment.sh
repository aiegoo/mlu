#!/bin/bash
# MLU Docker Environment Setup Script
# This script sets up a Docker environment for the MLU deep learning course
# Integrates with the compatibility checker for optimal container setup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
CONTAINER_NAME="mlu-jupyter"
IMAGE_NAME="mlu-deeplearning"
JUPYTER_PORT="8888"
TENSORBOARD_PORT="6006"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
COMPAT_NOTEBOOK="${SCRIPT_DIR}/environment_compatibility_check.ipynb"

echo -e "${BLUE}🐳 MLU Docker Environment Setup${NC}"
echo "====================================="
echo "Setting up containerized environment for deep learning..."
echo ""

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Error: Docker not found!${NC}"
    echo "Please install Docker first."
    echo "Visit: https://www.docker.com/get-started"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Error: Docker daemon not running!${NC}"
    echo "Please start Docker and try again."
    exit 1
fi

echo -e "${GREEN}✅ Docker is installed and running${NC}"
docker --version
echo ""

# Run compatibility check if available
if [[ -f "$COMPAT_NOTEBOOK" ]]; then
    echo -e "${PURPLE}🔍 Compatibility check notebook found${NC}"
    echo "💡 Run the compatibility notebook first to get personalized recommendations!"
    echo "   jupyter notebook $COMPAT_NOTEBOOK"
    echo ""
else
    echo -e "${YELLOW}⚠️  Compatibility check notebook not found.${NC}"
    echo "Proceeding with standard Docker setup..."
fi

# Check if container already exists
if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}⚠️  Container '${CONTAINER_NAME}' already exists.${NC}"
    
    # Check if it's running
    if docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo -e "${GREEN}✅ Container is already running!${NC}"
        echo "Access Jupyter at: http://localhost:${JUPYTER_PORT}"
        echo "Access TensorBoard at: http://localhost:${TENSORBOARD_PORT}"
        exit 0
    fi
    
    read -p "Do you want to remove and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🗑️  Removing existing container...${NC}"
        docker rm -f "$CONTAINER_NAME" || true
    else
        echo -e "${BLUE}🚀 Starting existing container...${NC}"
        docker start "$CONTAINER_NAME"
        echo -e "${GREEN}✅ Container started!${NC}"
        echo "Access Jupyter at: http://localhost:${JUPYTER_PORT}"
        echo "Access TensorBoard at: http://localhost:${TENSORBOARD_PORT}"
        exit 0
    fi
fi

# Create Dockerfile if it doesn't exist
DOCKERFILE="${SCRIPT_DIR}/Dockerfile.mlu"
if [[ ! -f "$DOCKERFILE" ]]; then
    echo -e "${BLUE}📝 Creating optimized Dockerfile...${NC}"
    cat > "$DOCKERFILE" << 'EOF'
# MLU Deep Learning Environment
FROM jupyter/tensorflow-notebook:latest

# Switch to root to install system packages
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    vim \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Install nvidia-ml-py for GPU monitoring
RUN pip install nvidia-ml-py3 || echo "nvidia-ml-py3 not available (CPU-only environment)"

# Switch back to jovyan user
USER $NB_UID

# Install Python packages
RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    d2l \
    plotly \
    seaborn \
    scikit-learn \
    tqdm \
    tensorboard \
    ipywidgets \
    psutil

# Enable Jupyter extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter lab build && \
    jupyter lab clean

# Create workspace directory
RUN mkdir -p /home/jovyan/mlu

# Set working directory
WORKDIR /home/jovyan/mlu

# Expose ports for Jupyter and TensorBoard
EXPOSE 8888 6006

# Start Jupyter Lab
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
EOF
    echo -e "${GREEN}✅ Dockerfile created: $DOCKERFILE${NC}"
fi

# Build Docker image
echo -e "${BLUE}🔨 Building Docker image...${NC}"
echo "This may take several minutes on first run..."
echo ""

docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" "$SCRIPT_DIR" || {
    echo -e "${RED}❌ Failed to build Docker image${NC}"
    exit 1
}

echo -e "${GREEN}✅ Docker image built successfully${NC}"
echo ""

# Detect GPU support
GPU_ARGS=""
if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
    echo -e "${GREEN}🎮 NVIDIA GPU detected!${NC}"
    echo "Enabling GPU support in container..."
    GPU_ARGS="--gpus all"
else
    echo -e "${YELLOW}ℹ️  No NVIDIA GPU detected or nvidia-docker not installed.${NC}"
    echo "Running in CPU-only mode..."
fi

# Run Docker container
echo -e "${BLUE}🚀 Starting Docker container...${NC}"

docker run -d \
    --name "$CONTAINER_NAME" \
    $GPU_ARGS \
    -p "${JUPYTER_PORT}:8888" \
    -p "${TENSORBOARD_PORT}:6006" \
    -v "${WORKSPACE_DIR}:/home/jovyan/mlu" \
    -e JUPYTER_ENABLE_LAB=yes \
    "$IMAGE_NAME"

# Wait for container to start
echo "Waiting for Jupyter to start..."
sleep 10

# Check if container is running
if docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${GREEN}✅ Container started successfully!${NC}"
    echo ""
    echo -e "${BLUE}📚 Access Information:${NC}"
    echo "======================================"
    echo -e "${GREEN}🌐 Jupyter Lab: http://localhost:${JUPYTER_PORT}${NC}"
    echo -e "${GREEN}📊 TensorBoard: http://localhost:${TENSORBOARD_PORT}${NC}"
    echo ""
    
    # Try to get Jupyter token (optional)
    TOKEN=$(docker exec "$CONTAINER_NAME" jupyter notebook list 2>/dev/null | grep -o 'token=[^[:space:]]*' | head -1 | cut -d'=' -f2 || echo "")
    if [[ -n "$TOKEN" ]]; then
        echo -e "${PURPLE}🔑 Jupyter Token: ${TOKEN}${NC}"
        echo -e "${PURPLE}🔗 Direct Link: http://localhost:${JUPYTER_PORT}/?token=${TOKEN}${NC}"
        echo ""
    fi
    
    echo -e "${BLUE}📋 Container Management:${NC}"
    echo "• View logs: docker logs $CONTAINER_NAME"
    echo "• Stop container: docker stop $CONTAINER_NAME"
    echo "• Start container: docker start $CONTAINER_NAME"
    echo "• Remove container: docker rm -f $CONTAINER_NAME"
    echo "• Access shell: docker exec -it $CONTAINER_NAME bash"
    echo ""
    
    echo -e "${PURPLE}💡 Pro Tips:${NC}"
    echo "• Your workspace is mounted at /home/jovyan/mlu in the container"
    echo "• All changes to notebooks are automatically saved to your host machine"
    echo "• Use TensorBoard for visualization: tensorboard --logdir=./logs --host=0.0.0.0"
    echo ""
    
    # Test basic functionality
    echo -e "${BLUE}🔍 Testing container functionality...${NC}"
    docker exec "$CONTAINER_NAME" python -c "
import sys
print(f'Python version: {sys.version}')
print()

packages = ['numpy', 'pandas', 'matplotlib', 'torch', 'd2l', 'jupyter']
for pkg in packages:
    try:
        module = __import__(pkg)
        if hasattr(module, '__version__'):
            version = module.__version__
        else:
            version = 'unknown'
        print(f'✅ {pkg}: {version}')
    except ImportError:
        print(f'❌ {pkg}: not installed')

# Check PyTorch CUDA (if applicable)
try:
    import torch
    print(f'🎮 PyTorch CUDA available: {torch.cuda.is_available()}')
    if torch.cuda.is_available():
        print(f'   GPU count: {torch.cuda.device_count()}')
except:
    pass
"
    
    echo ""
    echo -e "${GREEN}🎉 MLU Docker environment is ready!${NC}"
    echo "====================================="
    echo ""
    echo -e "${BLUE}📚 Next steps:${NC}"
    echo "1. Open your browser to http://localhost:${JUPYTER_PORT}"
    echo "2. Run the compatibility check notebook"
    echo "3. Start with week1_deep_learning_mastery.ipynb"
    echo ""
    echo -e "${GREEN}Happy learning in your containerized environment! 🚀${NC}"
    
else
    echo -e "${RED}❌ Failed to start container${NC}"
    echo "Check logs with: docker logs $CONTAINER_NAME"
    exit 1
fi