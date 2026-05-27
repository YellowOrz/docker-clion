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
  echo "**** install clion ****" && \
  case "$(uname -m)" in \
    aarch64|arm64) CLION_DOWNLOAD_KEY="linuxARM64"; CLION_ARCH_SUFFIX="-aarch64" ;; \
    x86_64|amd64) CLION_DOWNLOAD_KEY="linux"; CLION_ARCH_SUFFIX="" ;; \
    *) echo "Unsupported architecture: $(uname -m)" && exit 1 ;; \
  esac && \
  if [ -n "${CLION_VERSION}" ]; then \
    CLION_URL="https://download.jetbrains.com/cpp/CLion-${CLION_VERSION}${CLION_ARCH_SUFFIX}.tar.gz"; \
  else \
    CLION_URL="$(curl -fsSL 'https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=release' \
      | grep -oE "\"${CLION_DOWNLOAD_KEY}\":\{\"link\":\"https://download\.jetbrains\.com/cpp/CLion-[^\"]+\.tar\.gz\"" \
      | sed -E 's/.*"link":"([^"]+)".*/\1/')"; \
  fi && \
  mkdir -p /opt/clion && \
  curl -fsSL "${CLION_URL}" \
    | tar -xz -C /opt/clion --strip-components=1 && \
  ln -sf /opt/clion/bin/clion /usr/bin/clion  && \
  echo "**** add icon ****" && \
  install -Dm644 /opt/clion/bin/clion.svg \
    /usr/share/icons/hicolor/scalable/apps/clion.svg && \
  cp /opt/clion/bin/clion.png /usr/share/selkies/www/icon.png && \
  echo "**** install packages ****" && \
  pacman -Sy --noconfirm caja git base-devel && \
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
