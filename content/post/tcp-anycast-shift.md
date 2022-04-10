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

The first symptoms were apparent after adding Anycast an existing destination. `tcpdump` illustrated the different behaviours. The original destination worked as expected, returning the flags`[S][.][P.]...[F.]` while Anycast returned `[S][.][P]...[R]`. Connection reset only resulted with:

* Larger payload or persistent connections.
* Specific origin connections.

What was happening? Time to introduce Anycast Shift.

## Terminology

* TCP is a stateful network protocol.
* Anycast is a network addressing and routing method in which devices share a single destination IP address.
