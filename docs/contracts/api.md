# API contract

Mutations return durable outcomes or explicit uncertainty. Inspection is bounded and never substitutes for the main protocol.

## API surface

| Route | Purpose |
| --- | --- |
| `POST /v1/commands` | Submit PUT, CAS, DELETE, or READ with request identity |
| `GET /v1/node` | Role, term, leader hint, commit/applied indices, limits |
| `GET /v1/log?after=...&limit=...` | Bounded metadata inspection; no unbounded dump |
| `GET /v1/snapshots` | Snapshot status and checksums |
| `GET /v1/metrics` | Counters and latency summaries |
| `POST /lab/faults` | Harness-only directed peer faults |
| `POST /lab/scenarios` | Run a named synthetic scenario |
| `GET /lab/reports/{id}` | Immutable scenario evidence |

Administrative routes bind to loopback and are clearly marked as lab controls. The harness may launch or terminate only tracked node processes. Request bodies, queues, peer messages, inspection ranges, and report sizes require explicit limits. Invalid messages produce errors without changing durable state.

## Machine-readable companions

[JSON Schemas](../../schemas/README.md), [worked examples](../../examples/README.md) and [reference SQL](../../schemas/reference-schema.sql) define proposed shapes and storage identities. Structural validation cannot replace the protocol’s state/authority checks.

Control errors distinguish malformed JSON (400), invalid contract (422), absent target (404), stale revision/identity (409), expired query pin (410), excessive bytes (413) and unavailable/backpressure (503 or explicit bounded overload). Responses include stable code/message/correlation ID and safe current-state detail. Quorum client outcomes also preserve NOT_LEADER, VERSION_CONFLICT and OUTCOME_UNKNOWN; they are not flattened into success. Lists default to 50 and at most 200 unless a stricter workload limit applies.
