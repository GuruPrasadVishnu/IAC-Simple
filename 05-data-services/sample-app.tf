# Sample application deployment that connects to PostgreSQL
resource "kubernetes_deployment" "sample_app" {
  metadata {
    name      = "sample-app"
    namespace = kubernetes_namespace.database_test.metadata[0].name
    labels = {
      app = "sample-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "sample-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "sample-app"
        }
      }

      spec {
        container {
          image = "node:16-alpine"
          name  = "app"
          
          # Keep container running for demo
          command = ["sleep", "3600"]
          
          # Database connection environment variables
          env {
            name  = "DB_HOST"
            value = aws_db_instance.postgresql.endpoint
          }
          
          env {
            name  = "DB_PORT"
            value = "5432"
          }
          
          env {
            name  = "DB_NAME"
            value = aws_db_instance.postgresql.db_name
          }
          
          env {
            name  = "DB_USER"
            value = aws_db_instance.postgresql.username
          }
          
          env {
            name  = "DB_PASSWORD"
            value = aws_db_instance.postgresql.password
          }

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# Service to expose the app
resource "kubernetes_service" "sample_app_service" {
  metadata {
    name      = "sample-app-service"
    namespace = kubernetes_namespace.database_test.metadata[0].name
  }

  spec {
    selector = {
      app = "sample-app"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}
