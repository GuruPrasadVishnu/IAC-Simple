# Simple nginx demo app - Direct Kubernetes resources (most reliable)

resource "kubernetes_namespace" "demo" {
  count = var.deploy_demo_app ? 1 : 0
  
  metadata {
    name = "demo"
  }
}

# Simple nginx deployment
resource "kubernetes_deployment" "demo_app" {
  count = var.deploy_demo_app ? 1 : 0

  metadata {
    name      = "demo-app"
    namespace = "demo"
    labels = {
      app = "demo-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "demo-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-app"
        }
      }

      spec {
        container {
          image = "nginx:1.29"
          name  = "nginx"

          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# Service for demo app
resource "kubernetes_service" "demo_app" {
  count = var.deploy_demo_app ? 1 : 0

  metadata {
    name      = "demo-app-service"
    namespace = "demo"
  }

  spec {
    selector = {
      app = "demo-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

# Horizontal Pod Autoscaler for demo app
resource "kubernetes_horizontal_pod_autoscaler_v2" "demo_app" {
  count = var.deploy_demo_app ? 1 : 0

  metadata {
    name      = "demo-app-hpa"
    namespace = "demo"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "demo-app"
    }

    min_replicas = 2
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 80
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.demo_app]
}

# Ingress to route traffic from existing ALB to demo app
resource "kubernetes_ingress_v1" "demo_app" {
  count = var.deploy_demo_app ? 1 : 0

  metadata {
    name      = "demo-app-ingress"
    namespace = "demo"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\":80}]"
      # Create new target group for this service
      "alb.ingress.kubernetes.io/group.name"      = "demo-app"
      "alb.ingress.kubernetes.io/group.order"     = "100"
      # Explicitly specify subnets for ALB
      "alb.ingress.kubernetes.io/subnets"         = "${join(",", data.terraform_remote_state.foundation.outputs.public_subnet_ids)}"
    }
  }

  spec {
    ingress_class_name = "alb"
    
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "demo-app-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.demo_app
  ]
}



