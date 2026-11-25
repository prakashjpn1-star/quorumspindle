# Product requirements

Run three real local servers that agree on single-key state despite crashes, partitions and delayed messages. Make every acknowledged command explainable through durable votes, replicated log history and applied results.

## Project in one paragraph

Build a small, real consensus system that keeps three independently running server processes in agreement while clients race to change shared state. The engine must continue through a leader crash, refuse unsafe writes during a network partition, recover its durable history, and expose enough evidence to explain every successful operation. A key/value and compare-and-set API makes the agreement observable. The main product is the replication and recovery engine; a local browser console helps investigate it.

This is intended for engineers who want a checkable implementation of the mechanisms behind reliable coordination services. The difficult part is deciding when an operation is safe to acknowledge, especially when messages and processes fail at inconvenient moments.

## Required outcome

Deliver three local server processes, each with its own durable directory, a client and fault-test harness, an independent bounded-history checker, a benchmark runner, and a basic browser UI. Implement the Raft election, replication, commitment, and snapshot logic. A local transactional database or file library may provide storage primitives. Using an existing consensus service or consensus library as the engine does not meet the core goal.

The release is complete only when the correctness suite passes, fault histories are reproducible, and the measured workload meets the declared local pass bars. A running dashboard alone is insufficient.

## Scope and boundaries

Required: fixed three-node membership; leader election; replicated commands; durable votes and log entries; linearizable reads; request deduplication; conflict repair; snapshots; restart; process and message fault injection; browser inspection; automated evidence.

Deferred: dynamic membership, cross-region deployment, Byzantine faults, arbitrary transactions spanning keys, public authentication, production TLS administration, clock-lease reads, and operating a real customer service. The API is a single-key state machine, not a general database.

All nodes run on one machine. This tests process failures and controlled communication failures. It does not demonstrate survival of independent machine, disk, power, or datacenter failures.
