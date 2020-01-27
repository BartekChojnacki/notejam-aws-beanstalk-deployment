provider "aws" {
  region = var.region
}

# Networks: VPC + Subnets

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
  namespace  = "elbs"
  stage      = "prod"
  name       = "notejam"
  attributes = []
  tags       = {}
  delimiter  = "-"
  cidr_block = var.cidr_block
}

module "public_subnets_lb" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=tags/0.4.0"
  namespace           = "elbs"
  stage               = "prod"
  name                = "notejam"
  availability_zones  = var.availability_zone_names
  vpc_id              = module.vpc.vpc_id
  cidr_block          = var.public_cidr_block_lb
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
}

module "private_subnets_ebs" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=tags/0.4.0"
  namespace          = "elbs"
  stage              = "prod"
  name               = "notejam"
  availability_zones = var.availability_zone_names
  vpc_id             = module.vpc.vpc_id
  cidr_block         = var.private_cidr_block_ebs
  type               = "private"

  az_ngw_ids = module.public_subnets_lb.az_ngw_ids
}
module "private_subnets_rds" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=tags/0.4.0"
  namespace          = "rds"
  stage              = "prod"
  name               = "notejam"
  availability_zones = var.availability_zone_names
  vpc_id             = module.vpc.vpc_id
  cidr_block         = var.private_cidr_block_rds
  type               = "private"
  
  #no nat for database
  #az_ngw_ids = module.public_subnets_lb.az_ngw_ids
}

# Elastic Beanstalk Application NoteJam

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=tags/0.3.0"
  namespace   = "elbs"
  stage       = "prod"
  name        = "notejamapp"
  attributes  = []
  tags        = {}
  delimiter   = "-"
  description = "NoteJam Node.JS Elastic_beanstalk_application"
}

# Elastic Beanstalk Prod Environment

module "elastic_beanstalk_environment_prod" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=tags/0.17.0"
  namespace                  = "elbs"
  stage                      = "prod"
  name                       = "notejamapp"
  attributes                 = []
  tags                       = {}
  delimiter                  = "-"
  description                = "Application Environment Prod"
  region                     = var.region
  availability_zone_selector = "Any 2"
  # If you need to add public domain please update these two variables
  #dns_zone_id                = "Z3CGQ54B8RTB7E"
  #dns_subdomain              = "notejam-prod"

  wait_for_ready_timeout             = "20m"
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  environment_type                   = "LoadBalanced"
  loadbalancer_type                  = "application"
  elb_scheme                         = "public"
  tier                               = "WebServer"
  version_label                      = ""
  force_destroy                      = true

  instance_type    = "t3.nano"
  root_volume_size = 8
  root_volume_type = "gp2"
  
  #Autoscaling setup - one of bussiness requires
  autoscale_min             = 1
  autoscale_max             = 4
  autoscale_measure_name    = "CPUUtilization"
  autoscale_statistic       = "Average"
  autoscale_unit            = "Percent"
  autoscale_lower_bound     = 30
  autoscale_lower_increment = -1
  autoscale_upper_bound     = 80
  autoscale_upper_increment = 1

  vpc_id                  = module.vpc.vpc_id
  loadbalancer_subnets    = values(module.public_subnets_lb.az_subnet_ids)
  application_subnets     = values(module.private_subnets_ebs.az_subnet_ids)
  allowed_security_groups = [module.rds_instance_prod.security_group_id, module.vpc.vpc_default_security_group_id]

  rolling_update_enabled  = true
  rolling_update_type     = "Health"
  updating_min_in_service = 0
  updating_max_batch      = 1
  healthcheck_url         = "/"
  application_port        = 80

  solution_stack_name = "64bit Amazon Linux 2018.03 v4.13.0 running Node.js"

  # Debug Only
  #ssh_listener_port = 22
  #keypair = "localkey"
  #associate_public_ip_address = false
  ssh_listener_enabled = false

  additional_settings = [
     {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200,301,302"
    }
    ]

  env_vars             = {
  "MYSQL_HOST"         = module.rds_instance_prod.instance_address
  "MYSQL_USER"         = var.mysqluser
  "MYSQL_PASSWORD"     = var.mysqlpassprod
  "MYSQL_TCP_PORT"     = "3306" 
  "NOTEJAM_PORT"       = "8081"
  }
}

