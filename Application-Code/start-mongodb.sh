#!/bin/bash

echo "🐳 Starting MongoDB for local development..."

# Check if MongoDB container is already running
if docker ps | grep -q mongodb; then
    echo "✅ MongoDB is already running!"
    echo "📊 MongoDB is accessible at: mongodb://localhost:27017"
    echo "🗄️ Database: todo"
else
    # Check if MongoDB container exists but is stopped
    if docker ps -a | grep -q mongodb; then
        echo "🔄 Starting existing MongoDB container..."
        docker start mongodb
    else
        echo "🚀 Creating and starting new MongoDB container..."
        docker run -d \
            --name mongodb \
            -p 27017:27017 \
            -e MONGO_INITDB_DATABASE=todo \
            mongo:4.4.6
    fi
    
    echo "✅ MongoDB started successfully!"
    echo "📊 MongoDB is accessible at: mongodb://localhost:27017"
    echo "🗄️ Database: todo"
fi

echo ""
echo "💡 To stop MongoDB: docker stop mongodb"
echo "💡 To remove MongoDB: docker rm mongodb" 