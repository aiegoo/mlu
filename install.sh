#!/bin/bash

# Deep Learning Mastery (MLU) Installation Script
# This script automates the setup of your deep learning environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

# Welcome message
echo "=================================="
echo "🧠 Deep Learning Mastery Setup 🧠"
echo "=================================="
echo ""
print_status "Starting automated setup for your deep learning environment..."
echo ""

# Check if Python is installed
print_header "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_status "Found $PYTHON_VERSION"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    print_status "Found $PYTHON_VERSION"
    PYTHON_CMD="python"
else
    print_error "Python is not installed. Please install Python 3.8+ first."
    echo "Visit: https://www.python.org/downloads/"
    exit 1
fi

# Check Python version
PYTHON_VERSION_NUM=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
REQUIRED_VERSION="3.8"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION_NUM" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then 
    print_status "Python version $PYTHON_VERSION_NUM is compatible"
else
    print_error "Python version $PYTHON_VERSION_NUM is too old. Please upgrade to Python 3.8+"
    exit 1
fi

# Detect package manager preference
print_header "Detecting package management preference..."
INSTALL_METHOD=""
if command -v conda &> /dev/null; then
    echo "1) Conda (Anaconda/Miniconda) - Recommended"
    echo "2) pip (Python package installer)"
    echo "3) Auto-detect (use conda if available)"
    read -p "Choose installation method (1-3) [3]: " choice
    case ${choice:-3} in
        1) INSTALL_METHOD="conda" ;;
        2) INSTALL_METHOD="pip" ;;
        3) INSTALL_METHOD="conda" ;;
        *) print_warning "Invalid choice, using conda"; INSTALL_METHOD="conda" ;;
    esac
else
    print_status "Conda not found, using pip"
    INSTALL_METHOD="pip"
fi

# GPU Detection
print_header "Checking for GPU support..."
GPU_AVAILABLE=false
if command -v nvidia-smi &> /dev/null; then
    print_status "NVIDIA GPU detected"
    nvidia-smi --query-gpu=name --format=csv,noheader,nounits | head -n1
    GPU_AVAILABLE=true
    
    echo "Do you want to install GPU-accelerated PyTorch? (y/n) [y]: "
    read -r gpu_choice
    if [[ ${gpu_choice:-y} =~ ^[Yy]$ ]]; then
        USE_GPU=true
        print_status "Will install CUDA-enabled PyTorch"
    else
        USE_GPU=false
        print_status "Will install CPU-only PyTorch"
    fi
else
    print_status "No NVIDIA GPU detected, installing CPU-only version"
    USE_GPU=false
fi

# Create virtual environment
print_header "Setting up virtual environment..."
ENV_NAME="mlu"

if [ "$INSTALL_METHOD" = "conda" ]; then
    print_status "Creating conda environment: $ENV_NAME"
    
    # Check if environment already exists
    if conda env list | grep -q "^$ENV_NAME "; then
        print_warning "Environment '$ENV_NAME' already exists"
        echo "Do you want to remove and recreate it? (y/n) [n]: "
        read -r recreate_choice
        if [[ ${recreate_choice:-n} =~ ^[Yy]$ ]]; then
            print_status "Removing existing environment..."
            conda env remove -n $ENV_NAME -y
        else
            print_status "Using existing environment"
        fi
    fi
    
    # Create environment from YAML if it doesn't exist
    if ! conda env list | grep -q "^$ENV_NAME "; then
        if [ -f "environments/environment.yml" ]; then
            print_status "Creating environment from environment.yml..."
            conda env create -f environments/environment.yml
        else
            print_status "Creating new conda environment..."
            conda create -n $ENV_NAME python=3.10 -y
        fi
    fi
    
    print_status "Activating conda environment..."
    eval "$(conda shell.bash hook)"
    conda activate $ENV_NAME
    
else
    # pip installation with virtual environment
    print_status "Creating Python virtual environment: ${ENV_NAME}_env"
    
    if [ -d "${ENV_NAME}_env" ]; then
        print_warning "Virtual environment already exists"
        echo "Do you want to remove and recreate it? (y/n) [n]: "
        read -r recreate_choice
        if [[ ${recreate_choice:-n} =~ ^[Yy]$ ]]; then
            print_status "Removing existing virtual environment..."
            rm -rf "${ENV_NAME}_env"
        fi
    fi
    
    if [ ! -d "${ENV_NAME}_env" ]; then
        $PYTHON_CMD -m venv "${ENV_NAME}_env"
    fi
    
    print_status "Activating virtual environment..."
    source "${ENV_NAME}_env/bin/activate"
fi

# Upgrade pip
print_header "Upgrading pip..."
$PYTHON_CMD -m pip install --upgrade pip

# Install PyTorch
print_header "Installing PyTorch..."
if [ "$USE_GPU" = true ]; then
    if [ "$INSTALL_METHOD" = "conda" ]; then
        print_status "Installing GPU-enabled PyTorch with conda..."
        conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y
    else
        print_status "Installing GPU-enabled PyTorch with pip..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    fi
