#!/bin/bash
# 🚀 Quick Data Services Demo Script

echo "=== 📊 AWS Data Services Demo ==="
echo ""

echo "1️⃣  Checking data services status..."
echo "PostgreSQL Database:"
aws rds describe-db-instances --db-instance-identifier demo-postgres-db --query 'DBInstances[0].[DBInstanceStatus,Endpoint.Address]' --output table

echo ""
echo "Redis ElastiCache:"
aws elasticache describe-cache-clusters --cache-cluster-id demo-redis --query 'CacheClusters[0].[CacheClusterStatus,RedisConfiguration.PrimaryEndpoint.Address]' --output table

echo ""
echo "2️⃣  Testing database connectivity from Kubernetes..."
kubectl get pods -n database-test

echo ""
echo "3️⃣  Quick database connection test:"
echo "kubectl exec -it postgres-test -n database-test -- psql -h \$PGHOST -U \$PGUSER -d \$PGDATABASE -c 'SELECT version();'"

echo ""
echo "4️⃣  Database connection details:"
kubectl exec postgres-test -n database-test -- env | grep PG

echo ""
echo "=== ✅ Data Services Demo Complete! ==="
echo "💡 Next: Show how EKS apps can connect to these data services"
