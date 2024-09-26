#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libatomic1=12.2.0-14 \
    libpulse-dev=16.1+dfsg1-2+b1 \
    unzip \
    wget \
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
    SERVER_PASSWORD=CHANGEME \
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
    MODIFIER_PORTALS= \
    NO_MAP=false \
    PLAYER_EVENTS=false \
    PASSIVE_MOBS=false \
    NO_BUILD_COST=false \
    BEPINEX_ENABLED=false

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /valheim /valheim-saves && \
    chmod +x /home/steam/server/*.sh

# Install BepInExPack
ENV BEPINEXPACK_VERSION=5.4.2202
RUN wget -q https://gcdn.thunderstore.io/live/repository/packages/denikson-BepInExPack_Valheim-"${BEPINEXPACK_VERSION}".zip -O /tmp/BepInExPack_Valheim.zip && \
    unzip -q /tmp/BepInExPack_Valheim.zip -d /home/steam/server/BepInEx && \
    rm /tmp/BepInExPack_Valheim.zip

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "valheim_server" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]