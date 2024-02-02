output "webserver_ip" {
  value = aws_eip.eip_my_webserver.public_ip
}
