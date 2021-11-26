# jumpserver-docker
# => 一站式安装 jumpserver (基于sqlite)

## => 1、克隆代码
```
yum install -y git  || apt install git -y
git clone https://github.com/purplegrape/jumpserver-docker
cd jumpserver-docker
```

## => 2、修改 Dockerfile 中的版本号，并构建docker镜像  
```
docker build -t jumpserver .  
```
## => 3、运行docker  
```
docker run -d --privileged -e "container=docker" -p 80:80 jumpserver  
```
  
## => 4、测试
```
echo -e "at your own risk"  
```  
