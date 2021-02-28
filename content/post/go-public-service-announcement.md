+++
author = "James Moriarty"
title = "Go Public Service Announcement"
date = "2021-02-28"
description = "For the love of proxies - please read this."
images = ["https://i.imgflip.com/4zsikp.jpg"]
tags = [
  "go"
]
+++

<hr />

<center>
  <img src="https://i.imgflip.com/4zsikp.jpg" alt="Meme">
</center>

<hr />

Take the following example code which overrides a HTTP client’s [DefaultTransport](https://golang.org/src/net/http/transport.go) in order to optionally verifies the server’s certificate chain and hostname.

```go
return &http.Client{
  Transport: &http.Transport{
    TLSClientConfig: &tls.Config{InsecureSkipVerify: skipValidateTLS},
  },
}
```

The full implications of the code change aren't obvious so let's look at the code that defines [DefaultTransport](https://golang.org/src/net/http/transport.go).

```go
var DefaultTransport RoundTripper = &Transport{
  Proxy: ProxyFromEnvironment,
  ...
}
```

And [Transport](https://golang.org/src/net/http/transport.go).

```go
  // If Proxy is nil or returns a nil *URL, no proxy is used.
  Proxy func(*Request) (*url.URL, error)
```

Take the following example command with a binary afflicted by this via a [dependency](https://github.com/splunk/terraform-provider-splunk/commit/db4b03158b1bdfff09d911ab3a8ae09bd3bfad98).

```python
$ https_proxy=https://proxy.corp.example.com:3128 \
    terraform \
      plan
```

In the act of using a custom [Transport](https://golang.org/src/net/http/transport.go) as opposed to [DefaultTransport](https://golang.org/src/net/http/transport.go) - we've lost the functionality of [ProxyFromEnvironment](https://golang.org/src/net/http/transport.go?s=16634:16691#L427). This becomes an issue for the countless souls trapped behind corporate proxies and who depend on this functionality. I've observed this defect in code from large enterprises like [Splunk](https://github.com/splunk/terraform-provider-splunk/commit/db4b03158b1bdfff09d911ab3a8ae09bd3bfad98) and [Dynatrace](https://github.com/Dynatrace/dynatrace-oneagent-operator/commit/a7b8d1a93920aaeb4239bc166cd25a184ffb0385#diff-4646a4f3b1c8bd9f12c17882703cd1bebbcc8fe28819157d8be73ee01d33cccdR141) and suspect it's more widespread. Stay vigilant.
