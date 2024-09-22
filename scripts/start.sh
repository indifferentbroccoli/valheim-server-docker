#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

cd /valheim || exit

# If CROSSPLAY_ENABLED is set to true, add -crossplay to the server start command
if [ "${CROSSPLAY_ENABLED}" = "true" ]; then
    CROSSPLAY="-crossplay"
else
    CROSSPLAY=""
fi

# If PUBLIC_ENABLED is set to true set the server public variable to 1
if [ "${PUBLIC_ENABLED}" = "true" ]; then
    PUBLIC=1
else
    PUBLIC=0
fi

# If there are any modifiers set, add them to the server start command
MODIFIERS=()
# Modifier Combat
if [ -n "${MODIFIER_COMBAT}" ]; then
    MODIFIERS+=("-modifier combat ${MODIFIER_COMBAT}")
fi
# Modifier Deathpenalty
if [ -n "${MODIFIER_DEATH}" ]; then
    MODIFIERS+=("-modifier deathpenalty ${MODIFIER_DEATH}")
fi
# Modifier Resources
if [ -n "${MODIFIER_RESOURCES}" ]; then
    MODIFIERS+=("-modifier resources ${MODIFIER_RESOURCES}")
fi
# Modifier Raid
if [ -n "${MODIFIER_RAIDS}" ]; then
    MODIFIERS+=("-modifier raids ${MODIFIER_RAIDS}")
fi
# Modifier Portals
if [ -n "${MODIFIER_PORTALS}" ]; then
    MODIFIERS+=("-modifier portals ${MODIFIER_PORTALS}")
fi



LogAction "Starting server"
set -x
set -e
./valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -port "${PORT}" \
    -world "${WORLD_NAME}" \
    -password "$SERVER_PASSWORD" \
    -savedir "${SAVE_DIR}" \
    -public "${PUBLIC}"  \
    -saveinterval "${SAVE_INTERVAL}" \
    -backups "${KEEP_BACKUPS}" \
    -backupshort "${BACKUPS_SHORT}" \
    -backuplong "${BACKUPS_LONG}" \
    "${CROSSPLAY}" \
    -preset "${SERVER_PRESET}" \
    "${MODIFIERS[*]}" \
    -nographics \
    -batchmode