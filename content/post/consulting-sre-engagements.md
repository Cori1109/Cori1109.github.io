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

This post is dedicated to how I would shape a “consulting” style Site Reliability Engineering (SRE) engagement. While I believe this style an anti-pattern - it makes sense in some circumstances.

>  SRE is seen as a high modernist project, intent on scientifically managing their systems, all techne and no metis; all SLOs and Kubernetes and no systems knowledge and craft.

[Seeing Like an SRE: Site Reliability Engineering as High Modernism](https://www.usenix.org/publications/loginonline/seeing-sre-site-reliability-engineering-high-modernism)

### 1. Engagement Charter

Start by formalizing the scope and activities as a charter.
> e.g. production readiness, operational responsibility, ...

### 2. Critical User Journey Mapping

Discover and document user journeys prioritized by criticality to facilitate the remaining activities.

#### 1. Check out

> GET /checkout/new => 200

and

> POST /checkout => 301 => GET /orders/<id> => 200

#### 2. Add to cart

> PUT /cart/<product_id> => 200

#### 3. View Product

> GET /products => 200

and

> GET /products/<id> => 200

### 3. Risk Analysis

Capture concrete and systemic risks against Critical User Journeys (CUJ). An example of systemic risk might be "production access" or "lack of monitoring". An example of a concrete risk might be "deployments cause downtime" or a "minor defect".

| Risk | ETTD | ETTR | % Impact | ETTF | Incidents/Year | Bad Minutes/Year               |
|------|------|------|----------|------|----------------|--------------------------------|
|      | mins | mins | %        | days | 365/ETTF       | (ETTD + ETTR) * Impact * Incidents/Year |
| deployment downtime |  0 mins |  3 mins | 100% |  7 days | 52 | 156 mins |
| minor defect        | 60 mins | 60 mins |   2% | 21 days | 17 |  41 mins |
|...|...|...|...|...|...|...|

### 4. Service Level Objective Development

Figure out which metrics to use as SLIs that will most accurately track the user experience. 80% of the time - this is availability.

_See [Art of SLOs](https://sre.google/resources/practices-and-processes/art-of-slos/)_

### 5. Production Readiness Review

Verify that the service meets accepted standards of production setup and operational readiness.

_See [Evolving SRE Engagement Model](https://sre.google/sre-book/evolving-sre-engagement-model/)_

### Useful activities

> weekly production in review, runbooks, "Wheel of Misfortune", pre-mortem, casual maps, human factors, team building activities, ...
