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

This post is dedicated to how I would shape a “consulting” style Site Reliability Engineering (SRE) engagement.

>  SRE is seen as a high modernist project, intent on scientifically managing their systems, all techne and no metis; all SLOs and Kubernetes and no systems knowledge and craft.

[Seeing Like an SRE: Site Reliability Engineering as High Modernism](https://www.usenix.org/publications/loginonline/seeing-sre-site-reliability-engineering-high-modernism)

### 1. Engagement Charter

Start by formalizing the scope and activities as a charter.
> e.g. production readiness, operational responsibility, ...

### 2. Critical User Journey Mapping

Discover and document user journeys prioritized by criticality to facilitate the remaining activities.


| Critical User Journey | Interaction | Valid Event | Impact |
| --------------------- | ----------- | ----------- | ------ |
| Checkout              | GET /checkout/new | HTTP 200 | 100% |
| Checkout              | POST /checkout | HTTP 301 | 100% |
| Checkout              | GET /orders/[id] | HTTP 200,404 | 0% |
| Add to cart           | PUT /cart/[product_id] | HTTP 200 | 10-100% |
| View Product          | GET /products/[id] | HTTP 200,404 | 5-100% |
| ... | ... | ... | ... |

### 3. Risk Analysis

Capture concrete and systemic risks against Critical User Journeys (CUJ). An example of systemic risk might be "production access" or "lack of monitoring". An example of a concrete risk might be "deployments cause downtime" or a "minor defect".

| Risk | ETTD | ETTR | Impact | ETTF | Incidents/Year | Bad Minutes/Year               |
|------|------|------|----------|------|----------------|--------------------------------|
|      | mins | mins | %        | days | 365/ETTF       | (ETTD + ETTR) * Impact * Incidents/Year |
| deployment downtime |  0 mins |  3 mins | 100% |  7 days | 52 | 156 mins |
| minor defect        | 60 mins | 60 mins |   2% | 21 days | 17 |  41 mins |
|...|...|...|...|...|...|...|

### 4. Service Level Objective Development

Figure out which metrics to use as SLIs that will most accurately track the user experience. 80% of the time - this is availability.

> 98% of `POST /checkout` requests should return a `HTTP 301` status code successfully over rolling 28 day time window.

_See [Art of SLOs](https://sre.google/resources/practices-and-processes/art-of-slos/)_

| Availability %                    | Downtime per year[note 1] | Downtime per day (24 hours) | Cost Example |
|-----------------------------------|---------------------------|-----------------------------|--------------|
| 90% ("one nine")                  | 36.53 days                | 2.40 hours                  |            0 |
| 99% ("two nines")                 | 3.65 days                 | 14.40 minutes               |       $1,000 |
| 99.9% ("three nines")             | 8.77 hours                | 1.44 minutes                |      $10,000 |
| 99.99% ("four nines")             | 52.60 minutes             | 8.64 seconds                |     $100,000 |
| 99.999% ("five nines")            | 5.26 minutes              | 864.00 milliseconds         |   $1,000,000 |
| 99.9999% ("six nines")            | 31.56 seconds             | 86.40 milliseconds          |  $10,000,000 |
| 99.99999% ("seven nines")         | 3.16 seconds              | 8.64 milliseconds           | $100,000,000 |
| 99.999999% ("eight nines")        | 315.58 milliseconds       | 864.00 microseconds         | $...         |
| 99.9999999% ("nine nines")        | 31.56 milliseconds        | 86.40 microseconds          | $...         |

E.g. A Passenger plane engine might be designed for "five nines" of availability. 

### 5. Production Readiness Review

Verify that the service meets accepted standards of production and operational readiness. Examples of production rediness could include a esablished developement process, regular and reliable deployments, operational monitoring and documented procedures. 

_See [Evolving SRE Engagement Model](https://sre.google/sre-book/evolving-sre-engagement-model/)_

### 6. Review Periodically

Requirements will change and new information will become available. Here is some guidance from the [SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/) on how to respond to your SLO measures.

| SLO |	Toil |	Customer satisfaction |	Action |
| --- | ---- | ---------------------- | ------ |
| Met | Low | High | Choose to (a) relax release and deployment processes and increase velocity, or (b) step back from the engagement and focus engineering time on services that need more reliability. |
| Met | Low |Low |Tighten SLO. |
| Met | High | High | If alerting is generating false positives, reduce sensitivity. Otherwise, temporarily loosen the SLOs (or offload toil) and fix product and/or improve automated fault mitigation. |
| Met | High | Low | Tighten SLO. |
| Missed | Low | High | Loosen SLO. |
| Missed | Low | Low | Increase alerting sensitivity. |
| Missed | High | High | Loosen SLO. |
| Missed | High | Low | Offload toil and fix product and/or improve automated fault mitigation. |

_See [SRE Workbook - Implementing SLOs](https://sre.google/workbook/implementing-slos/)_

### Useful activities

> weekly production in review, runbooks, "Wheel of Misfortune", pre-mortem, casual maps, human factors, team building activities, ...
