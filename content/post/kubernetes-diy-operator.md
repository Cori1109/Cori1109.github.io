+++
author = "James Moriarty"
title = "Kubernetes DIY Operator"
date = "2021-03-08"
description = ""
tags = [
  "kubernetes"
]
+++

I've rolled my own [Dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS) Operator with [External DNS](https://github.com/kubernetes-sigs/external-dns), [Kubernetes CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/), and [kubectl](https://kubernetes.io/docs/tasks/tools/). The execution looks something like:

1. Discover external IP with `curl --silent ifconfig.me`.
2. Generate Ingress with External DNS annotations.
3. Create/Update the Ingress with `kubectl`.

External DNS will reconcile Ingress changes and make the appropriate DNS updates.

## Code

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: ip-operator
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: ip-operator
            image: bitnami/kubectl
            command:
            - /bin/sh
            - -c
            - |
              cat << EOF > /tmp/ingress.yml && kubectl apply -f /tmp/ingress.yml
              apiVersion: networking.k8s.io/v1
              kind: Ingress
              metadata:
                name: ip-operator
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
                  name: ip-operator
                  key: hostname
```