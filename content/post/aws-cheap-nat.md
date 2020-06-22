+++
author = "James Moriarty"
title = "AWS Cheap NAT'ing"
date = "2020-06-21"
description = ""
tags = [
  "aws"
]
+++

My work often involves restricted private networks often found in large enterprises. I run a personal [similarly provisioned AWS VPC](https://github.com/jamesmoriarty/cfn-vpc) for experiments. This comes with the challenge of providing internet egress for `RFC1918` private subnet instances.

AWS provides several solutions for internet egress. After spending some time considering these, I settled on NAT instance running on Spot. The primary driver of this solution is cost. [I’ve recorded my findings here](https://github.com/jamesmoriarty/cfn-cheapest-nat).

### Reliability

The route `0.0.0.0/0` associates with the NAT’s network interface. Existing instances lose internet egress when this interface changes. I’m experimenting with persistent elastic network interfaces and static IPs to allow the NAT instance to change with minimal impact.

### Cost

Despite running on Spot as `t3.nano` or `t3a.nano` instance, I've had great uptime for a reduced price. e.g.

> April 2, 2020 at 8:36:05 PM UTC+11 (1919 hours)

### Performance

The `t3.nano` instances provide several Gbps up and down.

> Download: 3283.42 Mbit/s
> Upload: 2274.26 Mbit/s

### Conclusion

While not perfect, the tradeoffs seem to justify the cost. The solution has proven acceptable for a small non-production like VPC.
