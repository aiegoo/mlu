#!/bin/bash

# MLU Environment Compatibility Checker and Setup
# For systems with existing Anaconda and Jupyter Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "${BLUE}[CHECK]${NC} $1"; }
print_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }

echo "=========================================="
echo "🔍 MLU Environment Compatibility Check 🔍"
echo "=========================================="
echo ""

# System Information
print_header "System Information"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Date: $(date)"
echo ""

# Check Anaconda Installation
print_header "Checking Anaconda Installation..."
CONDA_FOUND=false
CONDA_VERSION=""
CONDA_PATH=""

if command -v conda &> /dev/null; then
    CONDA_FOUND=true
    CONDA_VERSION=$(conda --version 2>/dev/null || echo "Unknown")
    CONDA_PATH=$(which conda)
    print_success "Anaconda/Miniconda found: $CONDA_VERSION"
    print_status "Location: $CONDA_PATH"
    
    # Check conda environments
    print_status "Existing conda environments:"
    conda env list | grep -v "^#" | head -10
else
    print_error "Anaconda/Miniconda not found in PATH"
    echo "Please ensure conda is properly installed and in your PATH"
fi
echo ""

# Check Docker Installation
print_header "Checking Docker Installation..."
DOCKER_FOUND=false
DOCKER_VERSION=""

if command -v docker &> /dev/null; then
    DOCKER_FOUND=true
    DOCKER_VERSION=$(docker --version 2>/dev/null || echo "Unknown")
    print_success "Docker found: $DOCKER_VERSION"
    
    # Check if Docker is running
    if docker ps &> /dev/null; then
        print_success "Docker daemon is running"
        
        # Check for existing Jupyter containers
        JUPYTER_CONTAINERS=$(docker ps -a --filter "name=jupyter" --format "{{.Names}}" 2>/dev/null || echo "")
        if [ ! -z "$JUPYTER_CONTAINERS" ]; then
            print_status "Existing Jupyter Docker containers:"
            echo "$JUPYTER_CONTAINERS"
        else
            print_status "No existing Jupyter Docker containers found"
        fi
    else
        print_warning "Docker daemon not running"
    fi
else
    print_warning "Docker not found"
fi
echo ""

# Check Python Installation
print_header "Checking Python Installation..."
PYTHON_FOUND=false
PYTHON_VERSION=""
PYTHON_PATH=""

for py_cmd in python3 python; do
    if command -v $py_cmd &> /dev/null; then
        PYTHON_FOUND=true
        PYTHON_VERSION=$($py_cmd --version 2>&1)
        PYTHON_PATH=$(which $py_cmd)
        print_success "Python found: $PYTHON_VERSION"
        print_status "Location: $PYTHON_PATH"
        break
    fi
done

if [ "$PYTHON_FOUND" = false ]; then
    print_error "Python not found"
fi
echo ""

# Check GPU Support
print_header "Checking GPU Support..."
GPU_AVAILABLE=false
if command -v nvidia-smi &> /dev/null; then
    GPU_INFO=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits 2>/dev/null || echo "Error reading GPU")
    print_success "NVIDIA GPU detected:"
    echo "$GPU_INFO"
    GPU_AVAILABLE=true
else
    print_warning "No NVIDIA GPU detected or nvidia-smi not available"
fi
echo ""

# Environment Setup Options
print_header "Recommended Setup Options"
echo ""

# Option 1: Conda Environment (Recommended)
if [ "$CONDA_FOUND" = true ]; then
    echo "🐍 OPTION 1: Conda Environment (Recommended)"
    echo "   ✅ Use your existing Anaconda installation"
    echo "   ✅ Create isolated MLU environment"
    echo "   ✅ Easy package management"
    echo "   ✅ GPU support available"
    echo ""
fi

# Option 2: Docker Jupyter (For containerized development)
if [ "$DOCKER_FOUND" = true ]; then
    echo "🐳 OPTION 2: Docker Jupyter Environment"
    echo "   ✅ Use your existing Docker setup"
    echo "   ✅ Completely isolated environment"
    echo "   ✅ Reproducible across systems"
    echo "   ✅ Easy to share and deploy"
    echo ""
fi

# Option 3: Hybrid Approach
if [ "$CONDA_FOUND" = true ] && [ "$DOCKER_FOUND" = true ]; then
    echo "🔄 OPTION 3: Hybrid Approach"
    echo "   ✅ Conda environment for development"
    echo "   ✅ Docker for deployment and sharing"
    echo "   ✅ Best of both worlds"
    echo ""
fi

# Interactive Setup Choice
echo "Which setup would you like to configure?"
if [ "$CONDA_FOUND" = true ] && [ "$DOCKER_FOUND" = true ]; then
    echo "1) Conda Environment (recommended for development)"
    echo "2) Docker Jupyter (containerized)"
    echo "3) Hybrid Setup (both)"
    echo "4) Skip automatic setup"
    read -p "Choose option (1-4) [1]: " setup_choice
else
    if [ "$CONDA_FOUND" = true ]; then
        echo "1) Conda Environment"
        echo "2) Skip automatic setup"
        read -p "Choose option (1-2) [1]: " setup_choice
        # Map to main choices
        case $setup_choice in
            2) setup_choice=4 ;;
            *) setup_choice=1 ;;
        esac
    elif [ "$DOCKER_FOUND" = true ]; then
        echo "1) Docker Jupyter"
        echo "2) Skip automatic setup"
        read -p "Choose option (1-2) [1]: " setup_choice
        # Map to main choices
        case $setup_choice in
            2) setup_choice=4 ;;
            *) setup_choice=2 ;;
        esac
    else
        print_error "Neither conda nor Docker found. Please install one of them first."
        exit 1
    fi
fi

case ${setup_choice:-1} in
    1)
        print_header "Setting up Conda Environment..."
        ./setup_conda_environment.sh
        ;;
    2)
        print_header "Setting up Docker Jupyter Environment..."
        ./setup_docker_environment.sh
        ;;
    3)
        print_header "Setting up Hybrid Environment..."
        ./setup_conda_environment.sh
        ./setup_docker_environment.sh
        ;;
    4)
        print_status "Skipping automatic setup"
        ;;
    *)
        print_warning "Invalid choice, using conda environment"
        ./setup_conda_environment.sh
        ;;
esac

# Create environment info file
print_header "Creating environment information file..."
cat > mlu_environment_info.json << EOF
{
    "setup_date": "$(date -Iseconds)",
    "system": {
        "os": "$(uname -s)",
        "architecture": "$(uname -m)"
    },
    "conda": {
        "available": $CONDA_FOUND,
        "version": "$CONDA_VERSION",
        "path": "$CONDA_PATH"
    },
    "docker": {
        "available": $DOCKER_FOUND,
        "version": "$DOCKER_VERSION"
    },
    "python": {
        "available": $PYTHON_FOUND,
        "version": "$PYTHON_VERSION",
        "path": "$PYTHON_PATH"
    },
    "gpu": {
        "available": $GPU_AVAILABLE,
        "info": "$GPU_INFO"
    },
    "setup_choice": $setup_choice
}
EOF

print_success "Environment check complete!"
print_status "Environment info saved to: mlu_environment_info.json"
echo ""
echo "🚀 Next steps:"
echo "   1. Review the setup based on your choice"
echo "   2. Run 'jupyter lab' or use Docker container"
echo "   3. Open 01_foundations/week1_deep_learning_mastery.ipynb"
echo "   4. Begin your deep learning journey!"
echo ""