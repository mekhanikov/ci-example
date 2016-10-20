#!/usr/bin/env bash
docker build -t jenkins-data -f Dockerfile-data .
docker build -t jenkins2 .


docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

git clone ssh://git@localhost:10022/root/mod-a.git

git clone ssh://git@ciinfraexaple_gitlab_1:22/root/mod-a.git