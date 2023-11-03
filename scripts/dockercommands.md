IMAGE=fitnessapp
TAG=latest
REPOSITORY=robonon

docker build -t fitnessapp:latest .
docker run -d -p 8080:80 --name FitnessApp fitnessapp:latest

// Login to docker repo
docker login <repo-url>

// Build and push image to repo
docker build -t $IMAGE:$TAG .
docker push $REPOSITORY/$IMAGE:$TAG

// Kill container
docker kill <container-name>

// Clear stopped containers
docker container prune