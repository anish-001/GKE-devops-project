#!/bin/bash

echo "🔍 Troubleshooting GKE Application..."

echo ""
echo "📊 Pod Status:"
kubectl get pods -n three-tier

echo ""
echo "🌐 Services:"
kubectl get services -n three-tier

echo ""
echo "🔗 Backend Service Details:"
kubectl describe service api -n three-tier

echo ""
echo "🗄️ MongoDB Service Details:"
kubectl describe service mongodb-svc -n three-tier

echo ""
echo "📝 Backend Logs:"
kubectl logs deployment/api -n three-tier --tail=20

echo ""
echo "📝 Frontend Logs:"
kubectl logs deployment/frontend -n three-tier --tail=20

echo ""
echo "📝 MongoDB Logs:"
kubectl logs deployment/mongodb -n three-tier --tail=20

echo ""
echo "🔍 Testing Backend Connectivity:"
echo "Testing backend health endpoint..."
kubectl exec -it deployment/api -n three-tier -- curl -s http://localhost:3500/healthz || echo "❌ Backend health check failed"

echo ""
echo "🔍 Testing MongoDB Connectivity from Backend:"
echo "Testing database connection..."
kubectl exec -it deployment/api -n three-tier -- node -e "
const mongoose = require('mongoose');
mongoose.connect('mongodb://mongodb-svc:27017/todo?directConnection=true&authSource=admin', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  user: process.env.MONGO_USERNAME,
  pass: process.env.MONGO_PASSWORD
}).then(() => {
  console.log('✅ MongoDB connection successful');
  process.exit(0);
}).catch(err => {
  console.log('❌ MongoDB connection failed:', err.message);
  process.exit(1);
});
" || echo "❌ Database connection test failed"

echo ""
echo "💡 Common Issues and Solutions:"
echo "1. If pods are not ready, check: kubectl describe pod <pod-name> -n three-tier"
echo "2. If services can't connect, check: kubectl get endpoints -n three-tier"
echo "3. If database connection fails, check MongoDB logs and secrets"
echo "4. If frontend can't reach backend, verify the REACT_APP_BACKEND_URL environment variable" 