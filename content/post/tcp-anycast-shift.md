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

What happens when routing changes for a stateful network protocol and unexpectedly arrives at a device without a session?

## Terminology

* TCP is a stateful network protocol.
* Anycast is a network addressing and routing method in which devices share a single destination IP address.
* Equal-cost multipath is a mechanism to increase bandwidth using parallel links.

## Symptoms

`tcpdump` from the origin illustrates the different behaviors when accessing the destination via regular and anycast IP address. The regular returned the expected flags `[S][.][P.]...[F.]` while anycast returned `[S][.][P.]...[R]`. Where ` [S] (Start Connection)`, `[P] (Push Data)`, `[R] (Reset Connection)`, and `[F] (Finish Connection)`. Connection reset was reproducible with:

* Specific origins.
* Larger payloads.
* Persistent connections.

## Explanation

Take the following interaction diagram illustrates the above and TCP’s stateful nature:

```mermaid
sequenceDiagram
    participant Origin
    participant DestDeviceOne
    participant DestDeviceTwo

    Origin->>DestDeviceOne: SYN=i
    DestDeviceOne-->>Origin: SYN=j, ACK=i+1
    Origin->>DestDeviceOne: ACK=j+1
    Note over Origin,DestDeviceOne: 3-way handshake

    loop
      alt
        Origin->>DestDeviceOne: SEQ=a, ACK=b, DATA=c
        DestDeviceOne-->>Origin: ACK, SEQ=b, ACK=a+c
        Note over Origin,DestDeviceOne: data transfer
      else
        Origin->>DestDeviceTwo: SEQ=a, ACK=b, DATA=c
        DestDeviceTwo-->>Origin: RST
        Note over Origin,DestDeviceTwo: anycast shift
      end
    end

    %%alt
    %%  Origin->>DestDeviceTwo: SEQ=a, ACK=b, DATA=c
    %%  DestDeviceTwo-->>Origin: RST
    %%  Note over Origin,DestDeviceTwo: anycast shift
    %%else
    %%  Origin->>DestDeviceOne: FIN, ACK, SEQ=m, ACK=n
    %%  DestDeviceOne-->>Origin: ACK, ACK=m+1
    %%  Origin->>DestDeviceOne: FIN, ACK, SEQ=n, ACK=m+1
    %%  DestDeviceOne-->>Origin: ACK, ACK=n+1
    %%  Note over Origin,DestDeviceTwo: 4-way termination
    %%end
```

Let’s focus on “anycast shift” where a packet unexpectedly arrives at a device without a session. This can result from origins with routes using [equal-cost multipath](https://www.noction.com/blog/equal-cost-multipath-ecmp). The splitting of packets across links means the destination anycast IP may resolve to a different device resulting in reset.

```mermaid
graph LR

Origin(Origin1)
DestDeviceOne(DestDevice1)
DestDeviceTwo(DestDevice2)
HopOne((Hop1))
HopTwo((Hop2))
HopThreeA((Hop3A))
HopThreeB((Hop3B))

Origin --> HopOne --> HopTwo
HopTwo -->|equal-cost multipath| HopThreeA --> |anycast| DestDeviceOne
HopTwo -->|equal-cost multipath| HopThreeB --> |anycast| DestDeviceTwo
```

And without multipath.

```mermaid
graph LR

Origin(Origin2)
DestDeviceThree(DestDevice3)
HopOne((Hop1))
HopTwo((Hop2))
HopThree((Hop3))

Origin --> HopOne --> HopTwo --> HopThree --> |anycast| DestDeviceThree
```
