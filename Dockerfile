#BUILD THE SERVER IMAGE
FROM cm2network/steamcmd:root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libatomic1 \
    libpulse-dev \
    unzip \
    wget \
    libpulse0 \
    libc6 \
    gettext-base \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/valheim-server-docker" \
      github="https://github.com/indifferentbroccoli/valheim-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/valheim-server-docker"

ENV HOME=/home/steam \
    PORT=2456 \
    SERVER_NAME=valheim \
    SERVER_PASSWORD=CHANGEME \
    CROSSPLAY_ENABLED=true \
    WORLD_NAME=dedicated \
    PUBLIC=true \
    MAX_PLAYERS=10 \
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
    BEPINEX_ENABLED=false \
    BEPINEXPACK_VERSION=5.4.2333 \
    MODS_DIR=/opt/valheim-mods \
    BETA=public

ARG MAXPLAYERCOUNT_VERSION=1.2.4
RUN mkdir -p /opt/valheim-mods/MaxPlayerCount && \
    wget -q "https://gcdn.thunderstore.io/live/repository/packages/Azumatt-MaxPlayerCount-${MAXPLAYERCOUNT_VERSION}.zip" -O /tmp/MaxPlayerCount.zip && \
    unzip -q -j /tmp/MaxPlayerCount.zip "MaxPlayerCount.dll" -d /opt/valheim-mods/MaxPlayerCount && \
    echo "${MAXPLAYERCOUNT_VERSION}" > /opt/valheim-mods/MaxPlayerCount/.version && \
    rm /tmp/MaxPlayerCount.zip

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /valheim /valheim-saves && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "valheim_server" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]
