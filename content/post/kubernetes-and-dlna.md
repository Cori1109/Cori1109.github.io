+++
author = "James Moriarty"
title = "Kubernetes and DLNA"
date = "2021-06-03"
description = ""
aliases = ["dlna and kubernetes"]
tags = [
  "kubernetes",
  "dlna"
]
+++

These are some notes taken while deploying a [Digital Living Network Alliance][1] (DLNA) to Kubernetes. DLNA is derived from [Universal Plug and Play][2] (UPnP) specifically for media interoperability. DLNA services are advertised and discovered via [Simple Service Discovery Protocol ][3] (SSDP). 

Take the follow DLNA interaction:

![DLNA M-SEARCH Interaction diagram](/images/kubernetes-and-dlna.drawio.svg)

Let’s have a look at a captured interaction with `tshark`.

```
sudo tshark -i eno1  -f "udp port 1900"
Capturing on 'eno1'
   ...
   12 10.641536725 192.168.0.85 → 239.255.255.250 SSDP 169 M-SEARCH * HTTP/1.1
   13 10.643129842 192.168.0.211 → 192.168.0.85 SSDP 404 HTTP/1.1 200 OK
```

We can see the SSDP port in our DLNA Deployment Kubernetes manifest.

```
ports:
- containerPort: 1900
  hostPort: 1900
  protocol: UDP
```

If we run `tshark` with `-T pdml` to examine the contents of the interaction the server - we will see an advertised http endpoint.

```
http://192.168.0.211:8200/rootDesc.xml
```

You also discover the advertised endpoints with `nmap`.

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

The endpoint enables programmatic interaction between client and server. This coincides with another port exposed in our manifest.

```
ports:
- containerPort: 8200
  hostPort: 8200
  protocol: TCP
```

Enabling the SSDP interaction on Kubernetes required the DLNA server pod to be run with `hostNetwork`.

```
hostNetwork: true
```

Otherwise, you can expect the following issues.

- Blocked pod egress SSDP advertisement.
- Blocked pod ingress SSDP discovery.
- Incorrect advertised enpdoint IP.
- Node port conflicts the deployment spec will needs to use a `Recreate` strategy.

```
replicas: 1
strategy:
  type: Recreate
```

[1]: https://en.wikipedia.org/wiki/Digital_Living_Network_Alliance
[2]: https://en.wikipedia.org/wiki/Universal_Plug_and_Play
[3]: https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
