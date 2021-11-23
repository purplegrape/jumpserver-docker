# jumpserver-docker
# => 一站式安装 jumpserver

## => 1、准备外部mysql 数据库 ( mysql版本 >=5.7 )
```
create database jumpserver
grant all on jumpserver.* to jumpserver@'10.0.0.%' identified by 'We9eizah7ooch0boaj1ohhahch9kohri';
flush privileges;
```
## => 2、克隆代码
```
yum install -y git  || apt install git -y
git clone https://github.com/purplegrape/jumpserver-docker
cd jumpserver-docker
```
## => 3、修改数据链接，配置文件 jumpserver.config.yml  
```
DB_ENGINE: mysql
DB_HOST: 10.0.0.2
DB_PORT: 3306
DB_USER: jumpserver
DB_PASSWORD: We9eizah7ooch0boaj1ohhahch9kohri
DB_NAME: jumpserver
```
## => 4、设置 SECRET_KEY 和 BOOTSTRAP_TOKEN ，详见：
```
jumpserver.config.yml  
koko.config.yml
lion.config.yml
```
## => 5、修改 Dockerfile 中的版本号，并构建docker镜像  
```
docker build -t jumpserver:latest .  
```
## => 6、运行docker  
```
docker run -d --privileged -e "container=docker" jumpserver:latest
```
  
## => 7、测试
```
echo -e "at your own risk"  
```  
