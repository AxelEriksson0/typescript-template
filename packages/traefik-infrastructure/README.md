# Traefik infrastructure

https://doc.traefik.io/traefik/ - Traefik is an open-source Application Proxy that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and identifies which components are responsible for handling them, and routes them securely.

## Install

- Create Docker network: `docker network create traefik-network`
- `docker compose up -d`
