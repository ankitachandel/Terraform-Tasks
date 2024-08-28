provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"  # Replace with your key pair name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with your public key file path
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  # Specify the Security Group
  vpc_security_group_ids = ["sg-0123456789abcdef0"]  # Replace with your security group ID

  # Specify the Subnet
  subnet_id = "subnet-0123456789abcdef0"  # Replace with your subnet ID

  # Add Userdata script
  user_data = file("userdata.sh")

  # Tags
  tags = {
    Name = "Nodejs-app"
  }

  # Block Device Mappings (optional)
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