module "rds_instance_prod" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=tags/0.17.0"
  namespace                   = "rds"
  stage                       = "prod"
  name                        = "notejamdb"
  database_name               = "notejam"
  database_user               = var.mysqluser
  database_password           = var.mysqlpassprod
  database_port               = 3306
  #change to true on prod :)
  multi_az                    = true
  storage_type                = "standard"
  allocated_storage           = 5
  storage_encrypted           = false
  engine                      = "mysql"
  engine_version              = "5.7.17"
  instance_class              = "db.t3.micro"
  db_parameter_group          = "mysql5.7"
  publicly_accessible         = false
  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = values(module.private_subnets_rds.az_subnet_ids)
  security_group_ids          = [module.elastic_beanstalk_environment_prod.security_group_id]
  apply_immediately           = true
  backup_retention_period     = 35
  backup_window               = "22:00-03:00"
  copy_tags_to_snapshot       = true
}

# Elastic Beanstalk Dev Environment

module "elastic_beanstalk_environment_dev" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=tags/0.17.0"
  namespace                  = "elbs"
  stage                      = "dev"
  name                       = "notejamapp"
  attributes                 = []
  tags                       = {}
  delimiter                  = "-"
  description                = "Application Environment Dev"
  region                     = var.region
  availability_zone_selector = "Any 2"
  # If you need to add public domain please update these two variables
  #dns_zone_id                = "Z3CGQ54B8RTB7E"
  #dns_subdomain              = "notejam-dev"


  wait_for_ready_timeout             = "20m"
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  environment_type                   = "LoadBalanced"
  loadbalancer_type                  = "application"
  elb_scheme                         = "public"
  tier                               = "WebServer"
  version_label                      = ""
  force_destroy                      = true

  instance_type    = "t3.nano"
  root_volume_size = 8
  root_volume_type = "gp2"

  #Autoscaling setup
  autoscale_min             = 1
  autoscale_max             = 4
  autoscale_measure_name    = "CPUUtilization"
  autoscale_statistic       = "Average"
  autoscale_unit            = "Percent"
  autoscale_lower_bound     = 30
  autoscale_lower_increment = -1
  autoscale_upper_bound     = 80
  autoscale_upper_increment = 1

  vpc_id                  = module.vpc.vpc_id
  loadbalancer_subnets    = values(module.public_subnets_lb.az_subnet_ids)
  application_subnets     = values(module.private_subnets_ebs.az_subnet_ids)
  allowed_security_groups = [module.rds_instance_dev.security_group_id, module.vpc.vpc_default_security_group_id]

  rolling_update_enabled  = true
  rolling_update_type     = "Health"
  updating_min_in_service = 0
  updating_max_batch      = 1
  healthcheck_url         = "/"
  application_port        = 80

  solution_stack_name = "64bit Amazon Linux 2018.03 v4.13.0 running Node.js"

  # Debug Only
  #ssh_listener_port = 22
  #keypair = "localkey"
  #associate_public_ip_address = false
  ssh_listener_enabled = false

  
  additional_settings = [
     {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200,301,302"
    }
    ]
  
  env_vars             = {
  "MYSQL_HOST"         = module.rds_instance_dev.instance_address
  "MYSQL_USER"         = var.mysqluser
  "MYSQL_PASSWORD"     = var.mysqlpassdev
  "MYSQL_TCP_PORT"     = "3306" 
  "NOTEJAM_PORT"       = "8081"
  }
}

module "rds_instance_dev" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=tags/0.17.0"
  namespace                   = "rds"
  stage                       = "dev"
  name                        = "notejamdb"
  database_name               = "notejam"
  database_user               = var.mysqluser
  database_password           = var.mysqlpassdev
  database_port               = 3306
  multi_az                    = false
  storage_type                = "standard"
  allocated_storage           = 5
  storage_encrypted           = false
  engine                      = "mysql"
  engine_version              = "5.7.17"
  instance_class              = "db.t3.micro"
  db_parameter_group          = "mysql5.7"
  publicly_accessible         = false
  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = values(module.private_subnets_rds.az_subnet_ids)  
  security_group_ids          = [module.elastic_beanstalk_environment_dev.security_group_id]
  apply_immediately           = true
  backup_retention_period     = 0
  backup_window               = "22:00-03:00"
  copy_tags_to_snapshot       = true
}