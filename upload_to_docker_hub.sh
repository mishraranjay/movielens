#!/bin/bash
set -e

# Hardcoded image details
IMAGE_NAME="db2-csv-loader"
IMAGE_TAG="latest"

# Prompt for Docker Hub credentials
read -p "🔑 Docker Hub Username: " DOCKER_USERNAME
read -s -p "🔒 Docker Hub Password: " DOCKER_PASSWORD
echo ""

# Construct full image name
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

echo "🔐 Logging into Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "☁️  Pushing image to Docker Hub..."
docker push "$FULL_IMAGE_NAME"

echo "✅ Docker image successfully pushed: $FULL_IMAGE_NAME"
