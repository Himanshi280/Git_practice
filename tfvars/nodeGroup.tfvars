

node-group-details = {
  cluster_name    = "eks-cluster001"
  node_group_name = "eks-node-group"
  instance_types  = ["t2.micro"]
  # disk_size       = 50

  scaling_config = {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # remote_access = {
  #   ec2_ssh_key = ""
  # }


}