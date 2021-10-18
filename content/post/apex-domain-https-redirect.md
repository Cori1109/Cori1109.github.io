+++
author = "James Moriarty"
title = "Apex Domain HTTPS Redirect"
date = "2021-10-16"
description = "I recently broke my apex domain HTTPS redirect to my subdomain. "
tags = [
  "dns",
  "http",
  "tls"
]
+++

I recently broke the [apex domain](https://jamesmoriarty.xyz) HTTPS redirect to my [sub-domain](https://www.jamesmoriarty.xyz). Investigating the issue revealed the complexities of the behavior and, as a result, I’m written about some of those contributing factors.

## Interaction

![Apex HTTPS redirect for jamesmoriarty.xyz to www.jamesmoriarty.xyz](/images/apex-domin-https-redirect.drawio.svg)


## Apex Domain

> An apex domain is a custom domain that does not contain a subdomain, such as example.com . Apex domains are also known as base, bare, naked, root apex, or zone apex domains. An apex domain is configured with an A , ALIAS , or ANAME record through your DNS provider.

[Github](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages#using-an-apex-domain-for-your-github-pages-site)

We need our apex domain to resolve to something that can preform theredirect. `CNAME` records will not work, but we can use traditional `A` or a DNS specific `ALIAS` records. The following example is an Amazon Web Services (AWS) Route53 `ALIAS` record resolving to CloudFront:

```
$ dig +short jamesmoriarty.xyz
65.8.35.62
65.8.35.55
65.8.35.39
65.8.35.18
```

## TLS

We need to provide the client with TLS connectivity. This requires a certificate and something to facilitate TLS. Automated issuing and renewal of certificates facilitated with [Let’s Encrypt](https://letsencrypt.org/) or [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/). The following example is validating TLS connectivity with OpenSSL being facilitated by CloudFront:

```
$ openssl s_client -connect jamesmoriarty.xyz:443
CONNECTED(00000190)
depth=2 C = US, O = Amazon, CN = Amazon Root CA 1
verify return:1
depth=1 C = US, O = Amazon, OU = Server CA 1B, CN = Amazon
verify return:1
depth=0 CN = jamesmoriarty.xyz
verify return:1
---
```

## HTTP Redirect

We will need to redirect the client to the sub-domain. To support the widest possible number of clients, we will often do this at the HTTP protocol level. The following example is verbose curl output to validate the HTTP protocol interaction being facilitated by S3 static website hosting redirect function:

```
$ curl -v https://jamesmoriarty.xyz/ -o /dev/null
...
> GET / HTTP/2
> Host: jamesmoriarty.xyz
> user-agent: curl/7.68.0
...
>
< HTTP/2 301
< content-length: 0
< location: http://www.jamesmoriarty.xyz/index.html
...
```
