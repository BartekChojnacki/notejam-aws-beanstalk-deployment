#Networks

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC ID"
}

output "private_az_subnet_ids_ebs" {
  value = module.private_subnets_ebs.az_subnet_ids
}

output "private_az_subnet_ids_rds" {
  value = module.private_subnets_rds.az_subnet_ids
}

output "public_az_subnet_ids_lb" {
  value = module.public_subnets_lb.az_subnet_ids
}

#EB APPLICATION

output "elastic_beanstalk_application_name" {
  value       = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  description = "Elastic Beanstalk Application name"
}

#EB ENV DEV

output "elastic_beanstalk_environment_dev_hostname" {
  value       = module.elastic_beanstalk_environment_dev.hostname
  description = "DNS hostname"
}

output "elastic_beanstalk_environment_dev_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk_environment_dev.id
}

output "elastic_beanstalk_environment_dev_name" {
  value       = module.elastic_beanstalk_environment_dev.name
  description = "Name"
}

output "elastic_beanstalk_environment_dev_security_group_id" {
  value       = module.elastic_beanstalk_environment_dev.security_group_id
  description = "Security group id"
}

output "elastic_beanstalk_environment_dev_elb_zone_id" {
  value       = module.elastic_beanstalk_environment_dev.elb_zone_id
  description = "ELB zone id"
}

output "elastic_beanstalk_environment_dev_ec2_instance_profile_role_name" {
  value       = module.elastic_beanstalk_environment_dev.ec2_instance_profile_role_name
  description = "Instance IAM role name"
}

output "elastic_beanstalk_environment_dev_tier" {
  description = "The environment tier"
  value       = module.elastic_beanstalk_environment_dev.tier
}

output "elastic_beanstalk_environment_dev_application" {
  description = "The Elastic Beanstalk Application specified for this environment"
  value       = module.elastic_beanstalk_environment_dev.application
}

output "elastic_beanstalk_environment_dev_setting" {
  description = "Settings specifically set for this environment"
  value       = module.elastic_beanstalk_environment_dev.setting
}

output "elastic_beanstalk_environment_dev_all_settings" {
  description = "List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration"
  value       = module.elastic_beanstalk_environment_dev.all_settings
}

output "elastic_beanstalk_environment_dev_endpoint" {
  description = "Fully qualified DNS name for the environment"
  value       = module.elastic_beanstalk_environment_dev.endpoint
}

output "elastic_beanstalk_environment_dev_autoscaling_groups" {
  description = "The autoscaling groups used by this environment"
  value       = module.elastic_beanstalk_environment_dev.autoscaling_groups
}

output "elastic_beanstalk_environment_dev_instances" {
  description = "Instances used by this environment"
  value       = module.elastic_beanstalk_environment_dev.instances
}

output "elastic_beanstalk_environment_dev_launch_configurations" {
  description = "Launch configurations in use by this environment"
  value       = module.elastic_beanstalk_environment_dev.launch_configurations
}

output "elastic_beanstalk_environment_dev_load_balancers" {
  description = "Elastic Load Balancers in use by this environment"
  value       = module.elastic_beanstalk_environment_dev.load_balancers
}

output "elastic_beanstalk_environment_dev_queues" {
  description = "SQS queues in use by this environment"
  value       = module.elastic_beanstalk_environment_dev.queues
}

output "elastic_beanstalk_environment_dev_triggers" {
  description = "Autoscaling triggers in use by this environment"
  value       = module.elastic_beanstalk_environment_dev.triggers
}

#EB ENV PROD

output "elastic_beanstalk_environment_prod_hostname" {
  value       = module.elastic_beanstalk_environment_prod.hostname
  description = "DNS hostname"
}

output "elastic_beanstalk_environment_prod_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk_environment_prod.id
}

output "elastic_beanstalk_environment_prod_name" {
  value       = module.elastic_beanstalk_environment_prod.name
  description = "Name"
}

output "elastic_beanstalk_environment_prod_security_group_id" {
  value       = module.elastic_beanstalk_environment_prod.security_group_id
  description = "Security group id"
}

output "elastic_beanstalk_environment_prod_elb_zone_id" {
  value       = module.elastic_beanstalk_environment_prod.elb_zone_id
  description = "ELB zone id"
}

