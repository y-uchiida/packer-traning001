#!/bin/bash

# 転送したアーカイブ を展開
cd /tmp
mkdir tastylog
tar xvf tastylog_light-1.0.0.tar.gz -C tastylog
# インストールスクリプトを実行
sudo sh /tmp/tastylog/install.sh
# アーカイブとその展開したファイルを削除
rm -rf /tmp/tastylog
rm -f /tmp/tastylog_light-1.0.0.tar.gz
