source "amazon-ebs" "app-svr-ami" {
  ami_name      = "webapp-{{timestamp}}"
  instance_type = "t2.micro"
  source_ami    = "ami-031ff5a575101728a"
  ssh_username  = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.app-svr-ami"
  ]
}
