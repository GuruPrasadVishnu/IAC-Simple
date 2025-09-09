# Database connection info (optimized for demo)
output "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint for applications"
  value       = aws_db_instance.postgresql.endpoint
}

output "postgres_database" {
  description = "PostgreSQL database name"
  value       = aws_db_instance.postgresql.db_name
}

# Redis connection info  
output "redis_endpoint" {
  description = "Redis ElastiCache endpoint for caching"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

# Kafka connection info
output "kafka_brokers" {
  description = "Kafka MSK bootstrap brokers for messaging"
  value       = aws_msk_cluster.kafka.bootstrap_brokers
}

# Quick demo connection test
output "demo_connection_test" {
  description = "Command to test database connectivity from Kubernetes"
  value       = "kubectl exec -it postgres-test -n database-test -- psql -h ${aws_db_instance.postgresql.endpoint} -U demouser -d demoapp"
}
