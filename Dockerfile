#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libatomic1=12.2.0-14 \
    libpulse-dev=16.1+dfsg1-2+b1 \
    libpulse0=16.1+dfsg1-2+b1 \
    libc6=2.36-9+deb12u8 \
    gettext-base=0.21-12 \
    procps=2:4.0.2-3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/projectzomboid-server-docker" \
      github="https://github.com/indifferentbroccoli/projectzomboid-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/projectzomboid-server-docker"

ENV HOME=/home/steam \
    PORT=2456 \
    SERVER_NAME=valheim \
    SERVER_PASSWORD=secret \
    CROSSPLAY_ENABLED=true \
    WORLD_NAME=dedicated \
    PUBLIC=true \
    SAVE_DIR=/valheim-saves \
    SAVE_INTERVAL=1800 \
    KEEP_BACKUPS=4 \
    BACKUPS_SHORT=7200 \
    BACKUPS_LONG=43200 \
    SERVER_PRESET=Normal \
    MODIFIER_COMBAT= \
    MODIFIER_DEATH= \
    MODIFIER_RESOURCES= \
    MODIFIER_RAIDS= \
    MODIFIER_PORTALS=

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /valheim /valheim-saves && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "valheim_server" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]