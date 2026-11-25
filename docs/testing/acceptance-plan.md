# Acceptance and oracle plan

Acceptance uses independent oracles and controlled fault boundaries. Every case begins NOT RUN.

## Fault scenarios

Inject interruptions before and after local append, follower persistence, majority acknowledgement, commitment, state application, response transmission, snapshot publication, and snapshot installation. Provide repeatable hooks rather than relying only on arbitrary sleeps.

Partition one node from the other two, isolate the leader, create an asymmetric link failure, delay old-term responses until after re-election, and reconnect a follower with a conflicting suffix. Run a full-cluster process restart from existing directories. In every scenario, track acknowledged operations separately from ambiguous operations.

Fault schedules are confined to the application transport and owned child processes. Do not require root, firewall changes, or access to another workspace.

## Independent correctness checks

Maintain a simple reference model for the key state and CAS semantics. Build a bounded-history linearizability checker that searches legal sequential orderings while respecting invocation/response precedence. Cap each exhaustive case at 200 operations and declare checker timeouts inconclusive, never passed.

Include incomplete and indeterminate operations as optional effects according to the checker model. Validate the checker using known legal and illegal histories, including a stale read and two successful CAS operations against one version.

For large workloads, validate committed-log/state digests, request uniqueness, and final state against a fold of the committed commands. Check sampled bounded histories separately. These checks complement one another; they do not establish that every large history has been exhaustively linearizability-checked.

## Acceptance catalog

Every item initially has status **NOT RUN**.

| ID | Required evidence and pass condition |
| --- | --- |
| QS-01 | Three nodes elect a leader and accept commands without a coordinator deciding outcomes |
| QS-02 | Persisted vote survives restart; no second vote in the same term |
| QS-03 | A candidate with an outdated log cannot win against a current majority |
| QS-04 | Follower conflict repair preserves every committed entry |
| QS-05 | Delayed old-term messages cannot roll back current term or progress |
| QS-06 | 1,000-way CAS race has exactly one winner in each of 100 rounds; all other completed results are conflicts |
| QS-07 | Every race completes within 30 seconds per round on the declared baseline, without unknown outcomes |
| QS-08 | Duplicate command after lost response produces one mutation and the same result |
| QS-09 | Same identity with different content is rejected before any second effect |
| QS-10 | Delete/recreate retains monotonic versions and rejects stale CAS |
| QS-11 | Isolated minority cannot commit newly submitted commands during a 10-second partition |
| QS-12 | Connected majority progresses during that partition |
| QS-13 | Leader crash meets the five-second recovery bar in all 20 trials |
| QS-14 | Every acknowledged mutation survives full process restart |
| QS-15 | Crash at each apply hook cannot produce double application |
| QS-16 | Snapshot restore and catch-up reproduce state and request-result digests |
| QS-17 | Interrupted snapshot publication retains a usable prior state |
| QS-18 | Corrupt snapshot fails clearly; node does not silently reset |
| QS-19 | All bounded histories in 100 seeded fault schedules pass the checker |
| QS-20 | Checker rejects supplied illegal histories and reports timeouts as inconclusive |
| QS-21 | Healthy workload meets throughput and p95 targets with durability enabled |
| QS-22 | Soak has zero safety failures and bounded queues; terminal memory remains within a declared 2 GiB combined application budget |
| QS-23 | Oversized requests and full queues return explicit errors without process failure |
| QS-24 | Browser tests cover command, partition, recovery, and report flows offline |
| QS-25 | One local command reproduces fixtures, scenario metadata, histories, and checks |
