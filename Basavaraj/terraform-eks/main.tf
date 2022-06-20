#terraform provider
terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
  }
 }
}

#creating iam role
resource "aws_iam_role" "eks-iam-role" {
 name = "basu-project-eks-iam-role"

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}

#creating policy
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}

#creating eks cluster
resource "aws_eks_cluster" "basu-project-eks-cluster" {
 name = "basu-project-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [var.subnet_id_1-public, var.subnet_id_2-private]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

#create workernodes
resource "aws_iam_role" "workernodes" {
  name = "basu-workernode"

  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }

#create node-group
resource "aws_eks_node_group" "worker-node-group" {
  capacity_type = "SPOT"
  cluster_name  = aws_eks_cluster.basu-project-eks-cluster.name
  node_group_name = "basu-workernode"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet_id_1-public, var.subnet_id_2-private]
  instance_types = ["t2.small"]

  scaling_config {
   desired_size = 1
   max_size   = 5
   min_size   = 1
  }

  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

