# syntax=docker/dockerfile:1

# Runtime Stage
FROM ghcr.io/linuxserver/baseimage-selkies:arch

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CLION_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV TITLE="CLion" \
    NO_GAMEPAD="true" \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.svg \
    https://upload.wikimedia.org/wikipedia/commons/6/62/Clion.svg && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm \
   caja \
   "clion${CLION_VERSION:+=$CLION_VERSION}" && \
  echo "**** cleanup ****" && \
  printf \
    "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" \
    > /build_version && \
  pacman -Scc --noconfirm && \
  rm -rf \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files and files from buildstage
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 3001
