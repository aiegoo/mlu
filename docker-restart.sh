#!/bin/bash

echo "🔄 Restarting D2L.ai Docker Environment..."

# Stop the current container
docker-compose down

echo "🏗️ Rebuilding and starting..."
docker-compose up --build -d

echo ""
echo "✅ D2L.ai Environment Restarted!"
echo "🔗 Access: http://localhost:8888"