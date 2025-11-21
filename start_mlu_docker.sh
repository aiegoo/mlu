#!/bin/bash

echo "🐳 Starting MLU Docker Environment..."

# Check if Docker is running
if ! docker ps &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Load environment
if [ -f .env.mlu ]; then
    export $(grep -v '^#' .env.mlu | xargs)
fi

# Start services
docker-compose -f docker-compose.mlu.yml up -d

echo "✅ MLU Docker environment started!"
echo ""
echo "🚀 Access Jupyter Lab:"
echo "   URL: http://localhost:8888"
echo "   Token: ${JUPYTER_TOKEN:-mlu2025}"
echo ""
echo "📚 Quick commands:"
echo "   docker-compose -f docker-compose.mlu.yml logs -f    # View logs"
echo "   docker-compose -f docker-compose.mlu.yml down       # Stop services"
echo "   docker exec -it mlu-deep-learning bash              # Shell access"
