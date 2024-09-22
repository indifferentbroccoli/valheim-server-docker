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
