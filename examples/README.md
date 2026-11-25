# Worked examples and oracle fixtures

These small fictional inputs explain contract boundaries. They are not completed benchmarks or runtime evidence. Exact IDs, epochs/terms and result versions depend on the stated isolated preconditions.

| Example | Schema | Interpretation |
| --- | --- | --- |
| [put-command.json](put-command.json) | [command](../schemas/command.schema.json) | Opaque bytes for text 1. Actual decoded values must be <=1 KiB. |
| [cas-command.json](cas-command.json) | [command](../schemas/command.schema.json) | One logical identity across retries; only one winner against version 1 in a race. |
| [read-command.json](read-command.json) | [command](../schemas/command.schema.json) | A new READ enters the replicated log and answers only after committed application. |
| [vote-request.json](vote-request.json) | [request-vote](../schemas/request-vote.schema.json) | Fields are illustrative; the node must enforce persisted vote and log up-to-date rules. |
| [heartbeat-request.json](heartbeat-request.json) | [append-entries](../schemas/append-entries.schema.json) | A heartbeat still checks term/log continuity and cannot authorize minority commitment. |
| [legal-cas-history.json](legal-cas-history.json) | [history](../schemas/history.schema.json) | Concurrent CAS operations can linearize with c1 winning and c2 observing version 2. |
| [illegal-two-winners.json](illegal-two-winners.json) | [history](../schemas/history.schema.json) | The checker must reject two successes against the same expected version. This deliberately invalid behavior is a test oracle, not a passing run. |
| [leader-isolation.json](leader-isolation.json) | [fault-schedule](../schemas/fault-schedule.schema.json) | Assumes node-a is elected before the hook; the harness must verify the intended 10-second isolation actually occurred. |

The known-illegal history is intentionally semantically impossible even though its JSON structure is valid. A checker that accepts it is defective.

Retry the same logical intent under its original identity. Do not silently rewrite expected revisions, terms, epochs, cursors or digests to force a stale operation through. Large fixture generation, actual checksums and measured runs remain implementation deliverables.
