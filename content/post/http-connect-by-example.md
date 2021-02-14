+++
author = "James Moriarty"
title = "HTTP CONNECT By Example"
date = "2021-02-12"
description = ""
tags = [
  "http",
  "proxy"
]
+++

[HTTP CONNECT](https://tools.ietf.org/html/rfc7231#section-4.3.6) is used to establish a [tunnel](https://en.wikipedia.org/wiki/HTTP_tunnel). Tunnels are commonly used to create an end-to-end virtual connection, through one or more proxies, which can then be secured using TLS (Transport Layer Security). I've broken this post into the following sections:

- [Entity Interaction Diagram](#entity-interaction-diagram)
- [Layer Diagram](#layer-diagram)
- [Example](#example)
- [Links](#links)

### Entity Interaction Diagram

![Entity interaction diagram](/images/http-connect2.drawio.svg)

### Layer Diagram

![TCP / IP model interaction diagram](/images/http-connect.drawio.svg)

### Example

The following example consists of the curl output and corresponding "one-shot" 30 LOC Ruby HTTP CONNECT Proxy [code](https://gist.github.com/jamesmoriarty/a6100395d2efb17dcd06173300f988bb):

```
$ https_proxy=http://127.0.0.1:9292 curl -v https://google.com
```

```ruby
require 'socket'

listen_socket = TCPServer.new('127.0.0.1', 9292)
```

```
> CONNECT google.com:443 HTTP/1.1
```

```ruby
client_conn = listen_socket.accept
request_line = client_conn.gets
```

```
> Host: google.com:443
> User-Agent: curl/7.54.0
> Proxy-Connection: Keep-Alive
> 
```

```ruby
request_headers = {}
while(line = client_conn.gets) do
  break unless line.include?(':')

  header, value = *line.split(':').map(&:strip)
  request_headers[header] = value
end
```

```
< HTTP/1.1 200 OK
< 
```

```ruby
host, port = *request_line.split[1].split(':')
dest_conn = TCPSocket.new(host, port)
client_conn.write "HTTP/1.1 200 OK\n\n"
```

```
* Proxy replied OK to CONNECT request
...
> GET / HTTP/2
> Host: google.com
> User-Agent: curl/7.54.0
> Accept: */*
> 
...
< HTTP/2 301 
< location: https://www.google.com/
...
< 
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
```

```ruby
def transfer(src_conn, dest_conn)
  IO.copy_stream(src_conn, dest_conn)
rescue => e
  puts e.message
end

[
  Thread.new { transfer(client_conn, dest_conn) },
  Thread.new { transfer(dest_conn, client_conn) }
].each(&:join)
```

### Links

I worked on the following small projects to familiarize myself with forward proxies and write this post:

- [ForwardProxy](https://github.com/jamesmoriarty/forward-proxy) - A 150 LOC proxy written in Ruby for learning and development.
- [GoForward](https://github.com/jamesmoriarty/goforward) - A rate limiting proxy written in Go based on Michał Łowicki's original code.
- [Alpaca](https://github.com/samuong/alpaca) - A proxy supporting PAC scripts and NTLM authentication.

<style>
pre {
  margin-left: 0%;
}

.highlight pre {
  margin-left: 5%;
}
</style>
