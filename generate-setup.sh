#!/bin/bash

mkdir uaa bookservice orderservice gateway kubernetes

cd uaa
yarn link generator-jhipster
yo jhipster
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../bookservice
yarn link generator-jhipster
yo jhipster
./gradlew -P prod -P prometheus -x test build buildDocker
cd ../gateway
yarn link generator-jhipster
yo jhipster
./gradlew -P prod -P prometheus -x test build buildDocker

