#!/bin/bash

sudo yum update -y

echo "Installing Docker"
sudo amazon-linux-extras install docker -y
sudo yum install -y docker

echo "Stating Docker"
sudo service docker start

echo "Adding docker to group"
sudo usermod -aG docker ec2-user

echo "Stat sonar container"
imageId=$(getSonarImageId)

if [[ -z "$imageId" ]]; then
    echo "image doesn't exist. pulling sonarqube community image"
    docker pull sonarqube:community
    imageId=$(getSonarImageId)
fi
echo "sonar image id: $imageId"
docker run -p 9000:9000 --name "sonar-server" --restart=always "$imageId"



getSonarImageId() {
    imageId=$(docker image ls | grep sonarqube | awk '{print $3}')
    return imageId;
}