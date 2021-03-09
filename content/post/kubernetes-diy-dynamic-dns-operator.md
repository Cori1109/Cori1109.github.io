+++
author = "James Moriarty"
title = "Kubernetes DIY Dynamic DNS Operator"
date = "2021-03-08"
description = ""
tags = [
  "kubernetes"
]
+++

I've rolled my own [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS) Operator with Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/), [kubectl](https://kubernetes.io/docs/tasks/tools/), and [External DNS](https://github.com/kubernetes-sigs/external-dns).

## Interaction

![Interaction diagram](/images/kubernetes-diy-dynamic-dns-operator.drawio.svg)

## Yaml

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
              cat << EOF > /tmp/ingress.yml && kubectl apply -f /tmp/ingress.yml
              apiVersion: networking.k8s.io/v1
              kind: Ingress
              metadata:
                name: dynamic-dns-operator
                annotations:
                  kubernetes.io/ingress.class: nginx
                  external-dns.alpha.kubernetes.io/hostname: '$HOSTNAME'
                  external-dns.alpha.kubernetes.io/target: '$(curl --silent ifconfig.me)'
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