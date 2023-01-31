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



resource "aws_lambda_function" "lambda" {
  function_name = "LambdaDownloadGZFile"
  image_uri = var.image_uri
  package_type = "Image"
  role = aws_iam_role.lambda_exec_role_tf1.arn
  timeout = 300
}

resource "aws_iam_role" "lambda_exec_role_tf1" {
  name = "lambda_exec_role_tf1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_permissions_tf1" {
  name = "lambda_s3_permissions_tf1"
  role = "${aws_iam_role.lambda_exec_role_tf1.id}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_secretsmanager_permissions_tf1" {
  name = "lambda_secretsmanager_permissions_tf1"
  role = "${aws_iam_role.lambda_exec_role_tf1.id}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}
