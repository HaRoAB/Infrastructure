#!/bin/bash

docker build --tag robonon/runner-image .
docker push robonon/runner-image

docker run \
  --detach \
  --env ORGANIZATION=$ORGANIZATION \
  --env ACCESS_TOKEN=$ACCESS_TOKEN \
  --env ACR_SERVER=$ACR_SERVER \
  --env ACR_NAME=$ACR_NAME \
  --name runner \
  --privileged \
  robonon/runner-image 

  read -p "Press any key to continue... " -n1 -s