+++
author = "James Moriarty"
title = "Go Public Service Announcement"
date = "2021-02-28"
description = "For the love of proxies - please read this."
tags = [
  "go"
]
+++

Proxy support for some Go applications is being unintentionally dropped with a simple change. For example if you've ever been behind a proxy, you might recall doing something like:

```
$ https_proxy=https://proxy.corp.example.com:3128 \
    curl https://google.com/
```

Take the following example Go code which overrides an HTTP client’s [DefaultTransport](https://golang.org/src/net/http/transport.go) with a custom [Transport](https://golang.org/src/net/http/transport.go) in order to optionally verifies the server’s certificate chain and hostname:

```go
return &http.Client{
  Transport: &http.Transport{
    TLSClientConfig: &tls.Config{InsecureSkipVerify: skipValidateTLS},
  },
}
```

The full implications of the code change aren't obvious so let's look at the code that defines [DefaultTransport](https://golang.org/src/net/http/transport.go) for `Proxy`:

```go
var DefaultTransport RoundTripper = &Transport{
  Proxy: ProxyFromEnvironment,
```

And [Transport](https://golang.org/src/net/http/transport.go) for `Transport{}`:

```go
  // If Proxy is nil or returns a nil *URL, no proxy is used.
  Proxy func(*Request) (*url.URL, error)
```

Using a custom [Transport](https://golang.org/src/net/http/transport.go) - we've lost the functionality of [ProxyFromEnvironment](https://golang.org/src/net/http/transport.go?s=16634:16691#L427). I’ve observed this defect in popular vendor’s code, e.g. [Splunk](https://github.com/splunk/terraform-provider-splunk/commit/db4b03158b1bdfff09d911ab3a8ae09bd3bfad98) and [Dynatrace](https://github.com/Dynatrace/dynatrace-oneagent-operator/commit/a7b8d1a93920aaeb4239bc166cd25a184ffb0385#diff-4646a4f3b1c8bd9f12c17882703cd1bebbcc8fe28819157d8be73ee01d33cccdR141) and suspect it's more widespread. Stay vigilant.
