# Data model contract

Durable identities and format versions connect current state, immutable history and recovery evidence.

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

## Durable application and snapshots

State changes, deduplication result, and applied index must advance atomically within each node's storage. Recovery must never apply a mutation twice because the process died between updating a value and saving its applied index.

Create snapshots only from a consistent applied prefix. Persist the snapshot and its metadata before discarding log entries it replaces. Snapshot publication must survive interruption without selecting a partially written artifact. Checksum or format errors stop that node with a clear recovery error.

Snapshot installation must preserve the included term/index, application state, tombstones, and request results. Apply the Raft snapshot/log suffix rules; do not discard valid newer committed state. A follower restored from a snapshot must catch up to the leader and reach the same state digest.

No filesystem operation should be called durable unless its flush/transaction settings are documented. Kill-process tests do not prove power-loss behavior. Corrupted state must not silently initialize a fresh cluster.
