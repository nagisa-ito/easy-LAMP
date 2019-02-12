# easy-LAMP
かんたん環境構築

### 開発環境
- __Docker for Mac__
- CentOS 6.9
- CakePHP 2.4
- PHP 5.6
- MySQL 5.6
- apache 2.2.15

### 構築方法
#### Dockerインストール
https://docs.docker.com/docker-for-mac/
#### Docker Composeインストール
http://docs.docker.jp/compose/install.html
#### クローン & コンテナ作成
```
$ git clone https://github.com/nagisa-ito/easy-LAMP.git
$ cd easy-LAMP
$ docker-compose build
$ docker-compose up -d
```
