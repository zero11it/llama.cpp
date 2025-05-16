#!/bin/sh

docker buildx create --use --platform=linux/arm64,linux/amd64 --name multi-platform-builder

docker buildx inspect --bootstrap
