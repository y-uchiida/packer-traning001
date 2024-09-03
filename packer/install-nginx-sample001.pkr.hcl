# Nginx をインストールした Amazon Linux 2 の AMI を作成するサンプル

# ビルド対象のAMIを指定する
source "amazon-ebs" "amzn2-nginx" {
  # 出力するAMIの名前
  ami_name = "amazon2-nginx-{{timestamp}}"

  # AWS に接続するプロファイル
  profile = "nirneege"

  # 利用するインスタンスタイプ
  instance_type = "t2.micro"

  # リージョン
  region = "ap-northeast-1"

  # ソースAMI
  source_ami = "ami-031ff5a575101728a"

  # ビルド時に利用するユーザー情報
  ssh_username = "ec2-user"
}

# ビルド内容
build {
  # ビルド対象のAMI を指定
  sources = [
    "source.amazon-ebs.amzn2-nginx"
  ]

  # provision 処理
  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]
  }
}
