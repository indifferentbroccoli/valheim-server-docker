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
# If NO_MAPS is set to true, add -setkey nomap to the server start command
if [ "${NO_MAP}" = "true" ]; then
    MODIFIERS+=("-setkey nomap")
fi
# If PLAYER_EVENTS is set to true, add -setkey playerevents to the server start command
if [ "${PLAYER_EVENTS}" = "true" ]; then
    MODIFIERS+=("-setkey playerevents")
fi
# If PASSIVE_MOBS is set to true, add -setkey passivemob to the server start command
if [ "${PASSIVE_MOBS}" = "true" ]; then
    MODIFIERS+=("-setkey passivemobs")
fi
# If NO_BUILD_COST is set to true, add -setkey nobuildcost to the server start command
if [ "${NO_BUILD_COST}" = "true" ]; then
    MODIFIERS+=("-setkey nobuildcost")
fi

LogAction "Starting server"

# remove double quotes from the modifiers array
MODIFIERS=("${MODIFIERS[@]//\"}")

if [ "${BEPINEX_ENABLED}" = true ]; then
    LogInfo "BepInEx is enabled, starting server with BepInEx"
    cp -rf /home/steam/server/BepInEx/BepInExPack_Valheim/* /valheim
    export DOORSTOP_ENABLE=TRUE
    export DOORSTOP_INVOKE_DLL_PATH="./BepInEx/core/BepInEx.Preloader.dll"
    export DOORSTOP_CORLIB_OVERRIDE_PATH="./unstripped_corlib"
    export LD_LIBRARY_PATH="./doorstop_libs:$LD_LIBRARY_PATH"
    export LD_PRELOAD="libdoorstop_x64.so:$LD_PRELOAD"
    export LD_LIBRARY_PATH="./linux64:$LD_LIBRARY_PATH"
fi

# shellcheck disable=SC2068
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
    ${MODIFIERS[@]} \
    -nographics \
    -batchmode
