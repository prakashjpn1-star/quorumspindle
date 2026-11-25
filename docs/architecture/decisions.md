# Architecture decisions

## ADR 1 Reference runtime and UI

The reference direction is a supported Python interpreter, a bounded loopback HTTP layer, standard-library SQLite access and locally served HTML/CSS/JavaScript. Exact HTTP/schema/canonicalization packages and versions remain pending permitted-environment inventory. Optional TypeScript compiles locally; no frontend framework or remote assets are required.

## ADR 2 Storage boundary

Each Raft node owns a private durable store. A majority is two of three, not a shared database transaction or a decision by the harness. New commands, including reads, require committed and durably applied log entries.

Use explicit local transactions, foreign keys and documented synchronous durability. SQLite supplies storage primitives only: its [transaction rules](https://www.sqlite.org/lang_transaction.html) do not implement the project protocol. The reference uses WAL/FULL on supported local disk outside synchronized folders. Each node has a different database and private directory. There is no shared database that elects leaders or commits commands.

## ADR 3 Explicit identities and canonical content

Propose RFC 8785 JSON plus SHA-256 for immutable payload/digest identity, checked against standard vectors before implementation. Nonfinite JSON, duplicate keys and unsupported schemas are rejected. Logical IDs survive transport retries; epochs/fences authorize a particular execution, not the business identity itself.

## ADR 4 Correctness before optimization

Reads are replicated commands; fixed membership and persisted votes follow the [Raft extended paper](https://raft.github.io/raft.pdf). No clock-lease read optimization or imported consensus engine is part of the baseline.

## Open implementation decisions

Pin permitted dependencies, schema/format versions, configured bounds and measured desktop settings before runtime development. Snapshot checksums, independent oracle behavior and protocol transition tables require actual tests. Performance misses remain failures until diagnosed or explicitly revised; design prose does not waive the pass bars.
