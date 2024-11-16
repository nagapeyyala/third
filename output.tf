output "instance_public_ip" { 
       description = "The public ip address of the EC2 instance"
       value = aws_instance.terraform1.public_ip
}
