#!/bin/bash
# Auto-start D2L.ai Docker Environment
# Add this to your shell startup script (.bashrc, .zshrc, etc.)

# Function to check and start D2L environment
start_d2l_auto() {
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        echo "🐳 Docker not running - please start Docker Desktop first"
        return 1
    fi
    
    # Check if D2L container is already running
    if docker-compose ps | grep -q "Up"; then
        echo "✅ D2L.ai environment already running at http://localhost:8888"
        return 0
    fi
    
    # Start the environment
    echo "🚀 Auto-starting D2L.ai learning environment..."
    cd "$(dirname "$0")"
    docker-compose up -d
    
    if [ $? -eq 0 ]; then
        echo "✅ D2L.ai environment started successfully!"
        echo "🔗 Access JupyterLab at: http://localhost:8888"
        
        # Optional: Open in browser automatically
        # Uncomment the line below if you want auto-browser opening
        # start http://localhost:8888 2>/dev/null || open http://localhost:8888 2>/dev/null || xdg-open http://localhost:8888 2>/dev/null
    else
        echo "❌ Failed to start D2L.ai environment"
        return 1
    fi
}

# Auto-start if Docker is available (uncomment to enable)
# start_d2l_auto