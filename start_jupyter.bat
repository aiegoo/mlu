@echo off
REM MLU Quick Start - Launch Jupyter without password (Windows)
REM This script activates the MLU environment and starts Jupyter

echo 🚀 MLU Quick Start - Jupyter Launcher
echo =====================================
echo.

REM Check if conda is available
where conda >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error: Conda not found. Please install Anaconda first.
    pause
    exit /b 1
)

REM Check if MLU environment exists
conda env list | findstr "^mlu " >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error: MLU environment not found.
    echo 💡 Run setup_conda_environment.sh first to create the environment.
    pause
    exit /b 1
)

REM Activate MLU environment
echo 🐍 Activating MLU environment...
call conda activate mlu

echo ✅ MLU environment activated!
echo.

REM Start Jupyter without password
echo 📓 Starting Jupyter Notebook...
echo 🌐 Access at: http://localhost:8888 (no password required!)
echo 📊 To start with compatibility check, use: jupyter notebook environment_compatibility_check.ipynb
echo.

REM Start Jupyter with no token/password
jupyter notebook --no-browser --ip=localhost --port=8888