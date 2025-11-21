#!/bin/bash
echo "🛑 Stopping MLU Docker Environment..."
docker-compose -f docker-compose.mlu.yml down
echo "✅ MLU Docker environment stopped!"
