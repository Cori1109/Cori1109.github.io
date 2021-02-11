+++
author = "James Moriarty"
title = "Go Retrospective"
date = "2021-01-05"
description = "I worked on the following small projects to familiarizing myself with Golang."
tags = [
  "go"
]
+++

I worked on the following small projects to familiarize myself with Go:

- [Gohack](https://github.com/jamesmoriarty/gohack)
- [Gomem](https://github.com/jamesmoriarty/gomem)
- [Goforward](https://github.com/jamesmoriarty/goforward)
- [Gobackground](https://github.com/jamesmoriarty/gobackground)
- [Gobat2exe](https://github.com/jamesmoriarty/gobat2exe)
- [Gobot](https://github.com/jamesmoriarty/gobot)

Here are some points that stood out:

- [Standalone Binaries](#standalone-binaries)
- [Toolchain](#toolchain)
- [Error Handling](#error-handling)
- [Modules](#modules)
- [Concurrency](#concurrency)
- ["Here be dragons"](#here-be-dragons)
- [Windows](#windows)

### Standalone Binaries

I'm appreciative of this feature. In comparison - distributing a similar ruby application would be extremely difficult.

### Toolchain

The Go toolchain is impressive. I've worked professionally across many programming languages and found this one of the most enjoyable to pickup and use. The Go ecosystem appears more consistent as a result.

### Error Handling

I initially found Go's error handling painful but have come to appreciate it. It appears that improper exception handling contributes to a significant proportion of defects.

```go
func GetOffsets() (*Offsets, error) {
	var offsets Offsets

	resp, err := http.Get(OffsetsURL)

	if err != nil {
		return nil, errors.New("Failed making offsets request")
	}

	defer resp.Body.Close()

	bytes, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return nil, errors.New("Failed reading offsets request")
	}

	err = yaml.Unmarshal(bytes, &offsets)

	if err != nil {
		return nil, errors.New("Failed parsing offsets request")
	}

	return &offsets, nil
}
```

### Modules

I really like the way Go has implemented modular programming.

```go
package robots

import "github.com/jamesmoriarty/gobot/directions"

type Robot struct {
	X         int64
	Y         int64
	Direction directions.Direction
}
```

### Concurrency

Go "routines" and "channels" appear easy to use and well thought out.

```go
shutdown := make(chan os.Signal, 1)
signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
go goforward.Listen(port, rate, shutdown)
<-shutdown
```

### Here Be Dragons

I enjoyed lower level memory work with Go but `unsafe` introduces bizarre new possibilities for software defects.

### Windows

The APIs also appear to target the Linux and have been retrofitted to Windows.