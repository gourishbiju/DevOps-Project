output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "ecr_repo_url" {
  value = aws_ecr_repository.demo.repository_url
}

output "ansible_inventory" {
  value = templatefile("${path.module}/inventory.tpl", {
    ec2_public_ip = aws_instance.app.public_ip
  })
}
