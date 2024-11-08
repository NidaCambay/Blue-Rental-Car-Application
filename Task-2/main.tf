provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "task" {
  ami = lookup(var.myami, terraform.workspace)
  instance_type = lookup(var.instance_type, terraform.workspace)
  key_name = lookup(var.key-pem, terraform.workspace)
  security_groups = [aws_security_group.brc-sg.name]
  tags = {
    Project = "Devops-Project-Server"
    Name = "${terraform.workspace}_server"
  }
}

resource "aws_security_group" "brc-sg" {
    name = "${terraform.workspace}-sg"
    tags = {
        Name = "${terraform.workspace}-sg"
    }

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        protocol = -1
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

variable "myami" {
  type = map(string)
  default = {
    staging = "ami-06b21ccaeff8cd686"
    dev     = "ami-0ddc798b3f1a5117e"
    prod    = "ami-06b21ccaeff8cd686"
    test    = "ami-0ddc798b3f1a5117e"
  }
}


variable "instance_type" {
  type = map(string)
  default = {
    dev     = "t2.micro"
    prod    = "t2.nano"
    test    = "t3a.medium"
    staging = "t2.small"
  }
}

variable "key-pem" {
  type = map(string)
  default = {
    dev     = "dev-key"
    prod    = "prod-key"
    test    = "test-key"
    staging = "staging-key"
  }
}

output "instance_id" {
  description = "instance id"
  value = aws_instance.task.id
}