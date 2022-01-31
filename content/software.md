+++
title = "Software"
description = "Software created by James Moriarty."
date = "2021-02-10"
aliases = []
author = "James Moriarty"
+++

A showcase of my personal software projects.

## Alpaca Desktop

[![Alpaca Desktop Screenshot](/images/software-alpaca-desktop2.png)](/images/software-alpaca-desktop2.png)

Experimental OSX menu bar widget for Alpaca (a local proxy supporting NTLM authentication for command line tools). Built to reduce toil involved in installation and configuration for several hundred engineers.

[Github](https://github.com/jamesmoriarty/alpaca-desktop)

## Forward Proxy

```shell
$ forward-proxy --binding 0.0.0.0 --port 3182 --threads 2
[2021-01-14 19:37:47 +1100] INFO Listening 0.0.0.0:3182
[2021-01-14 19:38:24 +1100] INFO CONNECT raw.githubusercontent.com:443 HTTP/1.1
```

Minimal forward proxy in 150LOC and using only standard libraries. Useful for development, testing, and learning. Automated tests simulate a range of scenarios including slow network and even dynamically generate runtime trusted self signed X509 certificates.

[Github](https://github.com/jamesmoriarty/forward-proxy)

## React Instagram Feed

[![React Instagram Screenshot](/images/software-react-instagram.png)](/images/software-react-instagram.png)

Simple React component to render a [Instagram](http://instagram.com) feed. Used an unofficial integration method to avoid having to use a access token.

[Github](https://github.com/jamesmoriarty/react-instagram-authless-feed)

## Gomem

```go
import "github.com/jamesmoriarty/gomem"
...
process, err := gomem.GetOpenProcessFromName(name)
valuePtr, err := process.ReadUInt32(offsetPtr)
process.WriteByte(valuePtr, value)
```

A Go library to manipulate Windows processes. Useful for developing process memory based security exploits. Automated tests manipulate and verify its own process memory via Windows APIs.

[Github](https://github.com/jamesmoriarty/gomem)

## Cloudformation Cheapest NAT

[![AWS NAT](/images/software-nat.png)](/images/software-nat.png)

Cloudformation for a NAT instance running on Spot. Save thousands on NAT costs every month.

[Github](https://github.com/jamesmoriarty/cfn-cheapest-nat)

## Gohack

[![Gohack terminal output](/images/software-gohack.png)](/images/software-gohack.png)

Experimental Go language CSGO computer game exploit proof-of-concept. Automated tests use stubbed external processes to avoid needing binary compatibility.

[Github](https://github.com/jamesmoriarty/gohack)

## Call Graph

[![Call Graph presentation slide](/images/software-callgraph.png)](/images/software-callgraph.png)

A Ruby library to capture execution and create call graphs. Useful for illustrating [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) violations.

[Github](https://github.com/jamesmoriarty/call-graph)

## Lisp

```lisp
$ lisp-repl
ctrl-c to exit
> (begin
(>   (define incf
((>     (lambda (x)
(((>       (set! x (+ x 1))))
(>   (define one 1)
(>   (incf one))
2
>
```

Minimal Lisp interpreter in 75LOC and using only standard libraries excluding the REPL. Inspired by Google Research Peter Norvig's [Lis.py](http://norvig.com/lispy.html). A concise implementation using the Ruby programming language.

[Github](https://github.com/jamesmoriarty/lisp)

## Nebula

<a href="/images/software-nebula.mp4">
  <video width="100%" autoplay loop>
    <source src="/images/software-nebula.mp4" type="video/mp4" />
  </video>
</a>

A prototype 2D Javascript space shooter. Simple physics, unit behaviors, parallax effects, and particles.

[Github](https://github.com/jamesmoriarty/nebula)

## Scorched Earth

<a href="/images/software-scorched.mp4">
  <video width="100%" autoplay loop>
    <source src="/images/software-scorched.mp4" type="video/mp4" />
  </video>
</a>

A pure JRuby Scorched Earth clone and using only standard libraries. Implemented with an event-driven architecture. Dynamically generates color pallettes utilizing Triad Mixing and CIE94 color distances. Headless automated tests enabled through null pattern graphics context injection.

[Github](https://github.com/jamesmoriarty/scorched_earth)
