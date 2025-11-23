@echo off
echo 🐳 Starting D2L.ai Docker Environment...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Check for environment file
if not exist "D:\repos\tonylee\goorm\ai-track\.env" (
    echo ⚠️  Environment file not found at D:\repos\tonylee\goorm\ai-track\.env
    echo 📝 Please copy .env.example to that location and add your credentials
    echo 💡 You can still start the environment, but API services may not work
    echo.
    set /p "continue=Continue anyway? (y/N): "
    if /i not "%continue%"=="y" exit /b 1
) else (
    echo ✅ Environment file found
)

REM Check for NVIDIA GPU
nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    echo 🔥 NVIDIA GPU detected
    nvidia-smi --query-gpu=name --format=csv,noheader
) else (
    echo ⚠️  NVIDIA GPU not detected - running in CPU mode
)

echo.
echo 🌏 Language Support: Korean (한국어) + English
echo 📝 Encoding: UTF-8
echo.

REM Build and start the container
echo 🏗️ Building D2L.ai learning environment...
docker-compose up --build -d

echo.
echo ✅ D2L.ai Environment Started Successfully!
echo.
echo 📍 Access Points:
echo 🔗 JupyterLab: http://localhost:8888
echo 🏠 Password: None required
echo.
echo 📂 Directory Structure:
echo ├── /workspace/mlu (your current MLU project)
echo ├── /workspace/ai-track/ (mapped to D:/repos/tonylee/goorm/ai-track/)
echo │   ├── d2l-official/ (official d2l.ai notebooks from GitHub)
echo │   ├── projects/ (your AI projects)
echo │   ├── datasets/ (shared datasets)
echo │   ├── experiments/ (experiment tracking)
echo │   ├── models/ (saved models)
echo │   └── .env (your API credentials - Korean NLP, OpenAI, HuggingFace, etc.)
echo.
echo 🎯 Quick Start:
echo 1. Open http://localhost:8888 in your browser
echo 2. Navigate to 'ai-track/d2l-official/d2l-en' for official notebooks
echo 3. Navigate to 'mlu' for your current project
echo 4. Create new projects in 'ai-track/projects'
echo.
echo 🛠️ Useful Commands:
echo • docker-compose logs -f    # View container logs
echo • docker-compose stop       # Stop the environment
echo • docker-compose down       # Stop and remove containers
echo.

REM Wait a moment for the container to fully start
timeout /t 3 >nul

REM Check if the service is running
docker-compose ps | find "Up" >nul
if %errorlevel% equ 0 (
    echo 🚀 Container is running! Opening JupyterLab...
    start http://localhost:8888
) else (
    echo ❌ Container failed to start. Check logs with: docker-compose logs
)

pause