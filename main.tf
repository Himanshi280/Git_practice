module "iam_role" {
  source = "./modules/iam-role"
  cluster_role_name = var.cluster_role_name
  node_role_name = var.node_role_name
}

module "eks_cluster" {
  source = "./modules/eks"
  cluster-details = var.cluster-details
  role_arn = module.iam_role.cluster_role_arn
  depends_on = [ module.iam_role ]
}

# module "node_group" {
#   source = "./modules/node-group"
#   node-group-details = var.node-group-details
#   node_role_arn = module.iam_role.node_group_arn
#   depends_on = [ module.eks_cluster, module.iam_role ]
#   # eks_version = module.eks_cluster.eks_version
# } 
