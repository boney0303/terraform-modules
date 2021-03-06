data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20191116.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
  owners = ["137112412989"] # Canonical
}

resource "aws_instance" "devops" {
  ami = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0ed94c2dfa02f6493",]
  subnet_id = "subnet-05978ee2148fccb88"

  tags = {
    Name = "tf-host"
  }
}
