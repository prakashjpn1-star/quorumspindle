# Persistence ordering and transaction protocol

Each Raft node owns a private durable store. A majority is two of three, not a shared database transaction or a decision by the harness. New commands, including reads, require committed and durably applied log entries.

## Local mutation boundary

1. Bound/parse the request and compute canonical content before a local writer.
2. Acquire the local write transaction before reading mutable guards/accounting.
3. Check stable request identity, expected state and current epoch/term/fence.
4. Apply related state, durable cursor/result and audit/receipt atomically.
5. Commit before sending any response that claims this durability boundary.

A local transaction is not consensus commit. A follower durable append acknowledgement contributes to majority replication; a client success additionally needs Raft commitment and durable state-machine application.

## Ordering and retries

Use hard metadata/aggregate, sorted child records, cursor/result, then audit within each writer. Do not hold a writer across peer/network I/O, human decisions or unbounded scans. Roll back complete transient storage-conflict operations, preserving logical identity. A lost COMMIT response is uncertain; resolve with a fresh durable lookup rather than assuming rollback.

Read related bounds/pointer/cursor data in a coherent snapshot. Every accepted contiguous position comes from transactional allocation, not a rollback-gapping external sequence. Term/vote persist before election-dependent messages; log entries persist before replication acknowledgements; key/result/applied index advance together.

Use monotonic elapsed clocks for local election/deadline measurements; durable timestamps are explicit metadata where needed. Clock changes cannot determine commitment safety.

## Storage safeguards

NOT NULL identities, unique logical keys, foreign keys and bounded enums support the proof. Immutable history, monotonic cursors and legal state transitions also need service guards and migration-level triggers. Full-disk/checksum/incompatible-format errors fail clearly; startup never silently resets state. Process-kill evidence does not prove arbitrary power-loss or disk-corruption survival.
