# Software requirements

Each Raft node owns a private durable store. A majority is two of three, not a shared database transaction or a decision by the harness. New commands, including reads, require committed and durably applied log entries.

## State model

| Entity | Minimum fields |
| --- | --- |
| Hard state | cluster ID, node ID, current term, voted-for identity |
| Log entry | index, term, command type, request identity, payload digest, payload |
| Key state | key, value or tombstone, monotonically increasing version |
| Applied state | last applied index, application state, request-result records |
| Request result | client ID, operation ID, canonical payload digest, response, applied index |
| Snapshot | included index and term, state, deduplication records, format version, checksum |
| History record | invocation/response order, operation ID, node, result, timing, fault markers |

Each key begins absent at version zero. Successful PUT, CAS, and DELETE advance its version by one. A tombstone retains the version; delete and recreate must not create an ABA version reset. A failed CAS preserves state and version. Keys and operation IDs are bounded, nonempty strings. Values are opaque bounded bytes, represented safely in JSON.

## State machine contract

- `PUT(key, value)` assigns a value and returns the new version.
- `CAS(key, expected_version, value)` succeeds only when the current version equals the supplied version. Return the actual version on conflict.
- `DELETE(key, expected_version)` follows the same version check and retains a tombstone.
- `READ(key)` returns presence, value, and version at its position in the replicated command sequence.

For the first release, reads are replicated state-machine commands. Their response is evaluated when that command is applied in log order. This favors an understandable correctness boundary over an optimized read path.

Every logical command carries a unique `(client_id, operation_id)`. Repeating an identical command returns the recorded result, including a recorded CAS conflict. Reusing the identity with different content returns `REQUEST_ID_CONFLICT`. Deduplication records remain durable for the full first-release dataset; silent expiry is prohibited.

## Election requirements

Implement the Raft rules against a reviewed transition table. A server persists its new term and vote before granting a vote or sending messages that depend on that durable state. A node grants at most one vote per term. A candidate's log must satisfy the up-to-date rule.

Use randomized election timeouts and monotonic local elapsed time. Expose timeout bounds in configuration and seed randomness in deterministic tests. Wall-clock changes must not determine commitment safety.

Higher-term messages make a node update its term and step down as required. Delayed responses from an earlier election or replication attempt must not overwrite newer state. Two nodes may temporarily believe they are leaders in different terms; the required guarantee is that conflicting commands cannot both become committed at the same log position.

## Replication and commitment

Append locally and durably before claiming durable replication. Followers check the previous index and term, reject mismatches, and repair only uncommitted conflicting suffixes. A committed prefix must never be overwritten.

Track per-follower progress with term-aware responses. A leader advances commitment using a majority and the Raft restriction on directly committing entries from its current term. Earlier entries become committed through the resulting committed prefix.

Apply committed entries strictly in index order. An API success requires the relevant entry to be committed and its state-machine result to be durably applied. A successful leader response based only on its own append is an acceptance failure.

## Ambiguous outcomes and retries

A timeout or lost connection means the result may be unknown. It must not be represented as proof that no mutation happened. Clients retry with the same request identity. Responses distinguish success, version conflict, request identity conflict, not-leader, temporary unavailability, overload, and outcome-unknown.

Followers may return leader hints. They must not answer linearizable reads from their local state. An isolated old leader cannot complete newly submitted commands without a majority. It may still return a previously committed and durably recorded result for a retry, provided the response identifies that prior operation.

## Durable application and snapshots

State changes, deduplication result, and applied index must advance atomically within each node's storage. Recovery must never apply a mutation twice because the process died between updating a value and saving its applied index.

Create snapshots only from a consistent applied prefix. Persist the snapshot and its metadata before discarding log entries it replaces. Snapshot publication must survive interruption without selecting a partially written artifact. Checksum or format errors stop that node with a clear recovery error.

Snapshot installation must preserve the included term/index, application state, tombstones, and request results. Apply the Raft snapshot/log suffix rules; do not discard valid newer committed state. A follower restored from a snapshot must catch up to the leader and reach the same state digest.

No filesystem operation should be called durable unless its flush/transaction settings are documented. Kill-process tests do not prove power-loss behavior. Corrupted state must not silently initialize a fresh cluster.
