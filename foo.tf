resource "aws_msk_cluster" "name" {
    cluster_name           = "guru-kafka-cluster"
    kafka_version         = "2.8.1"
    number_of_broker_nodes = 3
    broker_node_group_info {
        instance_type   = "kafka.m5.large"
        client_subnets  = var.private_subnet_ids
        security_groups = [aws_security_group.kafka.id]
    }
    open_monitoring {
        prometheus {
        jmx_exporter {
            enabled_in_broker = true
        }
        node_exporter {
            enabled_in_broker = true
        }
        }
    }

  
}

resource "" "name" {
  
}