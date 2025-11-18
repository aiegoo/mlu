#!/bin/bash
# MLU Conda Environment Setup Script
# This script sets up a conda environment specifically for the MLU deep learning course
# Integrates with the compatibility checker for optimal environment setup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
ENV_NAME="mlu"
PYTHON_VERSION="3.9"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPAT_NOTEBOOK="${SCRIPT_DIR}/environment_compatibility_check.ipynb"
REQUIREMENTS_FILE="${SCRIPT_DIR}/../requirements.txt"
ENVIRONMENT_YML="${SCRIPT_DIR}/../environment.yml"

echo -e "${BLUE}🐍 MLU Conda Environment Setup${NC}"
echo "====================================="
echo "Setting up optimized environment based on compatibility check..."
echo ""

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo -e "${RED}❌ Error: Conda not found!${NC}"
    echo "Please install Anaconda or Miniconda first."
    echo "Visit: https://www.anaconda.com/products/distribution"
    exit 1
fi

# Run compatibility check if available
if [[ -f "$COMPAT_NOTEBOOK" ]]; then
    echo -e "${PURPLE}🔍 Running compatibility check...${NC}"
    echo "This will help optimize your environment setup."
    echo ""
    echo "💡 Tip: Run the compatibility notebook first to get personalized recommendations!"
    echo "   jupyter notebook $COMPAT_NOTEBOOK"
    echo ""
else
    echo -e "${YELLOW}⚠️  Compatibility check notebook not found.${NC}"
    echo "Proceeding with standard setup..."
fi

# Check conda version and configuration
echo -e "${BLUE}📋 Conda Information:${NC}"
conda --version
echo "Conda environments:"
conda env list | head -10  # Limit output
echo ""

# Check if environment already exists
if conda env list | grep -q "^${ENV_NAME} "; then
    echo -e "${YELLOW}⚠️  Environment '${ENV_NAME}' already exists.${NC}"
    read -p "Do you want to remove and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🗑️  Removing existing environment...${NC}"
        conda env remove -n "$ENV_NAME" -y
    else
        echo "Exiting without changes."
        echo -e "${GREEN}💡 To activate existing environment: conda activate ${ENV_NAME}${NC}"
        exit 0
    fi
fi

# Create conda environment using environment.yml if available
if [[ -f "$ENVIRONMENT_YML" ]]; then
    echo -e "${BLUE}🔨 Creating conda environment from environment.yml...${NC}"
    conda env create -f "$ENVIRONMENT_YML" -n "$ENV_NAME"
else
    echo -e "${BLUE}🔨 Creating conda environment '${ENV_NAME}' with Python ${PYTHON_VERSION}...${NC}"
    conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y
fi

# Activate environment
echo -e "${BLUE}⚡ Activating environment...${NC}"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_NAME"

# Verify activation
if [[ "$CONDA_DEFAULT_ENV" == "$ENV_NAME" ]]; then
    echo -e "${GREEN}✅ Environment activated successfully!${NC}"
    echo "Current environment: $CONDA_DEFAULT_ENV"
else
    echo -e "${RED}❌ Failed to activate environment${NC}"
    exit 1
fi

# Install core packages using conda-forge
echo -e "${BLUE}📦 Installing core packages via conda-forge...${NC}"
conda config --add channels conda-forge
conda config --set channel_priority strict

# Install basic scientific computing stack
echo "Installing NumPy, Pandas, Matplotlib..."
conda install -y numpy pandas matplotlib seaborn scikit-learn

# Install Jupyter ecosystem
echo "Installing Jupyter ecosystem..."
conda install -y jupyter jupyterlab ipywidgets tqdm

# Install PyTorch (check for CUDA)
echo -e "${BLUE}🔥 Installing PyTorch...${NC}"
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA GPU detected, installing PyTorch with CUDA support..."
    conda install -y pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia
else
    echo "No NVIDIA GPU detected, installing CPU-only PyTorch..."
    conda install -y pytorch torchvision torchaudio cpuonly -c pytorch
fi

# Install additional packages via pip if needed
echo -e "${BLUE}📦 Installing additional packages via pip...${NC}"

# Install d2l package
pip install d2l

# Install other useful packages
pip install plotly tensorboard

# Install additional requirements if file exists
if [[ -f "$REQUIREMENTS_FILE" ]]; then
    echo "Installing packages from requirements.txt..."
    pip install -r "$REQUIREMENTS_FILE"
fi

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"
python -c "
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

# Check PyTorch CUDA
try:
    import torch
    print(f'🎮 PyTorch CUDA available: {torch.cuda.is_available()}')
    if torch.cuda.is_available():
        print(f'   GPU count: {torch.cuda.device_count()}')
except:
    pass
"

echo ""
echo -e "${GREEN}🎉 MLU Conda environment setup complete!${NC}"
echo "====================================="
echo ""
echo -e "${BLUE}📚 Next steps:${NC}"
echo "1. Activate environment: conda activate $ENV_NAME"
echo "2. Run compatibility check: jupyter notebook environment_compatibility_check.ipynb"
echo "3. Start learning: jupyter notebook week1_deep_learning_mastery.ipynb"
echo ""
echo -e "${PURPLE}💡 Pro tips:${NC}"
echo "• Use 'conda deactivate' to exit the environment"
echo "• Use 'conda env list' to see all environments"
echo "• Use 'conda list' to see installed packages"
echo ""
echo -e "${GREEN}Happy learning! 🚀${NC}"

# Save environment info
echo "Saving environment information..."
conda env export > "${SCRIPT_DIR}/mlu_environment_export.yml"
echo -e "${GREEN}✅ Environment exported to mlu_environment_export.yml${NC}"
echo "   Use this file to recreate the environment: conda env create -f mlu_environment_export.yml"