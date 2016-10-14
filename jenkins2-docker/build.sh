#!/usr/bin/env bash
docker build -t jenkins-data -f Dockerfile-data .
docker build -t jenkins2 .
