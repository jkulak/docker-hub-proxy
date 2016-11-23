#!/usr/bin/env bash

docker push jkulak/docker-hub-proxy

ssh -oStrictHostKeyChecking=no deploy@$DEPLOY_HOST << EOF

    docker pull jkulak/docker-hub-proxy:latest
    docker stop docker-hub-proxy || true
    docker rm docker-hub-proxy || true
    docker rmi jkulak/docker-hub-proxy:current || true
    docker tag jkulak/docker-hub-proxy:latest jkulak/docker-hub-proxy:current
    docker run -d --restart always --name docker-hub-proxy -p 80:80 jkulak/docker-hub-proxy:current
EOF
