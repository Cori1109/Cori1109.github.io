+++
author = "James Moriarty"
title = "Kubernetes DIY Dynamic DNS Operator"
date = "2021-03-08"
description = ""
tags = [
  "kubernetes"
]
+++

I've rolled my own [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS) Operator with Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/), [kubectl](https://kubernetes.io/docs/tasks/tools/), and [External DNS](https://github.com/kubernetes-sigs/external-dns). I'm going to try capture the solution in a [Google Design Document](https://www.industrialempathy.com/posts/design-docs-at-google/).

# Context

A solution to dynamically maintain a DNS record containing my routers public IP.

## Goals

- Record should not be out of date by more than five minutes.
- Run as a Kubernetes workload.

## Non-Goal

- Support multiple public IPs.
- Ingress.

# Design

The design is broken down into the following sections:

- [Discover Public IP](#discover-public-ip)
- [DNS Changes](#dns-changes)
- [Dynamic Configuration](#dynamic-configuration)
- [Interaction](#interaction)
- [Example Manifest](#example-manifest)
- [Network](#network)

## Discover Public IP

There are several free public internet services that will return the requesters IP:

```bash
$ curl --silent ifconfig.me
```

## DNS Changes

[External DNS](https://github.com/kubernetes-sigs/external-dns) Ingress annotations can configure a DNS record:

```
external-dns.alpha.kubernetes.io/hostname
```

Specifies the Host e.g. `ip.home.jamesmoriarty.xyz`.

```
external-dns.alpha.kubernetes.io/target
```

Specifies the IP e.g. `110.144.168.172`

## Dynamic Configuration

[CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) to periodically generate and apply the configuration. The configuration variables are interpolated via `heredoc` template:

```bash
cat << EOF > /tmp/ingress.yml && kubectl apply -f /tmp/ingress.yml
  ...
EOF
```

## Interaction

![Interaction diagram](/images/kubernetes-diy-dynamic-dns-operator.drawio.svg)

## Network

![Network diagram](/images/kubernetes-diy-dynamic-dns-operator2.drawio.svg)

## Example Manifest

An example of what the full Kubernetes manifest might look like:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: dynamic-dns-operator
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: dynamic-dns-operator
            image: bitnami/kubectl
            command:
            - /bin/sh
            - -c
            - |
              export IP=$(curl --silent ifconfig.me)

              cat << EOF > /tmp/ingress.yml && kubectl apply -f /tmp/ingress.yml
              apiVersion: networking.k8s.io/v1
              kind: Ingress
              metadata:
                name: dynamic-dns-operator
                annotations:
                  kubernetes.io/ingress.class: nginx
                  external-dns.alpha.kubernetes.io/hostname: '$HOSTNAME'
                  external-dns.alpha.kubernetes.io/target: '$IP'
              spec:
                rules:
                - host: '$HOSTNAME'
              EOF
            env:
            - name: HOSTNAME
              valueFrom:
                configMapKeyRef:
                  name: dynamic-dns-operator
                  key: hostname
```

# Conclusion

I've you're already using [External DNS](https://github.com/kubernetes-sigs/external-dns) - adding another 30-40 lines Kubernetes manifests to support [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS) may be desireable.
