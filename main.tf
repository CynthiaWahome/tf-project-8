provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"            
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"    
  tags = {
    Name = "MyVPC"      
  }        
}

# Create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.main.id
  tags =  {
    Name = "MyInternetGateway"
  }
}

# Create Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "PublicSubnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags =  {
    Name = "PrivateSubnet"
  }
}

# Create Public Route Table
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

# Create Private Route Table
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "PrivateRouteTable"
  }
}

# Create Public Route Table Association
resource "aws_route_table_association" "public-association"{
  subnet_id        = aws_subnet.public-subnet.id
  route_table_id   = aws_route_table.publicrt.id
}

# Create Private Route Table Association
resource "aws_route_table_association" "private-association"{
  subnet_id        = aws_subnet.private-subnet.id
  route_table_id   = aws_route_table.privatert.id
}

# Create Security Group for EC2 Instance with SSH and ICMP Ports
resource "aws_security_group" "whizlabssg" {
  name        = "whizlabssg"
  description = "Allow incoming SSH and ICMP"
   vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Network ACL#########################
  resource "aws_network_acl" "whizlabs_NACL" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.public-subnet.id, aws_subnet.private-subnet.id]
  tags = {
    Name = "whizlabs_NACL"
  }
}

# Create Network ACL Rule for SSH Inbound
resource "aws_network_acl_rule" "ssh_inbound" {
  network_acl_id = aws_network_acl.whizlabs_NACL.id
  rule_number    = 100
  protocol       = "6"      # TCP protocol
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Create Network ACL Rule for ICMP Inbound
resource "aws_network_acl_rule" "icmp_inbound" {
  network_acl_id = aws_network_acl.whizlabs_NACL.id
  rule_number    = 200
  protocol       = "1"      # ICMP protocol
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  icmp_type      = -1  # All ICMP types
  icmp_code      = -1  # All ICMP codes
}

# Create Network ACL Rule for ICMP Outbound
resource "aws_network_acl_rule" "icmp_outbound" {
  network_acl_id = aws_network_acl.whizlabs_NACL.id
  rule_number    = 100  # Adjusted rule number
  protocol       = "1"  # ICMP protocol
  rule_action    = "allow"
   egress         = true
  cidr_block     = "0.0.0.0/0"
  icmp_type      = -1  # All ICMP types
  icmp_code      = -1  # All ICMP codes
}

# Create Network ACL Rule for TCP Outbound
resource "aws_network_acl_rule" "custom_tcp_outbound" {
  network_acl_id = aws_network_acl.whizlabs_NACL.id
  rule_number    = 200  # Adjusted rule number
  protocol       = "6"  # TCP protocol
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Create Key Pair 
resource "aws_key_pair" "whiz_key" {
  key_name   = "whizlabskey"
  public_key = tls_private_key.whiz_key.public_key_openssh
}
resource "tls_private_key" "whiz_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create Public EC2 Instance
resource "aws_instance" "public_instance" {
  ami             = "ami-0cf10cdf9fcd62d37"
  instance_type   = "t2.micro"
  key_name        = "whizlabskey"
  subnet_id       = aws_subnet.public-subnet.id
  security_groups = [aws_security_group.whizlabssg.id]  # Use security group ID here
  tags = {
    Name = "public_instance"
  }
}

# Create Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami             = "ami-0cf10cdf9fcd62d37"
  instance_type   = "t2.micro"
  key_name        = "whizlabskey"
  subnet_id       = aws_subnet.private-subnet.id
  security_groups = [aws_security_group.whizlabssg.id]  # Use security group ID here
  tags = {
    Name = "private_instance"
  }
}

