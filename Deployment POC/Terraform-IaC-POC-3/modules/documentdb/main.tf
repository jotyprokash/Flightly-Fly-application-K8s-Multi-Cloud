resource "aws_docdb_subnet_group" "main" {
  name       = "${var.project_name}-docdb-subnet-group-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-docdb-subnet-group"
  }
}

resource "aws_security_group" "docdb_sg" {
  name        = "${var.project_name}-docdb-sg-${var.environment}"
  description = "Allow inbound traffic to DocumentDB from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Mongo from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-docdb-sg"
  }
}

resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.project_name}-db-cluster-${var.environment}"
  engine                  = "docdb"
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.docdb_sg.id]
  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "main" {
  count              = 1
  identifier         = "${var.project_name}-db-instance-${var.environment}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = "db.t3.medium"
}
