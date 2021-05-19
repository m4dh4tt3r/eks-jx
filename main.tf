module "eks-jx" {
  source = "github.com/jenkins-x/terraform-aws-eks-jx?ref=v1.15.12"

  region = "us-east-2"

  # networking
  vpc_name        = "eks-jx"
  vpc_cidr_block  = "10.10.0.0/16"
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]

  # cluster
  cluster_name              = "jx"
  cluster_version           = "1.19"
  cluster_in_private_subnet = true
  cluster_endpoint_public_access        = false
  cluster_endpoint_private_access       = true
  cluster_endpoint_private_access_cidrs = ["10.0.0.0/16", "10.1.0.0/16", "10.100.0.0/16"]

  # nodes
  enable_worker_groups_launch_template = true
  enable_spot_instances                = true
  allowed_spot_instance_types          = ["m5.large", "m5a.large", "t3.large", "t3a.large"]
  lt_desired_nodes_per_subnet          = 2
  lt_min_nodes_per_subnet              = 2
  lt_max_nodes_per_subnet              = 7
  encrypt_volume_self                  = true

  # jenkins-x
  is_jx2 = false

  # secrets
  use_vault = true

  # backups
  enable_backup = true

  # external dns
  enable_external_dns = true
  apex_domain         = "yoyodyne.engineering"
}

output "jx_requirements" {
  value = module.eks-jx.jx_requirements
}

output "vault_user_id" {
  value       = module.eks-jx.vault_user_id
  description = "The Vault IAM user id"
}

output "vault_user_secret" {
  value       = module.eks-jx.vault_user_secret
  description = "The Vault IAM user secret"
  sensitive   = true
}
