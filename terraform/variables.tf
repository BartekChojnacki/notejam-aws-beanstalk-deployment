### ----- Variables definition
variable region {
  default = "us-east-2"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable cidr_block {
  default = "172.16.0.0/22"
}

variable public_cidr_block_lb {
  default = "172.16.0.1/24"
}

variable private_cidr_block_ebs {
  default = "172.16.1.1/24"
} 

variable private_cidr_block_rds {
  default = "172.16.2.1/24"
}

variable mysqluser {
  default = "root"
}

variable mysqlpassprod {
  default = "123456789"
}

variable mysqlpassdev {
  default = "987654321"
}
