+++
author = "James Moriarty"
title = "Apex domain HTTPS redirect"
date = "2021-10-16"
description = "I recently broke my apex domain HTTPS redirect to my subdomain. "
tags = [
  "dns",
  "http",
  "tls"
]
+++

I recently broke my [apex domain](https://jamesmoriarty.xyz) HTTPS redirect to [subdomain](https://www.jamesmoriarty.xyz). It wasn't trivial to fix - so I've decided to write about some of factors which make it difficult.

## Apex Domain

> An apex domain is a custom domain that does not contain a subdomain, such as example.com . Apex domains are also known as base, bare, naked, root apex, or zone apex domains. An apex domain is configured with an A , ALIAS , or ANAME record through your DNS provider.

[Github](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages#using-an-apex-domain-for-your-github-pages-site)

We need our apex domain to resolve to something that can preform the redirect. This could be achieved with a traditional `A` record or `ALIAS` record (`CNAME` records are not supported with apex domains). The following example is a Amazon Web Services (AWS) Route53 `ALIAS` record resolving to CloudFront:

```
$ dig +short jamesmoriarty.xyz
65.8.35.62
65.8.35.55
65.8.35.39
65.8.35.18
```

## TLS

We need to provide the client TLS connectivity. This requires obtaining the certificate and something to facilitate TLS. Automated certificates have become accessible with providers such as [Let's Encrypt](https://letsencrypt.org/) and [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/). The following example is validating TLS connectivity with OpenSSL:

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

We will need to redirect the client to the subdomain. To support the widest possible number of clients this will often be done at the HTTP protocol level. Providing this functionality will require compute and connectivity. The following example is verbose curl output to validate the HTTP protocol interaction:

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

## Example

The following diagram illustrates my personal setup:

![Apex HTTPS redirect for jamesmoriarty.xyz to www.jamesmoriarty.xyz](/images/apex-domin-https-redirect.drawio.svg)