# Source requirement and acceptance traceability

Every numbered source section maps below. Section 2 remains an external ownership/approval gate, preserved in the archive. Behavioral prose and tables retain their source meaning.

| Source section | Active contract | Component |
| --- | --- | --- |
| 1. Project in one paragraph | [Read](../requirements/product.md) | Cross-component gate |
| 2. Ownership and submission status | [Archive](../source/README.md) | Cross-component gate |
| 3. Required outcome | [Read](../requirements/product.md) | Cross-component gate |
| 4. Scope and boundaries | [Read](../requirements/product.md) | Cross-component gate |
| 5. Local scale and pass bars | [Read](../requirements/quality-and-load.md) | Cross-component gate |
| 6. Architecture | [Architecture](../architecture/high-level-design.md) | [Controlled peer transport admission and client uncertainty](../design/transport.md) |
| 7. State model | [Read](../requirements/software.md) | [Single-key semantics logged reads and deduplication](../design/state-machine.md) |
| 8. State machine contract | [Read](../requirements/software.md) | [Single-key semantics logged reads and deduplication](../design/state-machine.md) |
| 9. Election requirements | [Read](../requirements/software.md) | [Durable elections votes and term transitions](../design/elections.md) |
| 10. Replication and commitment | [Read](../requirements/software.md) | [Log matching conflict repair and majority commitment](../design/replication.md) |
| 11. Ambiguous outcomes and retries | [Read](../requirements/software.md) | [Single-key semantics logged reads and deduplication](../design/state-machine.md) |
| 12. Durable application and snapshots | [Read](../requirements/software.md) | [Node durability atomic application and snapshots](../design/storage-snapshots.md) |
| 13. API surface | [Read](../contracts/api.md) | [Controlled peer transport admission and client uncertainty](../design/transport.md) |
| 14. Basic browser UI | [Read](../requirements/browser.md) | Cross-component gate |
| 15. Fault scenarios | [Read](../testing/acceptance-plan.md) | Cross-component gate |
| 16. Independent correctness checks | [Read](../testing/acceptance-plan.md) | [Independent bounded-history checker and large-run audits](../design/checker.md) |
| 17. Acceptance catalog | [Read](../testing/acceptance-plan.md) | Cross-component gate |
| 18. Work split across sessions | [Read](../delivery/milestones.md) | Cross-component gate |
| 19. Stack and desktop fit | [Architecture](../architecture/high-level-design.md) | Cross-component gate |
| 20. Deliverables and completion evidence | [Read](../delivery/milestones.md) | Cross-component gate |
| 21. Risks and decisions to resolve | [Architecture](../architecture/high-level-design.md) | Cross-component gate |
| 22. Primary technical reference | [Read](../architecture/references.md) | Cross-component gate |

## Acceptance coverage

| ID | Durable pass oracle | Outcome |
| --- | --- | --- |
| QS-01 | Three nodes elect a leader and accept commands without a coordinator deciding outcomes | NOT RUN |
| QS-02 | Persisted vote survives restart; no second vote in the same term | NOT RUN |
| QS-03 | A candidate with an outdated log cannot win against a current majority | NOT RUN |
| QS-04 | Follower conflict repair preserves every committed entry | NOT RUN |
| QS-05 | Delayed old-term messages cannot roll back current term or progress | NOT RUN |
| QS-06 | 1,000-way CAS race has exactly one winner in each of 100 rounds; all other completed results are conflicts | NOT RUN |
| QS-07 | Every race completes within 30 seconds per round on the declared baseline, without unknown outcomes | NOT RUN |
| QS-08 | Duplicate command after lost response produces one mutation and the same result | NOT RUN |
| QS-09 | Same identity with different content is rejected before any second effect | NOT RUN |
| QS-10 | Delete/recreate retains monotonic versions and rejects stale CAS | NOT RUN |
| QS-11 | Isolated minority cannot commit newly submitted commands during a 10-second partition | NOT RUN |
| QS-12 | Connected majority progresses during that partition | NOT RUN |
| QS-13 | Leader crash meets the five-second recovery bar in all 20 trials | NOT RUN |
| QS-14 | Every acknowledged mutation survives full process restart | NOT RUN |
| QS-15 | Crash at each apply hook cannot produce double application | NOT RUN |
| QS-16 | Snapshot restore and catch-up reproduce state and request-result digests | NOT RUN |
| QS-17 | Interrupted snapshot publication retains a usable prior state | NOT RUN |
| QS-18 | Corrupt snapshot fails clearly; node does not silently reset | NOT RUN |
| QS-19 | All bounded histories in 100 seeded fault schedules pass the checker | NOT RUN |
| QS-20 | Checker rejects supplied illegal histories and reports timeouts as inconclusive | NOT RUN |
| QS-21 | Healthy workload meets throughput and p95 targets with durability enabled | NOT RUN |
| QS-22 | Soak has zero safety failures and bounded queues; terminal memory remains within a declared 2 GiB combined application budget | NOT RUN |
| QS-23 | Oversized requests and full queues return explicit errors without process failure | NOT RUN |
| QS-24 | Browser tests cover command, partition, recovery, and report flows offline | NOT RUN |
| QS-25 | One local command reproduces fixtures, scenario metadata, histories, and checks | NOT RUN |
