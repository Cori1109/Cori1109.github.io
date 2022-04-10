+++
author = "James Moriarty"
title = "Docker and DLNA"
date = "2022-04-10"
description = ""
tags = [
  "docker",
  "dlna",
  "ssdp",
  "macvlan"
]
+++

I've recently discovered the Docker network [macvlan](https://dockerlabs.collabnix.com/intermediate/macvlan.html) driver.

> It’s a very lightweight driver, because rather than using any Linux bridging or port mapping, it connects container interfaces directly to host interfaces. Containers are addressed with routable IP addresses that are on the subnet of the external network.

This is a more constrained alternative to the Docker network `host` driver.

> As a result of routable IP addresses, containers communicate directly with resources that exist outside a Swarm cluster without the use of NAT and port mapping. This can aid in network visibility and troubleshooting. 

This characteristic is useful for Digital Living Network Alliance (DLNA) / Simple Service Discovery Protocol (SSDP). These workloads utilize service advertisement and discover via UDP multicast and UHTTP.

## Example

This workload is a port of my Kubrenetes to `docker-compose.yml` utilizing the [macvlan](https://dockerlabs.collabnix.com/intermediate/macvlan.html) network driver that previously used `host` driver.

```
version: "3.3"

services:
  minidlna:
    networks:
      lan:
        ipv4_address: "${NETWORK_DLNA_IP}"
    restart: always
    image: "vladgh/minidlna:1.2.0"
    environment:
      - "PUID=1000"
      - "PGID=1000"
      - "MINIDLNA_MEDIA_DIR=/media"
    volumes:
      - "./data:/media:ro"

networks:
  lan:
    driver: macvlan
    driver_opts:
      parent: "${NETWORK_ADAPTER}"
    ipam:
      config:
        - subnet: "${NETWORK_SUBNET}"
```

The corresponding `.env` file.

```
NETWORK_SUBNET=192.168.0.1/24
NETWORK_ADAPTER=eno1
NETWORK_DLNA_IP=192.168.0.212
```