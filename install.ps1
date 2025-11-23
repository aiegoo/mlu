# Deep Learning Mastery (MLU) Installation Script for Windows PowerShell
# This script automates the setup of your deep learning environment on Windows

# Enable strict error handling
$ErrorActionPreference = "Stop"

# Function to print colored output
function Write-Status { 
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green 
}

function Write-Warning-Custom { 
    param($Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow 
}

function Write-Error-Custom { 
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red 
}

function Write-Header { 
    param($Message)
    Write-Host "[SETUP] $Message" -ForegroundColor Blue 
}

# Welcome message
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "🧠 Deep Learning Mastery Setup 🧠" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Status "Starting automated setup for your deep learning environment..."
Write-Host ""

# Check if Python is installed
Write-Header "Checking Python installation..."
$pythonCmd = $null
$pythonVersion = $null

try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $pythonCmd = "python"
        Write-Status "Found $pythonVersion"
    }
} catch {
    try {
        $pythonVersion = python3 --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonCmd = "python3"
            Write-Status "Found $pythonVersion"
        }
    } catch {
        Write-Error-Custom "Python is not installed or not in PATH."
        Write-Host "Please install Python 3.8+ from: https://www.python.org/downloads/"
        Write-Host "Make sure to check 'Add Python to PATH' during installation."
        exit 1
    }
}

if (-not $pythonCmd) {
    Write-Error-Custom "Python is not installed or not accessible."
    Write-Host "Please install Python 3.8+ from: https://www.python.org/downloads/"
    exit 1
}

# Check Python version
$versionCheck = & $pythonCmd -c "
import sys
major, minor = sys.version_info[:2]
required_major, required_minor = 3, 8
if (major, minor) >= (required_major, required_minor):
    print('OK')
    print(f'{major}.{minor}')
else:
    print('OLD')
    print(f'{major}.{minor}')
"

$versionStatus = $versionCheck[0]
$currentVersion = $versionCheck[1]

if ($versionStatus -eq "OK") {
    Write-Status "Python version $currentVersion is compatible"
} else {
    Write-Error-Custom "Python version $currentVersion is too old. Please upgrade to Python 3.8+"
    exit 1
}

# Detect package manager preference
Write-Header "Detecting package management preference..."
$installMethod = ""
$condaAvailable = $false

try {
    $condaVersion = conda --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $condaAvailable = $true
    }
} catch {
    $condaAvailable = $false
}

if ($condaAvailable) {
    Write-Host "1) Conda (Anaconda/Miniconda) - Recommended"
    Write-Host "2) pip (Python package installer)"
    Write-Host "3) Auto-detect (use conda if available)"
    $choice = Read-Host "Choose installation method (1-3) [3]"
    
    switch ($choice) {
        "1" { $installMethod = "conda" }
        "2" { $installMethod = "pip" }
        "3" { $installMethod = "conda" }
        "" { $installMethod = "conda" }
        default { 
            Write-Warning-Custom "Invalid choice, using conda"
            $installMethod = "conda" 
        }
    }
} else {
    Write-Status "Conda not found, using pip"
    $installMethod = "pip"
}

# GPU Detection
Write-Header "Checking for GPU support..."
$gpuAvailable = $false
$useGpu = $false

try {
    $gpuInfo = nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Status "NVIDIA GPU detected: $($gpuInfo[0])"
        $gpuAvailable = $true
        
        $gpuChoice = Read-Host "Do you want to install GPU-accelerated PyTorch? (y/n) [y]"
        if ($gpuChoice -eq "y" -or $gpuChoice -eq "Y" -or $gpuChoice -eq "") {
            $useGpu = $true
            Write-Status "Will install CUDA-enabled PyTorch"
        } else {
            $useGpu = $false
            Write-Status "Will install CPU-only PyTorch"
        }
    }
} catch {
    Write-Status "No NVIDIA GPU detected, installing CPU-only version"
    $useGpu = $false
}

# Create virtual environment
Write-Header "Setting up virtual environment..."
$envName = "mlu"

if ($installMethod -eq "conda") {
    Write-Status "Creating conda environment: $envName"
    
    # Check if environment already exists
    $envExists = $false
    try {
        $envList = conda env list 2>&1
        if ($envList -match "^$envName\s") {
            $envExists = $true
        }
    } catch {
        $envExists = $false
    }
    
    if ($envExists) {
        Write-Warning-Custom "Environment '$envName' already exists"
        $recreateChoice = Read-Host "Do you want to remove and recreate it? (y/n) [n]"
        if ($recreateChoice -eq "y" -or $recreateChoice -eq "Y") {
            Write-Status "Removing existing environment..."
            conda env remove -n $envName -y
            $envExists = $false
        }
    }
    
    # Create environment
    if (-not $envExists) {
        if (Test-Path "environments\environment.yml") {
            Write-Status "Creating environment from environment.yml..."
            conda env create -f environments\environment.yml
        } else {
            Write-Status "Creating new conda environment..."
            conda create -n $envName python=3.10 -y
        }
    }
    
    Write-Status "Activating conda environment..."
    conda activate $envName
    
} else {
    # pip installation with virtual environment
    Write-Status "Creating Python virtual environment: ${envName}_env"
    
    if (Test-Path "${envName}_env") {
        Write-Warning-Custom "Virtual environment already exists"
        $recreateChoice = Read-Host "Do you want to remove and recreate it? (y/n) [n]"
        if ($recreateChoice -eq "y" -or $recreateChoice -eq "Y") {
            Write-Status "Removing existing virtual environment..."
            Remove-Item -Recurse -Force "${envName}_env"
        }
    }
    
    if (-not (Test-Path "${envName}_env")) {
        & $pythonCmd -m venv "${envName}_env"
    }
    
    Write-Status "Activating virtual environment..."
    & "${envName}_env\Scripts\Activate.ps1"
}

