#!/bin/bash

getSonarImageId() {
    imageId=$(docker image ls | grep sonarqube | awk '{print $3}')
    echo "$imageId"
}

sudo yum update -y

echo "Installing Docker"
sudo amazon-linux-extras install docker -y
sudo yum install -y docker

docker -v

if [[ $? -eq 0 ]]; then
    echo "docker installed successfully"
else
    echo "docker installation failed"
    exit 1
fi

echo "Starting Docker"
sudo service docker start

# sudo systemctl status docker.service

echo "Adding docker to group"
sudo usermod -aG docker ec2-user

echo "Strat sonar container"
imageId=$(getSonarImageId)

if [[ -z "$imageId" ]]; then
    echo "image doesn't exist. pulling sonarqube community image"
    docker pull sonarqube:community
    imageId=$(getSonarImageId)
fi
echo "sonar image id: $imageId"

docker run -d -p 9000:9000 --name "sonar-server" --restart=always "$imageId"
