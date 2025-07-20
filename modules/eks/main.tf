data "aws_vpc" "default" {
    default = true
}

# data "aws_subnets" "default" {
#     filter {
#         name   = "vpc-id"
#         values = [data.aws_vpc.default.id]
#     }
# }

# Filter out the subnets that are in supported AZs only
# Error: creating EKS Cluster (eks-cluster): operation error EKS: CreateCluster, https response error StatusCode: 400, RequestID: 3d1a5826-3bd1-446f-a19c-99643d67dcfd, 
# UnsupportedAvailabilityZoneException: Cannot create cluster 'eks-cluster' because EKS does not support creating control plane instances in us-east-1e, 
# the targeted availability zone. Retry cluster creation using control plane subnets that span at least two of these availability zones: 
# us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f. Note, post cluster creation, 
# you can run worker nodes in separate subnets/availability zones from control plane subnets/availability zones passed during cluster creation

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]  # Supported AZs
  }
}

# data "aws_security_group" "default" {
#     vpc_id = data.aws_vpc.default.id
#     filter {
#         name   = "group-name"
#         values = ["default"]
#     }
# }

resource "aws_eks_cluster" "eks-cluster" {
    name     = var.cluster-details.name
    role_arn = var.role_arn
    # version  = var.cluster-details.version

    vpc_config {
        subnet_ids         = data.aws_subnets.default.ids
        # security_group_ids = [data.aws_security_group.default.id]
        # endpoint_private_access = var.cluster-details.vpc_config.endpoint_private_access
        # endpoint_public_access  = var.cluster-details.vpc_config.endpoint_public_access
    }

    
    # access_config {
    #     authentication_mode = var.cluster-details.access_config.authentication_mode
    #     bootstrap_cluster_creator_admin_permissions = var.cluster-details.access_config.bootstrap_cluster_creator_admin_permissions
    # }

    # tags = var.cluster-details.tags
}

# resource "aws_eks_addon" "vpc-cni" {
#   cluster_name = aws_eks_cluster.eks-cluster.name
#   addon_name   = "vpc-cni"
#   resolve_conflicts_on_update = "PRESERVE"
# }

# resource "aws_eks_addon" "coredns" {
#   cluster_name                = aws_eks_cluster.eks-cluster.name
#   addon_name                  = "coredns"
#   resolve_conflicts_on_update = "PRESERVE"
# }

# resource "aws_eks_addon" "kube_proxy" {
#   cluster_name = aws_eks_cluster.eks-cluster.name
#   addon_name   = "kube-proxy"
# }

# resource "aws_eks_addon" "eks_pod_identity_agent" {
#   cluster_name = aws_eks_cluster.eks-cluster.name
#   addon_name   = "eks-pod-identity-webhook"
# }