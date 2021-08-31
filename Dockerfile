FROM jnorwood/helm-docs:latest
USER root
RUN apk update
ENTRYPOINT /bin/sh

