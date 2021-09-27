#! /bin/bash
TIMESTAMP=`date +%Y-%m-%d`
sed -i "s/ENV REFRESHED_AT .*$/ENV REFRESHED_AT $TIMESTAMP/" Dockerfile
sudo docker build -t diegocortassa/tacticdev .
sudo docker build -t diegocortassa/tacticdev:4.8 .
sudo docker build -t diegocortassa/tacticdev:4.8.0 .
sudo docker push diegocortassa/tacticdev
sudo docker push diegocortassa/tacticdev:4.8
sudo docker push diegocortassa/tacticdev:4.8.0
