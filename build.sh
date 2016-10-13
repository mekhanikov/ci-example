#!/usr/bin/env bash
#docker pull docker.bintray.io/jfrog/artifactory-oss
#docker run -d --name <CONTAINER_NAME> -p 8081:8081 <VOLUME_MOUNTS> docker.bintray.io/jfrog/artifactory-oss:latest
#docker stop artifactory-4.0.0
#docker create --name=mysql2-data -v /var/lib/mysql private/mysql-simple
#docker rm artifactory-4.0.0
#docker create --name=artifactory-4.0.0-data -v /var/lib/mysql private/mysql-simple

docker run -d --name artifactory-4.1.0 -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:4.1.0
# http://172.17.0.2:8081/artifactory/webapp/#/home
# Username: admin , Password: password .




cd jenkins2-docker
docker build -t jenkins-data -f Dockerfile-data .
docker build -t jenkins2 .

docker run --name=jenkins-data jenkins-data
docker run -p 8080:8080 -p 50000:50000 --name=jenkins-master --volumes-from=jenkins-data -d jenkins2

# To see admin pass:
docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
# enter it to input field.

# Install recomended plugins (?)

# Restart by ressing butin ""
# login: admin / 6e63027e16cb47b58d93f84f69596658 (admin pass from prev step)

docker stop jenkins-master
docker rm jenkins-master
docker run -p 8080:8080 -p 50000:50000 --name=jenkins-master -d jenkins2

docker run jenkinsci/jnlp-slave -url http://127.0.0.1:8080 6afc84b53694451ca2c67f15c516e44d slavename1

docker run jenkinsci/jnlp-slave -url http://127.0.0.1:50000 6afc84b53694451ca2c67f15c516e44d slavename1

Download slave may: 172.17.0.3:8080/jnlpJars/slave.jar
java -jar slave.jar -jnlpUrl http://172.17.0.3:8080/computer/aaa/slave-agent.jnlp -jnlpCredentials admin:6afc84b53694451ca2c67f15c516e44d


---
docker pull evarga/jenkins-slave
---
docker pull jenkinsci/slave
docker run --name=jenkins-slave -d jenkinsci/slave

sudo nano /etc/default/docker
DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 -H tcp://0.0.0.0:2376"
sudo restart docker
docker -H tcp://127.0.0.1:2376 ps

To install gitlab
https://github.com/sameersbn/docker-gitlab
wget https://raw.githubusercontent.com/sameersbn/docker-gitlab/master/docker-compose.yml
docker-compose up


