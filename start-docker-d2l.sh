#!/bin/bash

echo "🐳 Starting D2L.ai Docker Environment..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Check for environment file
if [ ! -f "D:/repos/tonylee/goorm/ai-track/.env" ]; then
    echo "⚠️  Environment file not found at D:/repos/tonylee/goorm/ai-track/.env"
    echo "📝 Please copy .env.example to D:/repos/tonylee/goorm/ai-track/.env and add your credentials"
    echo "💡 You can still start the environment, but API services may not work"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Environment file found"
fi

# Check for NVIDIA GPU support
if command -v nvidia-smi &> /dev/null; then
    echo "🔥 NVIDIA GPU detected:"
    nvidia-smi --query-gpu=name,memory.total,cuda_version --format=csv,noheader,nounits
else
    echo "⚠️  NVIDIA GPU not detected - running in CPU mode"
fi

echo ""
echo "🌏 Language Support: Korean (한국어) + English"
echo "📝 Encoding: UTF-8"
echo ""

# Build and start the container
echo "🏗️ Building D2L.ai learning environment..."
docker-compose up --build -d

echo ""
echo "✅ D2L.ai Environment Started Successfully!"
echo ""
echo "📍 Access Points:"
echo "🔗 JupyterLab: http://localhost:8888"
echo "🏠 Password: None required"
echo ""
echo "📂 Directory Structure:"
echo "├── /workspace/mlu (your current MLU project)"
echo "├── /workspace/ai-track/ (mapped to D:/repos/tonylee/goorm/ai-track/)"
echo "│   ├── d2l-official/ (official d2l.ai notebooks from GitHub)"
echo "│   ├── projects/ (your AI projects)"
echo "│   ├── datasets/ (shared datasets)"
echo "│   ├── experiments/ (experiment tracking)"
echo "│   ├── models/ (saved models)"
echo "│   └── .env (your API credentials - Korean NLP, OpenAI, HuggingFace, etc.)"
echo ""
echo "🎯 Quick Start:"
echo "1. Open http://localhost:8888 in your browser"
echo "2. Navigate to 'ai-track/d2l-official/d2l-en' for official notebooks"
echo "3. Navigate to 'mlu' for your current project"
echo "4. Create new projects in 'ai-track/projects'"
echo "5. Use Korean language processing with konlpy, soynlp, kiwipiepy"
echo "6. Access OpenAI, HuggingFace APIs with your credentials"
echo ""
echo "🛠️ Useful Commands:"
echo "• docker-compose logs -f    # View container logs"
echo "• docker-compose stop       # Stop the environment"
echo "• docker-compose down       # Stop and remove containers"
echo "• ./docker-restart.sh       # Restart the environment"
echo ""

# Wait a moment for the container to fully start
sleep 3

# Check if the service is running
if docker-compose ps | grep -q "Up"; then
    echo "🚀 Container is running! Opening JupyterLab..."
    # Try to open in browser (works on Windows with WSL)
    if command -v cmd.exe &> /dev/null; then
        cmd.exe /c start http://localhost:8888
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8888
    else
        echo "💡 Please manually open http://localhost:8888 in your browser"
    fi
else
    echo "❌ Container failed to start. Check logs with: docker-compose logs"
fi