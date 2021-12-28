output "web_lb_url" {
    value = aws_elb.main.dns_name
}