# Upgrade pip
Write-Header "Upgrading pip..."
& $pythonCmd -m pip install --upgrade pip

# Install PyTorch
Write-Header "Installing PyTorch..."
if ($useGpu) {
    if ($installMethod -eq "conda") {
        Write-Status "Installing GPU-enabled PyTorch with conda..."
        conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y
    } else {
        Write-Status "Installing GPU-enabled PyTorch with pip..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    }
} else {
    if ($installMethod -eq "conda") {
        Write-Status "Installing CPU-only PyTorch with conda..."
        conda install pytorch torchvision torchaudio cpuonly -c pytorch -y
    } else {
        Write-Status "Installing CPU-only PyTorch with pip..."
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    }
}

# Install other packages
Write-Header "Installing additional packages..."
if (Test-Path "requirements.txt") {
    Write-Status "Installing from requirements.txt..."
    pip install -r requirements.txt
} else {
    Write-Status "Installing essential packages manually..."
    pip install d2l jupyter jupyterlab matplotlib seaborn pandas scikit-learn numpy scipy tqdm plotly
}

# Install development tools
Write-Header "Installing development tools..."
pip install black flake8 pytest ipywidgets

# Setup Jupyter kernel
Write-Header "Setting up Jupyter kernel..."
& $pythonCmd -m ipykernel install --user --name=$envName --display-name="Deep Learning (MLU)"

# Verify installation
Write-Header "Verifying installation..."
& $pythonCmd -c @"
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
"@

# Create activation scripts
Write-Header "Creating activation scripts..."

# PowerShell activation script
@"
# Activation script for Deep Learning Mastery environment (PowerShell)

if (Get-Command conda -ErrorAction SilentlyContinue) {
    try {
        `$envList = conda env list 2>`$null
        if (`$envList -match "^mlu\s") {
            Write-Host "🧠 Activating conda environment: mlu" -ForegroundColor Green
            conda activate mlu
            `$activated = `$true
        } else {
            `$activated = `$false
        }
    } catch {
        `$activated = `$false
    }
} else {
    `$activated = `$false
}

if (-not `$activated -and (Test-Path "mlu_env\Scripts\Activate.ps1")) {
    Write-Host "🧠 Activating virtual environment: mlu_env" -ForegroundColor Green
    & "mlu_env\Scripts\Activate.ps1"
    `$activated = `$true
}

if (-not `$activated) {
    Write-Host "❌ No environment found. Please run install.ps1 first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Deep Learning Mastery environment activated!" -ForegroundColor Green
Write-Host "📚 Quick commands:" -ForegroundColor Cyan
Write-Host "   jupyter lab                    # Start Jupyter Lab"
Write-Host "   jupyter notebook              # Start Jupyter Notebook"
Write-Host "   python                        # Start Python REPL"
Write-Host "   cd 01_foundations; jupyter lab  # Start with foundations"
"@ | Out-File -FilePath "activate_mlu.ps1" -Encoding UTF8

# Create quick start script
@"
# Quick start script - launches Jupyter Lab with the first notebook (PowerShell)

& ".\activate_mlu.ps1"

Write-Host "🚀 Launching Deep Learning Mastery..." -ForegroundColor Green
Write-Host "📖 Opening the foundational notebook..." -ForegroundColor Green

Set-Location 01_foundations
jupyter lab week1_deep_learning_mastery.ipynb
"@ | Out-File -FilePath "quick_start.ps1" -Encoding UTF8

# Success message
Write-Host ""
Write-Host "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉" -ForegroundColor Green
Write-Host "✅ Deep Learning Mastery Setup Complete!" -ForegroundColor Green
Write-Host "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉" -ForegroundColor Green
Write-Host ""
Write-Status "Environment: $envName"
Write-Status "Installation method: $installMethod"
Write-Status "GPU support: $useGpu"
Write-Host ""
Write-Host "🚀 Quick Start Commands:" -ForegroundColor Cyan
Write-Host "   .\activate_mlu.ps1            # Activate environment"
Write-Host "   .\quick_start.ps1             # Launch Jupyter with first notebook"
Write-Host ""
Write-Host "📚 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Run: .\quick_start.ps1"
Write-Host "   2. Open: 01_foundations\week1_deep_learning_mastery.ipynb"
Write-Host "   3. Follow: QUICK_START.md guide"
Write-Host "   4. Read: resources\d2l_study_guide.md"
Write-Host ""
Write-Host "🤝 Need Help?" -ForegroundColor Cyan
Write-Host "   - Read: environments\setup.md"
Write-Host "   - Visit: https://d2l.ai/"
Write-Host "   - Join: https://discuss.d2l.ai/"
Write-Host ""
Write-Host "Happy Learning! 🧠✨" -ForegroundColor Green