+++
author = "James Moriarty"
title = "Causal Diagrams"
date = "2022-05-18"
description = ""
tags = [
  "sre",
  "diagram"
]
+++

Incidents often result from contributing factors as opposed to a singular root cause. As a result, causal diagrams can be an effective tool for illustrating incidents.

## Example

```mermaid
graph TD
    A(Instance Restarts)
    B(Instance Attempts To Connect To External Service)
    C(Instance Fails To Connect To External Service)
    D(Purchase External Service Plan With #3 Connection Limit)
    E(#3 Connections In Use)
    F(Instance Health Check Passes)
    G(Instance Recieves Traffic)
    H(Instance Endpoint Return Error)
   
    G --> B --> C
    A --> F --> G
    E --> C
    D --> C
    C --> H
```

From the above example we can derive how the incident might have been avoided:

* The service wasn't restarted.
* The health check didn't pass.
* The purchased plan supported a higher number of connections.
* Less connections were in use.


## Tips

* Causal diagrams should consist of a list of linked events that contributed to the incident.
* These events should be things that happened as opposed to the absence of something.
