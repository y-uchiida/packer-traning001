# Packer の設定ブロック
packer {
  # 依存パッケージの指定
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    goss = {
      version = "~> 3"
      source  = "github.com/YaleUniversity/goss"
    }
  }
}
