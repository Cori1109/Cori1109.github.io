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

_See [Art of SLOs](https://sre.google/resources/practices-and-processes/art-of-slos/)_

| Availability %                    | Downtime per year[note 1] | Downtime per quarter | Downtime per month  | Downtime per week   | Downtime per day (24 hours) |
|-----------------------------------|---------------------------|----------------------|---------------------|---------------------|-----------------------------|
| 90% ("one nine")                  | 36.53 days                | 9.13 days            | 73.05 hours         | 16.80 hours         | 2.40 hours                  |
| 95% ("one and a half nines")      | 18.26 days                | 4.56 days            | 36.53 hours         | 8.40 hours          | 1.20 hours                  |
| 97%                               | 10.96 days                | 2.74 days            | 21.92 hours         | 5.04 hours          | 43.20 minutes               |
| 98%                               | 7.31 days                 | 43.86 hours          | 14.61 hours         | 3.36 hours          | 28.80 minutes               |
| 99% ("two nines")                 | 3.65 days                 | 21.9 hours           | 7.31 hours          | 1.68 hours          | 14.40 minutes               |
| 99.5% ("two and a half nines")    | 1.83 days                 | 10.98 hours          | 3.65 hours          | 50.40 minutes       | 7.20 minutes                |
| 99.8%                             | 17.53 hours               | 4.38 hours           | 87.66 minutes       | 20.16 minutes       | 2.88 minutes                |
| 99.9% ("three nines")             | 8.77 hours                | 2.19 hours           | 43.83 minutes       | 10.08 minutes       | 1.44 minutes                |
| 99.95% ("three and a half nines") | 4.38 hours                | 65.7 minutes         | 21.92 minutes       | 5.04 minutes        | 43.20 seconds               |
| 99.99% ("four nines")             | 52.60 minutes             | 13.15 minutes        | 4.38 minutes        | 1.01 minutes        | 8.64 seconds                |
| 99.995% ("four and a half nines") | 26.30 minutes             | 6.57 minutes         | 2.19 minutes        | 30.24 seconds       | 4.32 seconds                |
| 99.999% ("five nines")            | 5.26 minutes              | 1.31 minutes         | 26.30 seconds       | 6.05 seconds        | 864.00 milliseconds         |
| 99.9999% ("six nines")            | 31.56 seconds             | 7.89 seconds         | 2.63 seconds        | 604.80 milliseconds | 86.40 milliseconds          |
| 99.99999% ("seven nines")         | 3.16 seconds              | 0.79 seconds         | 262.98 milliseconds | 60.48 milliseconds  | 8.64 milliseconds           |
| 99.999999% ("eight nines")        | 315.58 milliseconds       | 78.89 milliseconds   | 26.30 milliseconds  | 6.05 milliseconds   | 864.00 microseconds         |
| 99.9999999% ("nine nines")        | 31.56 milliseconds        | 7.89 milliseconds    | 2.63 milliseconds   | 604.80 microseconds | 86.40 microseconds          |

### 5. Production Readiness Review

Verify that the service meets accepted standards of production setup and operational readiness.

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
