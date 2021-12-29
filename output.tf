
output "web_lb_url" {
    value = aws_lb.main.dns_name
}
