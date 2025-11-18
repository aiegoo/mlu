#!/bin/bash

# Conda Environment Setup for MLU
# Works with existing Anaconda installations

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_header() { echo -e "${BLUE}[SETUP]${NC} $1"; }

print_header "Setting up MLU Conda Environment"

# Environment name
ENV_NAME="mlu"

# Check if environment exists
if conda env list | grep -q "^$ENV_NAME "; then
    print_status "Environment '$ENV_NAME' already exists"
    echo "Options:"
    echo "1) Use existing environment"
    echo "2) Update existing environment"
    echo "3) Remove and recreate"
    read -p "Choose option (1-3) [1]: " choice
    
    case ${choice:-1} in
        2)
            print_status "Updating existing environment..."
            conda activate $ENV_NAME
            conda env update -f environments/environment.yml
            ;;
        3)
            print_status "Removing existing environment..."
            conda env remove -n $ENV_NAME -y
            print_status "Creating new environment..."
            conda env create -f environments/environment.yml
            ;;
        *)
            print_status "Using existing environment"
            conda activate $ENV_NAME
            ;;
    esac
else
    print_status "Creating new conda environment..."
    if [ -f "environments/environment.yml" ]; then
        conda env create -f environments/environment.yml
    else
        conda create -n $ENV_NAME python=3.10 -y
        conda activate $ENV_NAME
        # Install packages manually
        conda install pytorch torchvision torchaudio -c pytorch -y
        pip install d2l jupyter jupyterlab matplotlib seaborn pandas scikit-learn
    fi
fi

# Activate environment
print_status "Activating environment..."
eval "$(conda shell.bash hook)"
conda activate $ENV_NAME

# Verify installation
print_status "Verifying installation..."
python -c "
import torch
import d2l
print('✅ PyTorch version:', torch.__version__)
print('✅ d2l version:', d2l.__version__)
print('✅ CUDA available:', torch.cuda.is_available())
"

# Setup Jupyter kernel
print_status "Setting up Jupyter kernel..."
python -m ipykernel install --user --name=$ENV_NAME --display-name="MLU Deep Learning"

# Create activation script
print_status "Creating activation script..."
cat > activate_mlu_conda.sh << 'EOF'
#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate mlu
echo "🧠 MLU Conda environment activated!"
echo "📚 Quick commands:"
echo "   jupyter lab"
echo "   python"
echo "   cd 01_foundations && jupyter lab"
EOF
chmod +x activate_mlu_conda.sh

print_status "✅ Conda environment setup complete!"
echo "🚀 To activate: source activate_mlu_conda.sh"