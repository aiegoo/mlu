#!/bin/bash
# MLU Quick Start - Launch Jupyter without password
# This script activates the MLU environment and starts Jupyter

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 MLU Quick Start - Jupyter Launcher${NC}"
echo "====================================="
echo ""

# Check if conda is available
if ! command -v conda &> /dev/null; then
    echo "❌ Error: Conda not found. Please install Anaconda first."
    exit 1
fi

# Check if MLU environment exists, create if missing
if ! conda env list | grep -q "^mlu "; then
    echo -e "${PURPLE}🔧 MLU environment not found. Creating it now...${NC}"
    echo ""
    
    # Check if we have setup script in current directory
    if [[ -f "01_foundations/setup_conda_environment.sh" ]]; then
        echo "🚀 Running setup script..."
        cd 01_foundations
        ./setup_conda_environment.sh
        cd ..
    elif [[ -f "setup_conda_environment.sh" ]]; then
        echo "🚀 Running setup script..."
        ./setup_conda_environment.sh
    else
        echo "🔨 Creating basic MLU environment..."
        conda create -n mlu python=3.9 jupyter -y
        echo "✅ Basic environment created. For full setup, run the setup scripts later."
    fi
    echo ""
fi

# Activate MLU environment
echo -e "${BLUE}🐍 Activating MLU environment...${NC}"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate mlu

# Verify activation
if [[ "$CONDA_DEFAULT_ENV" != "mlu" ]]; then
    echo "❌ Failed to activate MLU environment"
    echo "💡 Try running: conda activate mlu"
    exit 1
fi

# Quick package check
echo -e "${GREEN}✅ Environment activated: $CONDA_DEFAULT_ENV${NC}"
python -c "import sys; print(f'Python: {sys.version.split()[0]}')"

echo -e "${GREEN}✅ MLU environment activated!${NC}"
echo ""

# Start JupyterLab without password
echo -e "${PURPLE}📓 Starting JupyterLab...${NC}"
echo "🌐 Access at: http://localhost:8888 (no password required!)"
echo "📊 Navigate to: 01_foundations/environment_compatibility_check.ipynb"
echo ""

# Start JupyterLab with no token/password
jupyter lab --no-browser --ip=localhost --port=8888 --ServerApp.token='' --ServerApp.password=''