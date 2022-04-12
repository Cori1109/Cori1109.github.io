+++
author = "James Moriarty"
title = "TCP Delayed ACK"
date = "2022-04-12"
description = ""
tags = [
  "tcp",
  "nodelay",
  "nagle"
]
+++

Someone recently asked me to help diagnose a mysterious delay. I’m quite excited to talk about it. I had previously facilitated SRE training sessions for this [scenario](https://github.com/jvns/twine-stories/blob/main/50ms-request.twee#L2) and this is the first time I've caught it in the wild.

## Symptoms

There was a globally deployed Elixir service experiencing:

* 100 milliseconds delay without TLS. 
* The delay could not be reproduced with other client types.

This led to the investigation of client configuration and ['NO_DELAY' not being set without TLS](https://github.com/elixir-grpc/grpc/issues/176).

## Explanation

> This algorithm interacts badly with TCP delayed acknowledgments (delayed ACK), a feature introduced into TCP at roughly the same time in the early 1980s, but by a different group. With both algorithms enabled, applications that do two successive writes to a TCP connection, followed by a read that will not be fulfilled until after the data from the second write has reached the destination, experience a constant delay of up to 500 milliseconds, the "ACK delay". It is recommended to disable either, although traditionally it's easier to disable Nagle, since such a switch already exists for real-time applications.

[Nagle's Algorithm](https://en.wikipedia.org/wiki/Nagle%27s_algorithm)
