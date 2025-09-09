#!/bin/bash

echo "=== Database Connectivity Test ==="
echo ""

# Check if kubectl is configured
if ! kubectl get nodes > /dev/null 2>&1; then
    echo "❌ kubectl not configured. Run:"
    echo "aws eks update-kubeconfig --region us-east-1 --name simple-eks-cluster"
    exit 1
fi

echo "✅ kubectl is configured"

# Check if test pod is running
echo "📋 Checking test pod status..."
kubectl get pod postgres-test -n database-test

# Wait for pod to be ready
echo "⏳ Waiting for test pod to be ready..."
kubectl wait --for=condition=Ready pod/postgres-test -n database-test --timeout=300s

if [ $? -eq 0 ]; then
    echo "✅ Test pod is ready"
    
    echo ""
    echo "🧪 Testing database connection..."
    
    # Test basic connection
    kubectl exec -n database-test postgres-test -- psql -c "SELECT version();"
    
    if [ $? -eq 0 ]; then
        echo "✅ Database connection successful!"
        
        echo ""
        echo "🔍 Running additional tests..."
        
        # Test creating a table
        kubectl exec -n database-test postgres-test -- psql -c "
        CREATE TABLE IF NOT EXISTS test_table (
            id SERIAL PRIMARY KEY,
            name VARCHAR(50),
            created_at TIMESTAMP DEFAULT NOW()
        );"
        
        # Test inserting data
        kubectl exec -n database-test postgres-test -- psql -c "
        INSERT INTO test_table (name) VALUES ('test-from-eks');"
        
        # Test querying data
        kubectl exec -n database-test postgres-test -- psql -c "
        SELECT * FROM test_table;"
        
        echo "✅ All database tests passed!"
        
    else
        echo "❌ Database connection failed!"
        echo ""
        echo "🔍 Troubleshooting info:"
        kubectl exec -n database-test postgres-test -- env | grep PG
        kubectl exec -n database-test postgres-test -- nslookup $PGHOST
    fi
    
else
    echo "❌ Test pod failed to start"
    kubectl describe pod postgres-test -n database-test
fi