output "elastic_beanstalk_environment_prod_ec2_instance_profile_role_name" {
  value       = module.elastic_beanstalk_environment_prod.ec2_instance_profile_role_name
  description = "Instance IAM role name"
}

output "elastic_beanstalk_environment_prod_tier" {
  description = "The environment tier"
  value       = module.elastic_beanstalk_environment_prod.tier
}

output "elastic_beanstalk_environment_prod_application" {
  description = "The Elastic Beanstalk Application specified for this environment"
  value       = module.elastic_beanstalk_environment_prod.application
}

output "elastic_beanstalk_environment_prod_setting" {
  description = "Settings specifically set for this environment"
  value       = module.elastic_beanstalk_environment_prod.setting
}

output "elastic_beanstalk_environment_prod_all_settings" {
  description = "List of all option settings configured in the environment. These are a combination of default settings and their overrides from setting in the configuration"
  value       = module.elastic_beanstalk_environment_prod.all_settings
}

output "elastic_beanstalk_environment_prod_endpoint" {
  description = "Fully qualified DNS name for the environment"
  value       = module.elastic_beanstalk_environment_prod.endpoint
}

output "elastic_beanstalk_environment_prod_autoscaling_groups" {
  description = "The autoscaling groups used by this environment"
  value       = module.elastic_beanstalk_environment_prod.autoscaling_groups
}

output "elastic_beanstalk_environment_prod_instances" {
  description = "Instances used by this environment"
  value       = module.elastic_beanstalk_environment_prod.instances
}

output "elastic_beanstalk_environment_prod_launch_configurations" {
  description = "Launch configurations in use by this environment"
  value       = module.elastic_beanstalk_environment_prod.launch_configurations
}

output "elastic_beanstalk_environment_prod_load_balancers" {
  description = "Elastic Load Balancers in use by this environment"
  value       = module.elastic_beanstalk_environment_prod.load_balancers
}

output "elastic_beanstalk_environment_prod_queues" {
  description = "SQS queues in use by this environment"
  value       = module.elastic_beanstalk_environment_prod.queues
}

output "elastic_beanstalk_environment_prod_triggers" {
  description = "Autoscaling triggers in use by this environment"
  value       = module.elastic_beanstalk_environment_prod.triggers
}

# RDS PROD

output "instance_id_prod" {
  value       = module.rds_instance_prod.instance_id
  description = "ID of the instance"
}

output "instance_address_prod" {
  value       = module.rds_instance_prod.instance_address
  description = "Address of the instance"
}

output "instance_endpoint_prod" {
  value       = module.rds_instance_prod.instance_endpoint
  description = "DNS Endpoint of the instance"
}

output "subnet_group_id_prod" {
  value       = module.rds_instance_prod.subnet_group_id
  description = "ID of the Subnet Group"
}

output "security_group_id_prod" {
  value       = module.rds_instance_prod.security_group_id
  description = "ID of the Security Group"
}

output "parameter_group_id_prod" {
  value       = module.rds_instance_prod.parameter_group_id
  description = "ID of the Parameter Group"
}

output "option_group_id_prod" {
  value       = module.rds_instance_prod.option_group_id
  description = "ID of the Option Group"
}

output "hostname_prod" {
  value       = module.rds_instance_prod.hostname
  description = "DNS host name of the instance"
}

# RDS DEV

output "instance_id_dev" {
  value       = module.rds_instance_dev.instance_id
  description = "ID of the instance"
}

output "instance_address_dev" {
  value       = module.rds_instance_dev.instance_address
  description = "Address of the instance"
}

output "instance_endpoint_dev" {
  value       = module.rds_instance_dev.instance_endpoint
  description = "DNS Endpoint of the instance"
}

output "subnet_group_id_dev" {
  value       = module.rds_instance_dev.subnet_group_id
  description = "ID of the Subnet Group"
}

output "security_group_id_dev" {
  value       = module.rds_instance_dev.security_group_id
  description = "ID of the Security Group"
}

output "parameter_group_id_dev" {
  value       = module.rds_instance_dev.parameter_group_id
  description = "ID of the Parameter Group"
}

output "option_group_id_dev" {
  value       = module.rds_instance_dev.option_group_id
  description = "ID of the Option Group"
}

output "hostname_dev" {
  value       = module.rds_instance_dev.hostname
  description = "DNS host name of the instance"
}