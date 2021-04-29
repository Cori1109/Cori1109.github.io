+++
title = "Software"
description = "Software used by James Moriarty."
date = "2021-02-10"
aliases = []
author = "James Moriarty"
+++

A showcase some of my personal software projects.

## Alpaca Desktop

[![Alpaca Desktop Screenshot](/images/software-alpaca-desktop2.png)](/images/software-alpaca-desktop2.png)

Experimental OSX menu bar widget for Alpaca (a local proxy supporting NTLM authentication for command line tools). Distributed as a BitBar application with Alpaca binary and Launchd daemon. This was built to reduce the toil involved with installing and running Alpaca being undertaken by several hundred engineers.

[Github](https://github.com/jamesmoriarty/alpaca-desktop)

## Forward Proxy

```shell
$ forward-proxy --binding 0.0.0.0 --port 3182 --threads 2
[2021-01-14 19:37:47 +1100] INFO Listening 0.0.0.0:3182
[2021-01-14 19:38:24 +1100] INFO CONNECT raw.githubusercontent.com:443 HTTP/1.1
```

Minimal forward proxy in 150LOC and using only standard libraries. Useful for development, testing, and learning. Implements a 35LOC thread pool. An interesting example of application interaction establishing a transport layer tunnel.

[Github](https://github.com/jamesmoriarty/forward-proxy)

## Gomem

```go
import "github.com/jamesmoriarty/gomem"
...
process, err := gomem.GetFromProcessName(name)
process.Open()
process.Read(offsetPtr, bufferPtr, unsafe.Sizeof(value))
process.Write(offsetPtr, bufferPtr, unsafe.Sizeof(value))
```

A Go library to manipulate Windows processes. Useful for developing process memory based security exploits. Automated tests manipulate and verify its own process memory via Windows APIs.

[Github](https://github.com/jamesmoriarty/gomem)

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

## Scorched Earth

<video width="100%" autoplay loop>
  <source src="/images/software-scorched.mp4" type="video/mp4" />
</video>

A pure JRuby Scorched Earth clone and using only standard libraries. Dynamically generates color pallettes with Triad Mixing and CIE94 color distances.

[Github](https://github.com/jamesmoriarty/scorched_earth)
