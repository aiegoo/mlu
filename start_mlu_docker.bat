@echo off
echo 🐳 Starting MLU Docker Environment...

REM Check if Docker is running
docker ps >nul 2>nul
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker first.
    exit /b 1
)

REM Start services
docker-compose -f docker-compose.mlu.yml up -d

echo ✅ MLU Docker environment started!
echo.
echo 🚀 Access Jupyter Lab:
echo    URL: http://localhost:8888
echo    Token: [set in .env.mlu]
echo.
echo 📚 Quick commands:
echo    docker-compose -f docker-compose.mlu.yml logs -f    # View logs
echo    docker-compose -f docker-compose.mlu.yml down       # Stop services
echo    docker exec -it mlu-deep-learning bash              # Shell access
