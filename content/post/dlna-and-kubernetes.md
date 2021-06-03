+++
author = "James Moriarty"
title = "DLNA and Kubernetes"
date = "2021-06-03"
description = ""
tags = [
  "kubernetes",
  "dlna"
]
+++

[Digital Living Network Alliance][1] (DLNA) is derived from [Universal Plug and Play][2] (UPnP) specifically for the purpose of media interoperability. DLNA is advertised and discovered via [Simple Service Discovery Protocol ][3] (SSDP).

[1]: https://en.wikipedia.org/wiki/Digital_Living_Network_Alliance
[2]: https://en.wikipedia.org/wiki/Universal_Plug_and_Play
[3]: https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol

We can see the SSDP port in our DLNA Deployment Kubernetes manifest.

```
ports:
- containerPort: 1900
  hostPort: 1900
  protocol: UDP
```

Lets have a look at a working interactions from the service with `tshark`:

```
sudo tshark -i eno1  -f "udp port 1900"
Capturing on 'eno1'
   ...
   12 10.641536725 192.168.0.85 → 239.255.255.250 SSDP 169 M-SEARCH * HTTP/1.1
   13 10.643129842 192.168.0.211 → 192.168.0.85 SSDP 404 HTTP/1.1 200 OK
```

For context:

- 192.168.0.85 DLNA client.
- 192.168.0.211 DLNA server.
- 239.255.255.250 SSDP multicast address.

If we run `tshark` with `-T pdml` to examine the contents of the interaction the server - we will see an advertised http endpoint. 

```
http://192.168.0.211:8200/rootDesc.xml
```

You also discover the expected endpoints with `nmap`.

```
nmap sU -p 1900 --script=upnp-info 192.168.0.0/24
Starting Nmap 7.80 ( https://nmap.org ) at 2021-06-03 13:11 UTC
Nmap scan report for mymodem.modem (192.168.0.1)
Host is up (0.0045s latency).

PORT     STATE SERVICE
1900/udp open  upnp
| upnp-info:
| 192.168.0.1
|     Server: Homeware UPnP/1.1
|_    Location: http://192.168.0.1:5000/rootDesc.xml
MAC Address: D4:35:1D:14:F3:FE (Technicolor)
```

The client utilize this endpoint to programatically interact this server. 

```
ports:
- containerPort: 8200
  hostPort: 8200
  protocol: TCP
```

This coinsides with another post exposed in our manifest. To enable the SSDP interaction on Kubernetes I had to run the container with hostNetwork. Pod traffic of this nature is generally not able to leave the pod network. This often enfored with node ip tables.

```
hostNetwork: true
```

To avoid node post conflicts the pod spec needs to use a recreate strategy.

```
replicas: 1
strategy:
  type: Recreate
```
