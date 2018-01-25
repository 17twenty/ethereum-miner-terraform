output "ip_addresses-light" {
  value = "${join(",", aws_instance.fleet-light.*.public_ip)}"
}

output "ip_addresses-heavy" {
  value = "${join(",", aws_instance.fleet-heavy.*.public_ip)}"
}
