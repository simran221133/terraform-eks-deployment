module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "test-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-08e82dceb34c33b38"
  subnet_ids               = ["subnet-0016ad2c1d76e8fe7", "subnet-0de774a5b67c4ec28", "subnet-0bddfbcec7ad1ea99"]
  control_plane_subnet_ids = ["subnet-0016ad2c1d76e8fe7", "subnet-0de774a5b67c4ec28", "subnet-0bddfbcec7ad1ea99"]

  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}