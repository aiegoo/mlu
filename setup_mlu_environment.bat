@echo off
REM MLU Environment Verification and Quick Fix (Windows)
REM This script checks if MLU environment exists and creates it if missing

echo 🔍 MLU Environment Check & Quick Setup
echo =======================================
echo.

REM Check conda availability
where conda >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Conda not found!
    echo 📦 Please install Anaconda or Miniconda:
    echo    https://www.anaconda.com/products/distribution
    pause
    exit /b 1
)

echo ✅ Conda found
conda --version

REM Check if MLU environment exists
conda env list | findstr "^mlu " >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ MLU environment exists
    
    REM Activate and test
    call conda activate mlu
    
    if "%CONDA_DEFAULT_ENV%"=="mlu" (
        echo ✅ Environment activation successful
        echo Current environment: %CONDA_DEFAULT_ENV%
        
        REM Quick package test
        echo 📦 Testing core packages...
        python -c "packages = ['numpy', 'pandas', 'matplotlib', 'jupyter']; missing = []; [missing.append(pkg) if not __import__(pkg) else print(f'✅ {pkg}') for pkg in packages]; print(f'\n⚠️ Missing: {missing}' if missing else '\n🎉 All core packages available!')" 2>nul
        if %ERRORLEVEL% NEQ 0 (
            echo ⚠️ Some packages may be missing. Consider running full setup script.
        )
    ) else (
        echo ❌ Failed to activate MLU environment
        echo Current environment: %CONDA_DEFAULT_ENV%
    )
    
) else (
    echo ⚠️ MLU environment not found
    echo 🔨 Creating MLU environment with essential packages...
    echo.
    
    REM Create environment with basic packages
    conda create -n mlu python=3.9 -y
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to create environment
        pause
        exit /b 1
    )
    
    call conda activate mlu
    
    REM Install essential packages
    echo 📦 Installing essential packages...
    conda install -y numpy pandas matplotlib jupyter ipywidgets
    
    REM Install PyTorch (CPU version for safety)
    echo 🔥 Installing PyTorch...
    conda install -y pytorch cpuonly -c pytorch
    
    REM Install additional packages via pip
    pip install d2l plotly tqdm
    
    echo.
    echo ✅ MLU environment created and configured!
)

echo.
echo 🚀 Quick Start Commands:
echo • Activate environment: conda activate mlu
echo • Start Jupyter: jupyter notebook
echo • Run quick start: start_jupyter.bat
echo.
echo 💡 Pro Tip: Your environment is ready for deep learning!
echo.
pause