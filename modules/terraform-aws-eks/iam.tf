# Master Node
resource "aws_iam_role" "eks_cluster" {
  name               = "eks_cluster" # This role will allow this EKS to call AssumeRole API to get STS
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "eks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy" "eks_cluster" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.eks_cluster.name 
  policy_arn = data.aws_iam_policy.eks_cluster.arn # This will add existing AmazonEKSClusterPolicy policy to our EKS cluster role
}

# Node Groups
resource "aws_iam_role" "eks_worker" {
  name               = "eks_worker" # This role will allow EKS workers (basically EC2) to call AssumeRole API to get STS
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_worker" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ])

  role       = aws_iam_role.eks_worker.name # This will add existing above policies to our EKS workers (kubelets) role
  policy_arn = each.value
}