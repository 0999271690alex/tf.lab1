resource "aws_lb_target_group" "blue" {
  name     = "cmtr-pf5k68pq-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_lb_target_group" "green" {
  name     = "cmtr-pf5k68pq-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_lb" "main" {
  name               = "cmtr-pf5k68pq-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    data.aws_subnet.public1.id,
    data.aws_subnet.public2.id
  ]

  security_groups = [data.aws_security_group.lb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = var.blue_weight
      }

      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = var.green_weight
      }
    }
  }
}
