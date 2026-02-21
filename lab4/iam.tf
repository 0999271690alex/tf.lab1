############################
# IAM Group
############################

resource "aws_iam_group" "group" {
  name = "cmtr-pf5k68pq-iam-group"

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

############################
# IAM Policy
############################

resource "aws_iam_policy" "policy" {
  name = "cmtr-pf5k68pq-iam-policy"

  policy = templatefile("${path.module}/policy.json", {
    bucket_name = "cmtr-pf5k68pq-bucket-1771684355"
  })

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

############################
# IAM Role (EC2 trust)
############################

resource "aws_iam_role" "role" {
  name = "cmtr-pf5k68pq-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

############################
# Attach policy to role
############################

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

############################
# Instance Profile
############################

resource "aws_iam_instance_profile" "instance_profile" {
  name = "cmtr-pf5k68pq-iam-instance-profile"
  role = aws_iam_role.role.name

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}
