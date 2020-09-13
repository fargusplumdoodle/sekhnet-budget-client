#!/bin/bash
echo build flutter
flutter build web
echo serving with nginx
echo TODO: make docker container from CI
docker run --rm -it -v `realpath build/web`:/usr/share/nginx/html nginx
