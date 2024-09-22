<!-- markdownlint-disable-next-line -->
![marketing_assets_banner](https://github.com/user-attachments/assets/b8b4ae5c-06bb-46a7-8d94-903a04595036)
[![GitHub License](https://img.shields.io/github/license/indifferentbroccoli/valheim-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/valheim-server-docker/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/indifferentbroccoli/valheim-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/valheim-server-docker/releases)
[![GitHub Repo stars](https://img.shields.io/github/stars/indifferentbroccoli/valheim-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/valheim-server-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/indifferentbroccoli/valheim-server-docker?style=for-the-badge&color=6aa84f)](https://hub.docker.com/r/indifferentbroccoli/valheim-server-docker)

Game server hosting

Fast RAM, high-speed internet

Eat lag for breakfast

[Try our valheim Server hosting free for 2 days!](https://indifferentbroccoli.com/valheim-server-hosting)

# Valheim Server Docker

## Server Requirements

| Resource | Minimum                              | Recommended                             |
|----------|--------------------------------------|-----------------------------------------|
| CPU      | Quad-Core Processor 2.8GHz (4 Cores) | Hexa-Core Processor 3.4GHz+ (6 Cores)   |
| RAM      | 2GB                                  | Recommend over 4GB for stable operation |
| Storage  | 2GB                                  | 4GB+                                    |

## How to use

Copy the .env.example file to a new file called .env file. Then use either `docker compose` or `docker run`

> [!IMPORTANT]
> Please make sure to change the following in the .env:
> SERVER_PASSWORD

### Docker compose

Starting the server with Docker Compose:

```yaml
services:
  valheim:
    image: indifferentbroccoli/valheim-server-docker
    restart: unless-stopped
    container_name: valheim
    stop_grace_period: 30s
    ports:
      - '2456:2456/udp'
      - '2457:2457/udp'
    environment:
      PUID: 1000
      PGID: 1000
    env_file:
      - .env
    volumes:
      - ./valheim/server-files:/valheim
      - ./valheim/server-data:/valheim-saves
```

Then run:

```bash
docker-compose up -d
```

### Docker Run

```bash
docker run -d \
    --restart unless-stopped \
    --name valheim \
    --stop-timeout 30 \
    -p 2456:2456/udp \
    -p 2457:2457/udp \
    --env-file .env \
    -v ./valheim/server-files:/valheim \
    -v ./valheim/server-data:/valheim-saves
    indifferentbroccoli/valheim-server-docker
```

## Environment Variables

| Variable           | Description                                                                                                                                                                                                                                 | Default Value |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| PORT               | Choose the Port which you want the server to communicate with. Please note that this has to correspond with the Port Forwarding settings on your Router. Valheim uses the specified Port AND specified Port+1. Default Ports are 2456-2457. | 2456          |
| SERVER_NAME        | the name of your server that will be visible in the Server list.                                                                                                                                                                            | valheim       |
| SERVER_PASSWORD    | The password for the server                                                                                                                                                                                                                 | secret        |
| CROSSPLAY_ENABLED  | Runs the Server on the Crossplay backend (PlayFab), which lets users from any platform join.                                                                                                                                                | true          |
| WORLD_NAME         | A World with the name entered will be created. You may also choose an already existing World by entering its name.                                                                                                                          | dedicated     |
| PUBLIC             | Set the visibility of your server. true is default and will make the server visible in the browser. Set it to false to make the server invisible and only joinable via the ‘Join IP’-button.                                                | true          |
| SAVE_INTERVAL      | Change how often the world will save in seconds.                                                                                                                                                                                            | 1800          |
| KEEP_BACKUPS       | Sets how many automatic backups will be kept. The first is the ‘short’ backup length, and the rest are the ‘long’ backup length. By default that means one backup that is 2 hours old, and 3 backups that are 12 hours apart.               | 4             |
| BACKUPS_SHORT      | Sets the interval between the first automatic backups in seconds.                                                                                                                                                                           | 7200          |
| BACKUPS_LONG       | Sets the interval between the subsequent automatic backups in seconds.                                                                                                                                                                      | 43200         |
| SERVER_PRESET      | Sets world modifier preset. Setting a preset will overwrite any other previous modifiers. Valid values are: Normal, Casual, Easy, Hard, Hardcore, Immersive, Hammer.                                                                        | Normal        |
| MODIFIER_COMBAT    | Sets chosen world modifier with value. If combined with a preset should be set after. Valid modifiers and values are: veryeasy, easy, hard, veryhard                                                                                        |               |
| MODIFIER_DEATH     | Sets chosen world modifier with value. If combined with a preset should be set after. Valid modifiers and values are: casual, veryeasy, easy, hard, hardcore                                                                                |               |
| MODIFIER_RESOURCES | Sets chosen world modifier with value. If combined with a preset should be set after. Valid modifiers and values are: muchless, less, more, muchmore, most                                                                                  |               |
| MODIFIER_RAIDS     | Sets chosen world modifier with value. If combined with a preset should be set after. Valid modifiers and values are: none, muchless, less, more, muchmore                                                                                  |               |
| MODIFIER_PORTALS   | Sets chosen world modifier with value. If combined with a preset should be set after. Valid modifiers and values are: casual, hard, veryhard                                                                                                |               |

## Developer information

### Building the image

You can build the image from the Dockerfile using the following command:

```bash
docker build -t indifferentbroccoli/valheim-server-docker .
```

### Scripts

#### init.sh

Entrypoint of the container. This script will check if the server is installed and if not, it will install it.
Also has a term_handler function to catch SIGTERM/SIGINT signals to gracefully stop the server.
Features basic checks that will confirm if the server can be started.

#### start.sh

Starts the server with the settings from the .env file.
Will also call the compile-settings.sh script to generate the server settings.

#### install.scmd

Installs the server. This script will download the server files using SteamCMD and extract them to the server directory.

#### funtions.sh

Contains functions that are used in the other scripts.
