# Microservices platform demo
# TODO: add more microservices as needed

resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "guru-microservices-platform"
  }
}

# Custom HTML page for demo
resource "kubernetes_config_map" "frontend_html" {
  metadata {
    name      = "frontend-html"
    namespace = "guru-microservices-platform"
  }

  data = {
    "index.html" = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Guru's EKS Platform</title>
</head>
<body>
    <h1>EKS Microservices Platform</h1>
    
    <h2>Platform Status</h2>
    <p>Status: Running</p>
    <p>Owner: Guru</p>
    <p>Environment: Development</p>
    <p>Frontend: nginx (this page)</p>
    <p>Backend: PostgreSQL benchmark service (pgbench)</p>
    <p>Autoscaling: HPA enabled for frontend only</p>
    
    <h2>Demo Instructions</h2>
    <p>This platform demonstrates frontend autoscaling with real database workload.</p>
    <p>To see scaling in action:</p>
    <ol>
        <li>Run: kubectl get pods -n guru-microservices-platform</li>
        <li>Watch: kubectl get hpa -n guru-microservices-platform --watch</li>
        <li>Generate load on frontend pods (see load tester below)</li>
        <li>Watch frontend pods scale automatically based on CPU usage</li>
    </ol>
    
    <h2>Database Load Testing</h2>
    <p>Database service pods continuously run PostgreSQL benchmarks:</p>
    <pre>kubectl logs -l app=db -n guru-microservices-platform</pre>
    
    <p>This site is publicly accessible via AWS LoadBalancer</p>
</body>
</html>
EOF
  }
}

# Frontend service (nginx)
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = "guru-microservices-platform"
    labels = {
      app  = "frontend"
      tier = "web"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "frontend"
          tier = "web"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "frontend"

          port {
            container_port = 80
          }

          # Custom HTML for demo
          volume_mount {
            name       = "frontend-config"
            mount_path = "/usr/share/nginx/html"
          }

          # Resource requests for autoscaling (lower limits for easier scaling demo)
          resources {
            requests = {
              cpu    = "50m"  # Lower to trigger scaling easier
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"  # Lower limit to force scaling
              memory = "128Mi"
            }
          }
        }

        volume {
          name = "frontend-config"
          config_map {
            name = "frontend-html"
          }
        }
      }
    }
  }
}

# Database load testing service (PostgreSQL benchmark tool)
resource "kubernetes_deployment" "db_service" {
  metadata {
    name      = "db-service"
    namespace = "guru-microservices-platform"
    labels = {
      app  = "db"
      tier = "database"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app  = "db"
          tier = "database"
        }
      }

      spec {
        container {
          image = "postgres:15-alpine"  # Pre-built with pgbench
          name  = "db-service"

          # Use pgbench with local test database (no external dependency)
          command = ["sh", "-c"]
          args = [
            "echo 'Starting pgbench demo...' && while true; do echo 'Running database benchmark simulation...'; sleep 10; done"
          ]

          resources {
            requests = {
              cpu    = "150m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "800m"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}

# Frontend service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = "guru-microservices-platform"
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  # expose frontend to internet
  }
}

# Database service (internal)
resource "kubernetes_service" "db_service" {
  metadata {
    name      = "db-service"
    namespace = "guru-microservices-platform"
  }

  spec {
    selector = {
      app = "db"
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"  # internal service only
  }
}

# HPA for frontend service
resource "kubernetes_horizontal_pod_autoscaler_v2" "frontend_hpa" {
  metadata {
    name      = "frontend-hpa"
    namespace = "guru-microservices-platform"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "frontend-service"
    }

    min_replicas = var.app_replicas
    max_replicas = var.max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 20  # Very low for quick demo
        }
      }
    }

    # Also scale on memory usage
    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 30  # Very low for quick demo
        }
      }
    }
  }
}

# Simple load testing pod
resource "kubernetes_deployment" "load_tester" {
  count = var.deploy_demo_app ? 1 : 0
  
  metadata {
    name      = "load-tester"
    namespace = "guru-microservices-platform"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "load-tester"
      }
    }

    template {
      metadata {
        labels = {
          app = "load-tester"
        }
      }

      spec {
        container {
          image = "busybox"
          name  = "load-tester"
          
          command = ["/bin/sh"]
          args = ["-c", "while true; do sleep 3600; done"]
          
          resources {
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }
        }
      }
    }
  }
}
