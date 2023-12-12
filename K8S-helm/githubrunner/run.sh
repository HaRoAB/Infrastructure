#!/bin/bash

docker build --tag runner-image .

docker run \
  --detach \
  --env ORGANIZATION=$ORGANIZATION \
  --env ACCESS_TOKEN=$ACCESS_TOKEN \
  --name runner \
  --privileged \
  runner-image 

  read -p "Press any key to continue... " -n1 -s