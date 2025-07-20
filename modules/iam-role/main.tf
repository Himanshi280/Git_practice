# EKS-cluster-role-policy
data "aws_iam_policy_document" "eks-cluster-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks-cluster-role" {
  name = var.cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}


# EKS-node-role 
data "aws_iam_policy_document" "eks-node-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks-node-role" {
  name = var.node_role_name
  assume_role_policy = data.aws_iam_policy_document.eks-node-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "node-policy-attachment" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "registry-policy-attachment" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
