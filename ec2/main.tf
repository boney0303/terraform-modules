data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_instance" "devops" {
  ami           = "${data.aws_ami.amazon.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = "ssh-http-https-icmp"
  subnet_id = "subnet-05978ee2148fccb88"

  tags = {
    Name = "tf-host"
  }
}
