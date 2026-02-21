# 1. IAM Group
resource "aws_iam_group" "group" {
  name = "cmtr-pf5k68pq-iam-group"
}

# 2. IAM Policy (використання templatefile)
resource "aws_iam_policy" "policy" {
  name        = "cmtr-pf5k68pq-iam-policy"
  description = "Policy for S3 write access"
  policy      = templatefile("policy.json", { bucket_name = var.bucket_name })

  tags = {
    Project = var.project_tag
  }
}

# 3. IAM Role + Trust Relationship (EC2)
resource "aws_iam_role" "role" {
  name = "cmtr-pf5k68pq-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = var.project_tag
  }
}

# 4. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

# 5. Instance Profile
resource "aws_iam_instance_profile" "profile" {
  name = "cmtr-pf5k68pq-iam-instance-profile"
  role = aws_iam_role.role.name

  tags = {
    Project = var.project_tag
  }
}
