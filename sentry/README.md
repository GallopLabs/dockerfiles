# Sentry

Sentry is a realtime event logging and aggregation platform. It specializes in monitoring errors and extracting all the information needed to do a proper post-mortem without any of the hassle of the standard user feedback loop.

> [github.com/getsentry/sentry](https://github.com/getsentry/sentry)

# About This Image

This is a fork of the official Docker image for [sentry](https://registry.hub.docker.com/_/sentry/).

# Docker Compose

Take Sentry for a test-drive with docker-compose.

Note: You will probably need to update the `SENTRY_URL_PREFIX` in `docker-compose.yml` to match your Docker host.

```
docker-compose build
docker-compose up -d
docker-compose run sentry sentry upgrade
```
