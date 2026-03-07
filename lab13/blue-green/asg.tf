resource "aws_autoscaling_group" "blue" {

  name = "cmtr-pf5k68pq-blue-asg"

  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  target_group_arns = [aws_lb_target_group.blue.arn]

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "green" {

  name = "cmtr-pf5k68pq-green-asg"

  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  target_group_arns = [aws_lb_target_group.green.arn]

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }
}
