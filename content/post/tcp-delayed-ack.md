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

Someone recently asked me to help diagnose a mysterious latency. I’m quite excited to talk about it. I had previously facilitated SRE training sessions for this [scenario](https://github.com/jvns/twine-stories/blob/main/50ms-request.twee#L2) and this is the first time I've caught it in the wild.
