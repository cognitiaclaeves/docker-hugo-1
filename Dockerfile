FROM alpine:3.4

ARG HUGO_VERSION=0.24.1
ARG HUGO_DOWNLOAD_URL="https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_$HUGO_VERSION"_Linux-64bit.tar.gz
# ARG HUGO_DOWNLOAD_URL="https://github.com/spf13/hugo/releases/download/v$HUGO_VERSION/hugo_"$HUGO_VERSION"_Linux-64bit.tar.gz"
ARG HUGO_DOWNLOAD_FILE_NAME=hugo.tar.gz
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer niclas@mietz.io, cognitiaclaeves@gmail.com
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="MIT" \
    org.label-schema.name="Docker Hugo" \
    org.label-schema.url="https://github.com/cognitiaclaeves/docker-hugo-solidnerd/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/cognitiaclaeves/docker-hugo-solidnerd.git" \
    org.label-schema.vcs-type="Git"

ENV HUGO_USER=hugo \
    HUGO_UID=1000 \
    HUGO_GID=1000 \
    HUGO_HOME=/hugo

RUN addgroup -S $HUGO_USER -g ${HUGO_GID} \
    && adduser -S  \
        -g $HUGO_USER \
        -h $HUGO_HOME \
        -u ${HUGO_UID} \
        $HUGO_USER

RUN apk add --no-cache curl tar \
    &&  curl -L "$HUGO_DOWNLOAD_URL" -o "/tmp/$HUGO_DOWNLOAD_FILE_NAME" \
    &&  tar xvz -C /tmp  -f "/tmp/$HUGO_DOWNLOAD_FILE_NAME"  \
    &&  mv /tmp/hugo /usr/local/bin/hugo \
    &&  apk del curl tar \
    &&  rm -rf /tmp \
    &&  rm -fr /var/cache/apk/*

# &&  mv /tmp/hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo \
USER $HUGO_USER

WORKDIR $HUGO_HOME

EXPOSE 1313
VOLUME  ["$HUGO_HOME"]

ENTRYPOINT ["hugo"]
