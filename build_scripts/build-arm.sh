#!/usr/bin/env sh

REPO=chevellabv
IMAGE=octoprint-klipper
TAG=arm

# Build & push latest
docker build -t ${REPO}/${IMAGE}:${TAG} --pull --no-cache --compress --platform linux/arm64 ../
docker push ${REPO}/${IMAGE}:${TAG}
