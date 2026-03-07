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
