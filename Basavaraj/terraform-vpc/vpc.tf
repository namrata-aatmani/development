#Create vpc
resource "aws_vpc" "basu-project" {
    cidr_block = "172.150.0.0/16"
    instance_tenancy = "default"
    enable_dns_support =  "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
}
#Create Public Subnet
resource "aws_subnet" "basu-project-public" {
    vpc_id = "${aws_vpc.basu-project.id}"
    cidr_block = "172.150.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "ap-southeast-1a"
}
#Create a Private Subnet                   # Creating Private Subnets
 resource "aws_subnet" "basu-project-private" {
   vpc_id =  "${aws_vpc.basu-project.id}"
   cidr_block = "172.150.2.0/24"
   availability_zone = "ap-southeast-1b"        # CIDR block of private subnets
 }

#Create a VPC Internet Gateway.
resource "aws_internet_gateway" "basu-project-gateway" {
  vpc_id = "${aws_vpc.basu-project.id}"

  tags = {
    Name = "basu-project-gateway"
  }
}
#Create a VPC routing table for Internet Gateway(public subnet)
resource "aws_route_table" "basu-project-public" {
  vpc_id = "${aws_vpc.basu-project.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.basu-project-gateway.id}"
  }

 tags = {
    Name = "basu-project-public"
  }
}
#Create Route table for Private Subnet
 resource "aws_route_table" "basu-project-private" {    # Creating RT for Private Subnet
   vpc_id = "${aws_vpc.basu-project.id}"
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = "${aws_nat_gateway.NATgateway.id}"
   }
}
#Create an association between a route table and public subnets
resource "aws_route_table_association" "basu-project-public-1a" {
  subnet_id      = "${aws_subnet.basu-project-public.id}"
  route_table_id = "${aws_route_table.basu-project-public.id}"
}
#Create Route table Association with Private Subnet's
 resource "aws_route_table_association" "basu-project-private-1a" {
    subnet_id = "${aws_subnet.basu-project-private.id}"
    route_table_id = "${aws_route_table.basu-project-private.id}"
 }
#Create EIP
 resource "aws_eip" "NAT-EIP" {
   vpc   = "true"
 }
#Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgateway" {
   allocation_id = "${aws_eip.NAT-EIP.id}"
   subnet_id = "${aws_subnet.basu-project-public.id}"
 }
#Create a security group
resource "aws_security_group" "basu-project-ssh-allowed" {
    vpc_id = "${aws_vpc.basu-project.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
// Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


