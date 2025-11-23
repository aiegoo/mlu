#!/bin/bash
# MLU Environment Verification and Quick Fix
# This script checks if MLU environment exists and creates it if missing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🔍 MLU Environment Check & Quick Setup${NC}"
echo "======================================="
echo ""

# Check conda availability
if ! command -v conda &> /dev/null; then
    echo -e "${RED}❌ Conda not found!${NC}"
    echo "📦 Please install Anaconda or Miniconda:"
    echo "   https://www.anaconda.com/products/distribution"
    exit 1
fi

echo -e "${GREEN}✅ Conda found:${NC} $(conda --version)"

# Check if MLU environment exists
if conda env list | grep -q "^mlu "; then
    echo -e "${GREEN}✅ MLU environment exists${NC}"
    
    # Activate and test
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate mlu
    
    if [[ "$CONDA_DEFAULT_ENV" == "mlu" ]]; then
        echo -e "${GREEN}✅ Environment activation successful${NC}"
        
        # Quick package test
        echo "📦 Testing core packages..."
        python -c "
packages = ['numpy', 'pandas', 'matplotlib', 'jupyter']
missing = []
for pkg in packages:
    try:
        __import__(pkg)
        print(f'✅ {pkg}')
    except ImportError:
        print(f'❌ {pkg}')
        missing.append(pkg)

if missing:
    print(f'\\n⚠️ Missing packages: {missing}')
    print('💡 Run: conda install ' + ' '.join(missing))
else:
    print('\\n🎉 All core packages available!')
"
    else
        echo -e "${RED}❌ Failed to activate MLU environment${NC}"
    fi
    
else
    echo -e "${YELLOW}⚠️ MLU environment not found${NC}"
    echo "🔨 Creating MLU environment with essential packages..."
    echo ""
    
    # Create environment with basic packages
    conda create -n mlu python=3.9 -y
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate mlu
    
    # Install essential packages
    echo "📦 Installing essential packages..."
    conda install -y numpy pandas matplotlib jupyter ipywidgets
    
    # Install PyTorch (CPU version for safety)
    echo "🔥 Installing PyTorch..."
    conda install -y pytorch cpuonly -c pytorch
    
    # Install additional packages via pip
    pip install d2l plotly tqdm
    
    echo ""
    echo -e "${GREEN}✅ MLU environment created and configured!${NC}"
fi

echo ""
echo -e "${BLUE}🚀 Quick Start Commands:${NC}"
echo "• Activate environment: conda activate mlu"
echo "• Start Jupyter: jupyter notebook"
echo "• Run quick start: ./start_jupyter.sh"
echo ""
echo -e "${PURPLE}💡 Pro Tip:${NC} Your environment is ready for deep learning!"