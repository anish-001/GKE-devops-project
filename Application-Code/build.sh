#!/bin/bash

# Build script for the application
echo "🚀 Building the application..."

# Build backend
echo "📦 Building backend..."
cd backend
docker build -t task-app-backend .
cd ..

# Build frontend
echo "📦 Building frontend..."
cd frontend
docker build -t task-app-frontend .
cd ..

echo "✅ Build completed!"
echo ""
echo "To run the application:"
echo "docker run -p 3500:3500 task-app-backend"
echo "docker run -p 3000:3000 task-app-frontend" 