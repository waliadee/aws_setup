terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}


data "aws_security_group" "fetch_sg_name" {
  name = "ec2-airflow-sg"
}


resource "aws_instance" "app_server" {
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.medium"
  vpc_security_group_ids=[data.aws_security_group.fetch_sg_name.id]
  user_data = <<EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo usermod -a -G docker ec2-user
    id ec2-user
    newgrp docker
    sudo yum install python3-pip
    sudo pip3 install docker-compose
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    cd ..
    cd ..
    sudo mkdir airflow-docker
    sudo chmod a+rwx airflow-docker
    cd airflow-docker
    curl -Lf0 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml' --output docker-compose.yaml
    mkdir ./dags ./plugins ./logs
    touch .env
    echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >  .env
    docker-compose up airflow-init
    docker-compose up
  EOF


  tags = {
    Name = var.instance_name
  }
}
