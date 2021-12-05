+++
author = "James Moriarty"
title = "Consulting SRE Engagements"
date = "2021-12-05"
description = ""
tags = [
  "sre",
  "consulting"
]
+++

I believe “consulting” Site Reliability Engineering (SRE) engagements are - _in general_ - an anti-pattern. These are some notes on how I would shape and order such an engagement.

### 1. Engagement Charter

Start by formalizing the scope and activities as a charter.
> e.g. Service Level Objective (SLO) development, operational responsibility, post incident review

### 2. Critical User Journey Mapping

Discover and document user journeys prioritized by criticality to facilitate the remaining activities.
> e.g. business impact, architecture, interactions, outputs

### 3. Risk Analysis

Develop an ongoing risk catalogue for each Critical User Journey (CUJ).
> e.g. Impact, ETTD, ETTR, ETTF stack ranked by bad minutes/year

### 4. Service Level Objective Development

_See [Art of SLOs](https://sre.google/resources/practices-and-processes/art-of-slos/)_

### 5. Production Readiness Review

_See [Evolving SRE Engagement Model](https://sre.google/sre-book/evolving-sre-engagement-model/)_

### Useful activities

> weekly production in review, runbooks, "Wheel of Misfortune", pre-mortem, casual maps, human factors, team building activities, ...
