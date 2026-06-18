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
    LogInfo "BepInEx is enabled..."

    VERSION=${BEPINEXPACK_VERSION:-5.4.2333}

    if [ ! -d "/valheim/BepInEx" ]; then
        LogInfo "Downloading BepInExPack_Valheim version ${VERSION}..."
        if ! wget -q "https://gcdn.thunderstore.io/live/repository/packages/denikson-BepInExPack_Valheim-${VERSION}.zip" -O /tmp/BepInExPack.zip; then
            LogError "Failed to download BepInExPack_Valheim version ${VERSION}. Check that BEPINEXPACK_VERSION is a valid release."
            exit 1
        fi
        if ! unzip -q /tmp/BepInExPack.zip -d /tmp/BepInExPack; then
            LogError "Failed to extract BepInExPack_Valheim."
            rm -f /tmp/BepInExPack.zip
            rm -rf /tmp/BepInExPack
            exit 1
        fi
        rm /tmp/BepInExPack.zip
        cp -rf /tmp/BepInExPack/BepInExPack_Valheim/* /valheim
        rm -rf /tmp/BepInExPack
        echo "${VERSION}" > /valheim/.bepinex_version
    fi

    # Read installed version
    if [ -f "/valheim/.bepinex_version" ]; then
        INSTALLED_VERSION=$(cat /valheim/.bepinex_version)
    else
        # No marker = legacy install
        INSTALLED_VERSION="5.4.22.0"
    fi

    export LD_LIBRARY_PATH="./doorstop_libs:$LD_LIBRARY_PATH"
    export LD_PRELOAD="libdoorstop_x64.so:$LD_PRELOAD"
    export LD_LIBRARY_PATH="./linux64:$LD_LIBRARY_PATH"

    # BepInEx 5.4.22xx uses old doorstop env vars; 5.4.23xx+ uses new ones
    if [[ "${INSTALLED_VERSION}" == 5.4.22* ]]; then
        export DOORSTOP_ENABLE=TRUE
        export DOORSTOP_INVOKE_DLL_PATH=./BepInEx/core/BepInEx.Preloader.dll
        export DOORSTOP_CORLIB_OVERRIDE_PATH=./unstripped_corlib
    else
        export DOORSTOP_ENABLED=1
        export DOORSTOP_TARGET_ASSEMBLY="./BepInEx/core/BepInEx.Preloader.dll"
    fi
fi

# shellcheck disable=SC2068
./valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -port "${PORT}" \
    -world "${WORLD_NAME}" \
    -password "$SERVER_PASSWORD" \
    -savedir "${SAVE_DIR}" \
    -public "${PUBLIC}"  \
    -maxplayers "${MAX_PLAYERS}" \
    -saveinterval "${SAVE_INTERVAL}" \
    -backups "${KEEP_BACKUPS}" \
    -backupshort "${BACKUPS_SHORT}" \
    -backuplong "${BACKUPS_LONG}" \
    "${CROSSPLAY}" \
    -preset "${SERVER_PRESET}" \
    ${MODIFIERS[@]} \
    -nographics \
    -batchmode
