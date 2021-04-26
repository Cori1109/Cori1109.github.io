+++
title = "Hardware"
description = "Hardware used by James Moriarty."
date = "2021-02-10"
aliases = ["tools"]
author = "James Moriarty"
+++

This page is dedicated to my interest in consumer hardware.

## Photos

[![Grafana cluster dashboard](/images/hardware-grafana.png)](/images/hardware-grafana.png)

## Systems

### Personal Laptop

After spending the majority of my professional career on MacBooks - I use a Surface Pro 6 to run ... Linux. I use this for general open source development.

- Intel i5-8250U 4 Cores@1.6-3.4GHz
- Samsung 8GB DDR3@1600MHz
- Toshiba 128GB SSD NVMe

```
$ hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   17742 MB in  1.99 seconds = 8922.07 MB/sec
 Timing buffered disk reads: 1358 MB in  3.00 seconds = 452.51 MB/sec
```

### Budget Build Desktop

I've been continually impressed by the value of AMD's recent offerings. I use this desktop for development of Go, Windows, graphics, and security.

- AMD Ryzen 3 1300X 4 Core@3.5-3.7GHz
- Corsair Vengeance LPX 16GB (2x8GB) DDR4@2400MHz
- Samsung 960 EVO 250GB SSD NVMe
- Asus Strix RX570@1300MHz (2048SP) 4GB DDR5@7000MHz

```
$ hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   18744 MB in  2.00 seconds = 9381.70 MB/sec
 Timing buffered disk reads: 5822 MB in  3.00 seconds = 1940.50 MB/sec
```

### Home Kubernetes

I use this to run low power Intel NUC gitops K3s Kubernetes single node "cluster". I use this primarily for media, storage, and monitoring.

- Intel i3-4010U 2 Core@1.7GHz
- Corsair 8GB (1x8GB) DDR3@1600MHz
- Micron M600 128GB SSD mSATA

```
$ hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   7664 MB in  1.99 seconds = 3854.47 MB/sec
 Timing buffered disk reads: 1348 MB in  3.00 seconds = 448.90 MB/sec
```
