# Create IAM user to be used for EKS cluster creation (avoid root user)
resource "aws_iam_user" "eks_user" {
  name = "eks-admin-user"
}

# Attach AWS managed policies
resource "aws_iam_user_policy_attachment" "ec2_full_access" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "eks_cni_policy" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_user_policy_attachment" "eks_cluster_policy" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_user_policy_attachment" "eks_worker_node_policy" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_user_policy_attachment" "cloudformation_full_access" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_user_policy_attachment" "iam_full_access" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Inline policy for full EKS access
resource "aws_iam_user_policy" "eks_inline_policy" {
  name = "EKSFullAccessInline"
  user = aws_iam_user.eks_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "eks:*",
        Resource = "*"
      }
    ]
  })
}
