# resource "aws_instance" "ec2_instance" {
#     count = var.environment == "PROD" ? 3 : 1
#     ami = lookup(var.ec2_ami, var.aws_region)
#     instance_type = "t2.micro"
#     key_name = var.key
#     security_groups = [ aws_security_group.SG.id ]
#     subnet_id = element(aws_subnet.public[*].id, count.index) 
     
#     tags = {
#       "Name" = "anil_instance"
#       "ENV"  = "PROD"
#     }
#     user_data = <<-eof
#         #!/bin/bash
#         sudo apt update -y
#         sudo apt install -y openjdk-8-jdk
#         sudo apt install nginx -y 
#     eof
# }