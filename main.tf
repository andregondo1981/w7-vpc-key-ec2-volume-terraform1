//This is the code for vpc 

resource "aws_vpc" "my-vpc" {
  cidr_block = "172.120.0.0/16"  // class B 65k
enable_dns_hostnames = true
enable_dns_support = true
instance_tenancy = "default"
  tags = {
    Name = "utc-vpc"
    env = "Dev"
    app-name= "utc"
    team= "wdp"
    created_by= "Andre"
  }
}

// internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "utc-IGW"
  }
}

// public subnet 
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.1.0/24"  // class c  254 ips 
  availability_zone = "us-east-1a"
  

  tags = {
    Name = "utc-public-sub1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.2.0/24"  // class c  254 ips 
  availability_zone = "us-east-1b"
 
  tags = {
    Name = "utc-public-sub2"
  }
  depends_on = [ aws_vpc.my-vpc ] #dependency
}

// subnet creation private
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.3.0/24"  // class c  254 ips 
  availability_zone = "us-east-1a"

  tags = {
    Name = "utc-private-sub1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.4.0/24"  // class c  254 ips 
  availability_zone = "us-east-1b"

  tags = {
    Name = "utc-private-sub2"
  }
}

#Nat gate way 

resource "aws_eip" "eip1" {}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id  
  subnet_id = aws_subnet.public1.id
  tags = {
    Name = "utc-nat-gw1"
  }
}
# private route table

resource "aws_route_table" "rtprivate" {
    vpc_id = aws_vpc.my-vpc.id  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat1.id  
    }
}

# public rt
resource "aws_route_table" "rtpublic" {
    vpc_id = aws_vpc.my-vpc.id  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id  

    }
}
# pub route table association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id 
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id 
  route_table_id = aws_route_table.rtpublic.id
}

#priv rt association 
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private1.id   
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.private2.id    
  route_table_id = aws_route_table.rtprivate.id
}



