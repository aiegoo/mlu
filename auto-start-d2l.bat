@echo off
REM Auto-start D2L.ai Docker Environment for Windows
REM Add this to Windows startup or run manually

echo 🐳 Checking Docker Desktop status...

REM Check if Docker Desktop is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo 🚀 Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    REM Wait for Docker to start
    echo ⏳ Waiting for Docker Desktop to start...
    :wait_for_docker
    timeout /t 5 >nul
    docker info >nul 2>&1
    if %errorlevel% neq 0 goto wait_for_docker
    
    echo ✅ Docker Desktop is ready!
)

REM Navigate to MLU directory
cd /d "d:\repos\tonylee\goorm\mlu"

REM Check if D2L container is already running
docker-compose ps | find "Up" >nul
if %errorlevel% equ 0 (
    echo ✅ D2L.ai environment already running at http://localhost:8888
    goto end
)

REM Start the D2L environment
echo 🚀 Auto-starting D2L.ai learning environment...
docker-compose up -d

if %errorlevel% equ 0 (
    echo ✅ D2L.ai environment started successfully!
    echo 🔗 Access JupyterLab at: http://localhost:8888
    
    REM Optional: Open in browser automatically
    REM Uncomment the line below if you want auto-browser opening
    REM start http://localhost:8888
) else (
    echo ❌ Failed to start D2L.ai environment
    pause
    exit /b 1
)

:end
echo 🎯 D2L.ai environment is ready for learning!
pause