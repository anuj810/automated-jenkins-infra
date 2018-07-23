#variable "ami_id" {}      

provider "aws" { 
  region = "us-east-1"
  }
/*
resource "aws_key_pair" "key" {
    key_name   = "instance-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmRdoqX5KJ41b/u+TcjoKvBFDLtjxVjgWElku8BPyE2Hjke6he8vVOr4qVlvA/ZW6W4Dze0/yOkHSWRpnIjseOEOz3ArRl7MFREFVr96NVcYDtbhMxNpKAnOQ2l23YpLxyZDKpPleiDNxjgVc3rpWKqtb3rVFwy7YEIkRpuEaQ2I8IiRIYAOHYfPB8Y/G4KNMWIy5CESmkJSkZlg7dfuvAAdBYOTws8FSdEMGBwhD8XJsZo5f/RQTmt3HgVoIK63vtfH/vFlRaJx3tCJwymuLIuiPmM18yb4bVEWsAgUA6oWVYssI6+NBccLBGkzpbviyq9lp+Vx64wN3iKYZyM821w== rsa-key-20180606"
    } 
*/
resource "aws_instance" "master" {
    ami = "ami-2d39803a" 
    instance_type = "t2.medium"
    key_name ="instance-key"
    root_block_device {
        volume_size = 30
    }
  
  provisioner "file" {
    source      = "master_operations.sh"
    destination = "/tmp/operations.sh"

   connection {
       user = "ubuntu"
       private_key = "${file("./key.pem")}"
       timeout = "1m"
        }    
    }

  provisioner "remote-exec" {  
    inline = [
       "chmod +x /tmp/operations.sh",
       "/tmp/operations.sh",
       ]  
    connection {
       user = "ubuntu"
       private_key = "${file("./key.pem")}"
       timeout = "1m"
        }                                                                                                                                                                     }
    }

output "ip" { 
    value = "${aws_instance.master.public_ip}"
    }