else
    if [ "$INSTALL_METHOD" = "conda" ]; then
        print_status "Installing CPU-only PyTorch with conda..."
        conda install pytorch torchvision torchaudio cpuonly -c pytorch -y
    else
        print_status "Installing CPU-only PyTorch with pip..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    fi
fi

# Install other packages
print_header "Installing additional packages..."
if [ -f "requirements.txt" ]; then
    print_status "Installing from requirements.txt..."
    pip install -r requirements.txt
else
    print_status "Installing essential packages manually..."
    pip install d2l jupyter jupyterlab matplotlib seaborn pandas scikit-learn numpy scipy tqdm plotly
fi

# Install development tools
print_header "Installing development tools..."
pip install black flake8 pytest ipywidgets

# Setup Jupyter kernel
print_header "Setting up Jupyter kernel..."
$PYTHON_CMD -m ipykernel install --user --name=$ENV_NAME --display-name="Deep Learning (MLU)"

# Verify installation
print_header "Verifying installation..."
$PYTHON_CMD -c "
import torch
import d2l
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import sklearn

print('✅ PyTorch version:', torch.__version__)
print('✅ d2l version:', d2l.__version__)
print('✅ NumPy version:', np.__version__)
print('✅ Pandas version:', pd.__version__)
print('✅ Scikit-learn version:', sklearn.__version__)
print('✅ CUDA available:', torch.cuda.is_available())

if torch.cuda.is_available():
    print('✅ CUDA version:', torch.version.cuda)
    print('✅ GPU count:', torch.cuda.device_count())
    print('✅ GPU name:', torch.cuda.get_device_name(0))

# Test basic functionality
x = torch.randn(3, 3)
print('✅ Basic tensor operations working')
print('🎉 Installation verification complete!')
"

# Create activation scripts
print_header "Creating activation scripts..."

# Bash activation script
cat > activate_mlu.sh << 'EOF'
#!/bin/bash
# Activation script for Deep Learning Mastery environment

if command -v conda &> /dev/null && conda env list | grep -q "^mlu "; then
    echo "🧠 Activating conda environment: mlu"
    eval "$(conda shell.bash hook)"
    conda activate mlu
elif [ -d "mlu_env" ]; then
    echo "🧠 Activating virtual environment: mlu_env"
    source mlu_env/bin/activate
else
    echo "❌ No environment found. Please run install.sh first."
    exit 1
fi

echo "✅ Deep Learning Mastery environment activated!"
echo "📚 Quick commands:"
echo "   jupyter lab                    # Start Jupyter Lab"
echo "   jupyter notebook              # Start Jupyter Notebook"  
echo "   python                       # Start Python REPL"
echo "   cd 01_foundations && jupyter lab  # Start with foundations"
EOF

chmod +x activate_mlu.sh

# Windows batch script
cat > activate_mlu.bat << 'EOF'
@echo off
REM Activation script for Deep Learning Mastery environment (Windows)

where conda >nul 2>nul
if %ERRORLEVEL% == 0 (
    conda env list | findstr "^mlu " >nul 2>nul
    if %ERRORLEVEL% == 0 (
        echo 🧠 Activating conda environment: mlu
        call conda activate mlu
        goto :activated
    )
)

if exist "mlu_env\Scripts\activate.bat" (
    echo 🧠 Activating virtual environment: mlu_env
    call mlu_env\Scripts\activate.bat
    goto :activated
)

echo ❌ No environment found. Please run install.sh first.
exit /b 1

:activated
echo ✅ Deep Learning Mastery environment activated!
echo 📚 Quick commands:
echo    jupyter lab                    # Start Jupyter Lab
echo    jupyter notebook              # Start Jupyter Notebook
echo    python                       # Start Python REPL
echo    cd 01_foundations ^&^& jupyter lab  # Start with foundations
EOF

# Create quick start script
cat > quick_start.sh << 'EOF'
#!/bin/bash
# Quick start script - launches Jupyter Lab with the first notebook

source activate_mlu.sh

echo "🚀 Launching Deep Learning Mastery..."
echo "📖 Opening the foundational notebook..."

cd 01_foundations
jupyter lab week1_deep_learning_mastery.ipynb
EOF

chmod +x quick_start.sh

# Success message
echo ""
echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
echo "✅ Deep Learning Mastery Setup Complete!"
echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
echo ""
print_status "Environment: $ENV_NAME"
print_status "Installation method: $INSTALL_METHOD"
print_status "GPU support: $USE_GPU"
echo ""
echo "🚀 Quick Start Commands:"
echo "   ./activate_mlu.sh             # Activate environment"
echo "   ./quick_start.sh              # Launch Jupyter with first notebook"
echo "   source activate_mlu.sh        # Alternative activation"
echo ""
echo "📚 Next Steps:"
echo "   1. Run: ./quick_start.sh"
echo "   2. Open: 01_foundations/week1_deep_learning_mastery.ipynb"
echo "   3. Follow: QUICK_START.md guide"
echo "   4. Read: resources/d2l_study_guide.md"
echo ""
echo "🤝 Need Help?"
echo "   - Read: environments/setup.md"
echo "   - Visit: https://d2l.ai/"
echo "   - Join: https://discuss.d2l.ai/"
echo ""
echo "Happy Learning! 🧠✨"