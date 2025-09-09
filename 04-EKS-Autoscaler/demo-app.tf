# Microservices platform demo
# TODO: add more microservices as needed

resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices-platform"
  }
}

# Custom HTML page for demo
resource "kubernetes_config_map" "frontend_html" {
  metadata {
    name      = "frontend-html"
    namespace = "microservices-platform"
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
    <p>Backend: httpd API service</p>
    <p>Autoscaling: HPA enabled</p>
    
    <h2>Demo Instructions</h2>
    <p>This is a working Kubernetes platform with autoscaling.</p>
    <p>To see scaling in action:</p>
    <ol>
        <li>Run: kubectl get pods -n microservices-platform</li>
        <li>Generate load with the load tester pod</li>
        <li>Watch pods scale up automatically</li>
    </ol>
    
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
    namespace = "microservices-platform"
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

# API service (simple httpd)
resource "kubernetes_deployment" "api" {
  metadata {
    name      = "api-service"
    namespace = "microservices-platform"
    labels = {
      app  = "api"
      tier = "backend"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app  = "api"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "httpd:latest"  # simple web server for API simulation
          name  = "api"

          port {
            container_port = 80
          }

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
    namespace = "microservices-platform"
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

# API service (internal)
resource "kubernetes_service" "api" {
  metadata {
    name      = "api-service"
    namespace = "microservices-platform"
  }

  spec {
    selector = {
      app = "api"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"  # internal service only
  }
}

# HPA for frontend service
resource "kubernetes_horizontal_pod_autoscaler_v2" "frontend_hpa" {
  metadata {
    name      = "frontend-hpa"
    namespace = "microservices-platform"
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

# HPA for API service
resource "kubernetes_horizontal_pod_autoscaler_v2" "api_hpa" {
  metadata {
    name      = "api-hpa"
    namespace = "microservices-platform"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "api-service"
    }

    min_replicas = var.app_replicas
    max_replicas = var.app_replicas * 3  # more conservative scaling

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 25  # Very low for quick demo
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
    namespace = "microservices-platform"
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

# Metrics Server - Required for HPA to function
resource "kubernetes_deployment" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      app = "metrics-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "metrics-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "metrics-server"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.metrics_server.metadata[0].name

        container {
          name  = "metrics-server"
          image = "registry.k8s.io/metrics-server/metrics-server:v0.7.0"

          args = [
            "--cert-dir=/tmp",
            "--secure-port=4443",
            "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
            "--kubelet-use-node-status-port",
            "--metric-resolution=15s"
          ]

          port {
            name           = "https"
            container_port = 4443
            protocol       = "TCP"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "300m"
              memory = "500Mi"
            }
          }

          volume_mount {
            name       = "tmp-dir"
            mount_path = "/tmp"
          }

          security_context {
            allow_privilege_escalation = false
            capabilities {
              drop = ["ALL"]
            }
            read_only_root_filesystem = true
            run_as_non_root           = true
            run_as_user               = 1000
          }
        }

        volume {
          name = "tmp-dir"
          empty_dir {}
        }
      }
    }
  }
}

# ServiceAccount for metrics server
resource "kubernetes_service_account" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      app = "metrics-server"
    }
  }
}

# ClusterRole for metrics server
resource "kubernetes_cluster_role" "metrics_server" {
  metadata {
    name = "system:metrics-server"
    labels = {
      app = "metrics-server"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["nodes/metrics"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

# ClusterRoleBinding for metrics server
resource "kubernetes_cluster_role_binding" "metrics_server" {
  metadata {
    name = "system:metrics-server"
    labels = {
      app = "metrics-server"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.metrics_server.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.metrics_server.metadata[0].name
    namespace = "kube-system"
  }
}

# Service for metrics server
resource "kubernetes_service" "metrics_server" {
  metadata {
    name      = "metrics-server"
    namespace = "kube-system"
    labels = {
      app = "metrics-server"
    }
  }

  spec {
    selector = {
      app = "metrics-server"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
      protocol    = "TCP"
    }
  }
}

# APIService registration
resource "kubernetes_manifest" "metrics_server_apiservice" {
  manifest = {
    apiVersion = "apiregistration.k8s.io/v1"
    kind       = "APIService"
    metadata = {
      name = "v1beta1.metrics.k8s.io"
      labels = {
        app = "metrics-server"
      }
    }
    spec = {
      service = {
        name      = "metrics-server"
        namespace = "kube-system"
      }
      group                 = "metrics.k8s.io"
      version               = "v1beta1"
      insecureSkipTLSVerify = true
      groupPriorityMinimum  = 100
      versionPriority       = 100
    }
  }
}
