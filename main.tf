module "eks_eks-managed-node-group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "19.20.0"

  name            = "managed-node-group"
  cluster_name    = "test-cluster"
  cluster_version = "1.28"

  subnet_ids = ["subnet-0016ad2c1d76e8fe7", "subnet-0de774a5b67c4ec28", "subnet-0bddfbcec7ad1ea99"]

  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  #cluster_primary_security_group_id = ""
  #vpc_security_group_ids            = [module.eks.node_security_group_id]

  // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
  // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
  // use_custom_launch_template = false
  // disk_size = 50
  //
  //  # Remote access cannot be specified with a launch template
  //  remote_access = {
  //    ec2_ssh_key               = module.key_pair.key_pair_name
  //    source_security_group_ids = [aws_security_group.remote_access.id]
  //  }

  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types = ["t2.micro"]
  capacity_type  = "SPOT"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  taints = {
    dedicated = {
      key    = "dedicated"
      value  = "gpuGroup"
      effect = "NO_SCHEDULE"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
