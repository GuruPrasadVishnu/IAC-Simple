# Quick database connectivity test
resource "kubernetes_namespace" "database_test" {
  metadata {
    name = "database-test"
  }
}

# Simple test pod with database connection
resource "kubernetes_pod" "db_test_pod" {
  metadata {
    name      = "postgres-test"
    namespace = kubernetes_namespace.database_test.metadata[0].name
    labels = {
      app = "db-test"
    }
  }

  spec {
    container {
      image = "postgres:15-alpine"
      name  = "postgres-client"
      
      command = ["sh", "-c"]
      args = ["echo 'Database test pod ready. Run: psql -h $PGHOST -U $PGUSER -d $PGDATABASE' && sleep 3600"]
      
      env {
        name  = "PGHOST"
        value = aws_db_instance.postgresql.endpoint
      }
      
      env {
        name  = "PGPORT"
        value = "5432"
      }
      
      env {
        name  = "PGDATABASE"
        value = aws_db_instance.postgresql.db_name
      }
      
      env {
        name  = "PGUSER"
        value = aws_db_instance.postgresql.username
      }
      
      env {
        name  = "PGPASSWORD"
        value = aws_db_instance.postgresql.password
      }
    }
  }
}
