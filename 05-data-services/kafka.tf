# Simple Kafka Cluster
resource "aws_msk_cluster" "kafka" {
  cluster_name           = "simple-kafka"
  kafka_version          = "3.7.x"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = data.terraform_remote_state.foundation.outputs.private_subnet_ids
    security_groups = [aws_security_group.kafka_sg.id]
    
    storage_info {
      ebs_storage_info {
        volume_size = 20
      }
    }
  }

  tags = {
    Name = "simple-kafka"
  }
}

# Allow access from VPC
resource "aws_security_group" "kafka_sg" {
  name   = "simple-kafka-sg"
  vpc_id = data.terraform_remote_state.foundation.outputs.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
