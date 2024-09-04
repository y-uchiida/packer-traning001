locals {
  project = "tastylog"
}

variable "version" {
  type    = string
  default = "1.0.0"
}

source "amazon-ebs" "app-svr-ami" {
  ami_name = "${local.project}-webapp-${var.version}-{{timestamp}}"

  # Packer がAWSにアクセスするための認証情報を設定
  region  = "ap-northeast-1"
  profile = "nirneege"

  # ソースAMI
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  # インスタンスタイプ
  instance_type = "t2.micro"

  # ボリュームの設定
  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 8
  }

  # 配置先のVPCとサブネット
  vpc_id    = "vpc-030efc45a74c84afb"
  subnet_id = "subnet-0a7fc944893cb9f53"

  # セキュリティグループ
  security_group_ids = [
    "sg-0b498e08c1fefb982", # testylog-dev-web-sg
    "sg-0aa0c57da38e6a8b1", # testylog-dev-db-sg
  ]

  # インスタンスプロファイル
  # IAM ロールを指定すると、それをインスタンスプロファイルに関連付けて作成する
  iam_instance_profile = "tastylog-dev-app-iam-role"

  # パブリックIPの自動割り当て
  associate_public_ip_address = true

  # SSH 接続情報
  ssh_username         = "ec2-user"
  ssh_keypair_name     = "tastylog-dev-keypair"        # キーペア名
  ssh_private_key_file = "../tastylog-dev-keypair.pem" # プライベートキーのファイルパス(Git にコミットしないように注意)
  ssh_interface        = "public_ip"                   # 接続先のIPアドレスを指定

  tags = {
    Name          = "${local.project}-app-ami"
    Version       = var.version
    SourceAmiID   = "{{.SourceAMI}}"
    SourceAmiName = "{{.SourceAMIName}}"
  }
}

build {
  sources = [
    "source.amazon-ebs.app-svr-ami"
  ]

  provisioner "file" {
    source      = "../data/tastylog_light-1.0.0.tar.gz"
    destination = "/tmp/"
  }

  provisioner "shell" {
    scripts = [
      "./scripts/install-tastylog-app.sh",
    ]
  }
}
