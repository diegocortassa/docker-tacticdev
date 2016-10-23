#! /bin/bash
TIMESTAMP=`date +%Y-%m-%d`
alias docker='sudo docker'
sed -i "s/ENV REFRESHED_AT .*$/ENV REFRESHED_AT $TIMESTAMP/" Dockerfile
docker build -t diegocortassa/tacticdev .
docker push diegocortassa/tacticdev
