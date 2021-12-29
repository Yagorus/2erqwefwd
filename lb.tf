

resource "aws_lb" "main" {
  name            = "${var.app_name}-${var.environment}-lb"
  subnets         = [for subnet in aws_subnet.public : subnet.id]
  security_groups = [aws_security_group.lb.id]
  load_balancer_type = "application"

}

resource "aws_alb_target_group" "app" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.app"]  
  listener_arn = aws_alb_listener.front_end.arn  
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.app.id}"  
  }   
  condition {
    path_pattern {
      values = ["/"]
    
    }        
  }
}