#!/bin/bash

echo "🚀 Deploying application to GKE cluster..."

# Create namespace if it doesn't exist
kubectl create namespace three-tier --dry-run=client -o yaml | kubectl apply -f -

echo "📦 Deploying MongoDB..."
kubectl apply -f Database/

echo "⏳ Waiting for MongoDB to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n three-tier

echo "🔧 Deploying Backend..."
kubectl apply -f Backend/

echo "⏳ Waiting for Backend to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/api -n three-tier

echo "🎨 Deploying Frontend..."
kubectl apply -f Frontend/

echo "⏳ Waiting for Frontend to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/frontend -n three-tier

echo "🌐 Deploying Ingress..."
kubectl apply -f ingress.yaml

echo "✅ All components deployed!"
echo ""
echo "📊 Check deployment status:"
echo "kubectl get pods -n three-tier"
echo ""
echo "🔍 Check backend logs:"
echo "kubectl logs -f deployment/api -n three-tier"
echo ""
echo "🔍 Check frontend logs:"
echo "kubectl logs -f deployment/frontend -n three-tier"
echo ""
echo "🔍 Check MongoDB logs:"
echo "kubectl logs -f deployment/mongodb -n three-tier" 