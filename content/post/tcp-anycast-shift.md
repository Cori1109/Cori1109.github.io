+++
author = "James Moriarty"
title = "TCP Anycast Shift"
date = "2022-04-10"
description = ""
tags = [
  "tcp",
  "anycast"
]
+++

What happens when the routing changes for a stateful network protocol and arrives at another device?

## Terminology

* TCP is a stateful network protocol.
* Anycast is a network addressing and routing method in which devices share a single destination IP address.

## Symptoms

`tcpdump` from the source illustrates the different behaviours when accessing the destination via regular and anycast IP address. The regular returned the expected flags `[S][.][P.]...[F.]` while anycast returned `[S][.][P]...[R]`. Connection reset was reproducible with:

* Specific origins.
* Larger payload.
* Persistent connections.

## Explanation

To come.
