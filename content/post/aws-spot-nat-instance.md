+++
author = "James Moriarty"
title = "AWS Spot NAT Instance"
date = "2020-06-21"
description = ""
tags = [
  "aws"
]
+++

My work often involves restricted private networks often found in large enterprises. I run a personal [similarly provisioned AWS VPC](https://github.com/jamesmoriarty/cfn-vpc) for experiments. This comes with the challenge of providing internet egress for `RFC1918` private subnet instances.

AWS provides several solutions for internet egress. After spending some time considering these, I settled on NAT instance running on Spot. The primary driver of this solution is cost.

### Reliability

| Risk         | ETTD | ETTR | EETF     | Impact | Notes
|--------------|------|------|----------|--------|-
| Spot Restart | 5m   | 5m   | 30 days  | 100%   | Every month**
| EC2 Fails    | 5m   | 5m   | 90 days  | 100%   | Every three months*
| AZ Fails     | 5m   | 2h   | 180 days | 100%   | Every six months*
| Region Fails | 5m   | 4h   | 730 days | 100%   | Every two years*

Looking specifically at `Spot Restart`:

```
43,200 = 60 min * 24 hours * 30 days (valid minutes)
10     = 5 ettr + 5 ettd             (bad minutes)
99.98% = (valid - bad) / valid * 100 (fraction of good minutes)
```

That's nearly four nines of reliability with the introduction of Spot. I've also used a generous minimum ETTD & ETTR despite the autoscale group generally recovering within two minutes.

\* [90% SLA](https://aws.amazon.com/compute/sla/) the SLO appears to be much higher.

\** Based on uptime.

> April 2, 2020 at 8:36:05 PM UTC+11 (1919 hours)

### Cost

The following costs are an estimate:

|solution            |network  |cost/GB|cost/hour|cost/month|
|--------------------|---------|-------|---------|----------|
|NAT Gateway         |5-45 Gbps|  0.059|0.059    |42.48     |
|NAT Instance        |0-5  Gbps|0-0.114|0.0059   | 4.25     |
|NAT Instance (spot) |0-5  Gbps|0-0.114|0.0018   | 1.30     |

Spot market costs are variable but current data suggests:

> t3a.nano (1) ... total 69% savings

### Performance

The performance test can be reproduced with the following command:

```
yum install python python-pip -y \
 && pip install --upgrade pip \
 && pip install speedtest-cli \
 && speedtest-cli
```

The `t3.nano` instances provide several Gbps up and down.

> Download: 3283.42 Mbit/s
> Upload: 2274.26 Mbit/s

### Conclusion

This solution has proven acceptable for small egress bandwidth requirements in the range of 1-5 Gbps. The Github project can be found [here](https://github.com/jamesmoriarty/cfn-cheapest-nat).
