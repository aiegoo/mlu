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

REM Check if MLU environment exists, create if missing
conda env list | findstr "^mlu " >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 🔧 MLU environment not found. Creating it now...
    echo.
    
    REM Check if we have setup script
    if exist "01_foundations\setup_conda_environment.sh" (
        echo 🚀 Setup script found. Please run: 01_foundations/setup_conda_environment.sh
        echo 💡 Or use Git Bash to run the full setup automatically.
    ) else (
        echo 🔨 Creating basic MLU environment...
        conda create -n mlu python=3.9 jupyter -y
        if %ERRORLEVEL% EQU 0 (
            echo ✅ Basic environment created. For full setup, run the setup scripts later.
        ) else (
            echo ❌ Failed to create environment. Please check your conda installation.
            pause
            exit /b 1
        )
    )
    echo.
)

REM Activate MLU environment
echo 🐍 Activating MLU environment...
call conda activate mlu

REM Quick verification
if "%CONDA_DEFAULT_ENV%"=="mlu" (
    echo ✅ MLU environment activated: %CONDA_DEFAULT_ENV%
    python -c "import sys; print('Python:', sys.version.split()[0])"
) else (
    echo ⚠️ Environment activation may have issues
    echo Current environment: %CONDA_DEFAULT_ENV%
)
echo.

REM Start JupyterLab without password
echo 📓 Starting JupyterLab...
echo 🌐 Access at: http://localhost:8888 (no password required!)
echo 📊 Navigate to: 01_foundations/environment_compatibility_check.ipynb
echo.

REM Start JupyterLab with no token/password
jupyter lab --no-browser --ip=localhost --port=8888 --ServerApp.token='' --ServerApp.password=''