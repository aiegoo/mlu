# Environment Setup Guide

This guide will help you set up your development environment for deep learning with d2l.ai and other frameworks.

## 🚀 Quick Automated Setup (Recommended)

### Option 1: Run Installation Script

**Linux/Mac/WSL:**
```bash
./install.sh
```

**Windows (PowerShell):**
```powershell
.\install.ps1
```

The installation scripts will:
- ✅ Automatically detect your system
- ✅ Install the correct PyTorch version (CPU/GPU)
- ✅ Set up virtual environment (conda or pip)
- ✅ Install all required packages
- ✅ Create activation shortcuts
- ✅ Verify everything works

### Option 2: One-Command Setup

If you prefer conda and have it installed:
```bash
conda env create -f environments/environment.yml
conda activate mlu
```

---

## 📋 Manual Setup (If Scripts Don't Work)

## Prerequisites

- Python 3.8+ (recommended: Python 3.9 or 3.10)
- Git
- A good code editor (VS Code, PyCharm, etc.)
- Minimum 8GB RAM (16GB+ recommended)
- GPU optional but recommended for larger models

## Setup Methods

### Method 1: Conda Environment (Recommended)

1. **Install Anaconda or Miniconda**
   - Download from [anaconda.com](https://www.anaconda.com/) or [miniconda](https://docs.conda.io/en/latest/miniconda.html)

2. **Create the environment**
   ```bash
   # Create environment with Python 3.10
   conda create -n mlu python=3.10 -y
   
   # Activate the environment
   conda activate mlu
   
   # Install PyTorch (CPU version)
   conda install pytorch torchvision torchaudio cpuonly -c pytorch -y
   
   # Install d2l package
   pip install d2l
   
   # Install additional packages
   pip install -r requirements.txt
   ```

3. **For GPU support (if available)**
   ```bash
   # Check CUDA version
   nvidia-smi
   
   # Install PyTorch with CUDA (replace cu118 with your CUDA version)
   conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y
   ```

### Method 2: Virtual Environment

1. **Create virtual environment**
   ```bash
   # Create virtual environment
   python -m venv mlu_env
   
   # Activate (Windows)
   mlu_env\Scripts\activate
   
   # Activate (Linux/Mac)
   source mlu_env/bin/activate
   
   # Install packages
   pip install -r requirements.txt
   ```

### Method 3: Google Colab (No setup required)

- Simply open any notebook in Google Colab
- All d2l.ai notebooks are compatible with Colab
- Free GPU access available

## Verification

Run this Python script to verify your installation:

```python
import torch
import d2l
import numpy as np
import matplotlib.pyplot as plt

print(f"PyTorch version: {torch.__version__}")
print(f"d2l version: {d2l.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")

if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU count: {torch.cuda.device_count()}")
    print(f"GPU name: {torch.cuda.get_device_name(0)}")

# Test basic functionality
x = torch.randn(3, 3)
print(f"\nTest tensor:\n{x}")
print("Environment setup successful! 🎉")
```

## Framework Choices

### d2l.ai supports multiple frameworks:

1. **PyTorch** (Recommended for beginners)
   - Most popular in research
   - Dynamic computation graphs
   - Great debugging experience

2. **TensorFlow/Keras**
   - Popular in industry
   - Great for production deployment
   - Mature ecosystem

3. **JAX**
   - Functional programming approach
   - Excellent for research
   - Advanced users

## IDE Setup

### VS Code Extensions (Recommended)
- Python
- Jupyter
- Python Docstring Generator
- GitLens
- Material Theme (optional)

### Jupyter Setup
```bash
# Install Jupyter
pip install jupyter jupyterlab

# Install kernel
python -m ipykernel install --user --name=mlu

# Start Jupyter Lab
jupyter lab
```

## Troubleshooting

### Common Issues

1. **Import Error: No module named 'd2l'**
   - Solution: `pip install d2l`

2. **CUDA out of memory**
   - Reduce batch size
   - Use gradient checkpointing
   - Use smaller models

3. **Slow training**
   - Enable GPU if available
   - Use data loading optimizations
   - Consider cloud computing

### Getting Help

- d2l.ai Discussion Forum: [discuss.d2l.ai](https://discuss.d2l.ai/)
- PyTorch Forums: [discuss.pytorch.org](https://discuss.pytorch.org/)
- Stack Overflow: Use tags `deep-learning`, `pytorch`, `d2l`

## Next Steps

1. ✅ Complete environment setup
2. 📖 Start with `01_foundations/week1_math_review.ipynb`
3. 🔄 Follow the learning roadmap in the main README
4. 💬 Join the d2l.ai community discussions

Happy learning! 🚀