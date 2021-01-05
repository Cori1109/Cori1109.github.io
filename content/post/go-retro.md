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

- [Toolchain](#toolchain)
- [Error Handling](#error-handling)
- ["Here be dragons"](#here-be-dragons)
- [Windows](#windows)

# Toolchain

The Go toolchain is impressive. I've worked professionally across many programming languages and found this one of the most enjoyable to pickup and use.

# Error Handling

I initially found Go's error handling painful until I came to understand that improper exception handling contributes to a significate proportion of defects produced by the software industry.

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

## Here Be Dragons

I enjoyed lower level memory work with Go but it was achieved using the `unsafe` package and introduces many news possibilities for defects.

## Windows

The APIs also appear to target the Linux and have been retrofitted to Windows.