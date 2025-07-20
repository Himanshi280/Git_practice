data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]  # Supported AZs
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

# data "aws_ssm_parameter" "eks_ami_release_version" {
#   name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/release_version"
# }

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.node-group-details.cluster_name
  node_group_name = var.node-group-details.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types  = var.node-group-details.instance_types
  # disk_size       = var.node-group-details.disk_size
  # version         = var.eks_version
  # release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

  scaling_config {
    desired_size = var.node-group-details.scaling_config.desired_size
    max_size     = var.node-group-details.scaling_config.max_size
    min_size     = var.node-group-details.scaling_config.min_size
  }

  # remote_access {
  #   ec2_ssh_key = var.node-group-details.remote_access.ec2_ssh_key
  #   source_security_group_ids = [data.aws_security_group.default.id]
  # }

  # depends_on = [
  #   aws_iam_role_policy_attachment.eks-nodegroup-AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.eks-nodegroup-AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.eks-nodegroup-AmazonEC2ContainerRegistryReadOnly,
  # ]

  # tags = var.node-group-details.tags
}

