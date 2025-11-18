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

# Check if MLU environment exists
if ! conda env list | grep -q "^mlu "; then
    echo "❌ Error: MLU environment not found."
    echo "💡 Run setup_conda_environment.sh first to create the environment."
    exit 1
fi

# Activate MLU environment
echo -e "${BLUE}🐍 Activating MLU environment...${NC}"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate mlu

# Verify activation
if [[ "$CONDA_DEFAULT_ENV" != "mlu" ]]; then
    echo "❌ Failed to activate MLU environment"
    exit 1
fi

echo -e "${GREEN}✅ MLU environment activated!${NC}"
echo ""

# Start Jupyter without password
echo -e "${PURPLE}📓 Starting Jupyter Notebook...${NC}"
echo "🌐 Access at: http://localhost:8888 (no password required!)"
echo "📊 To start with compatibility check, use: jupyter notebook environment_compatibility_check.ipynb"
echo ""

# Start Jupyter with no token/password
jupyter notebook --no-browser --ip=localhost --port=8888