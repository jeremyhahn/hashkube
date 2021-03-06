appname = "hashkube"
aws_region = "us-east-1"
aws_credentials_file = "~/.aws/credentials"
os_platform = "amazon-linux"
dhcp_options_domain_name = "service.consul"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1c", "us-east-1e"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
default_ssh_key_name = "hashkube"
devops_bucket_name = "hashkube-devops"
consul_cluster_size = 3
vault_cluster_size = 3
consul_instance_type = "t2.micro"
vault_instance_type = "t2.micro"
