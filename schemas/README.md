# Schema catalog and storage reference

JSON Schemas use draft 2020-12 and describe proposed version 1 wire/document shapes. They complement the [API](../docs/contracts/api.md) and [data model](../docs/contracts/data-model.md).

| Schema | Purpose |
| --- | --- |
| [command.schema.json](command.schema.json) | Replicated client command |
| [request-vote.schema.json](request-vote.schema.json) | Raft vote request |
| [append-entries.schema.json](append-entries.schema.json) | Raft replication request |
| [snapshot-manifest.schema.json](snapshot-manifest.schema.json) | Durable state-machine snapshot manifest |
| [fault-schedule.schema.json](fault-schedule.schema.json) | Bounded directed local fault schedule |
| [history.schema.json](history.schema.json) | Bounded checker input history |

[Reference SQL](reference-schema.sql) supplies principal relational constraints and indexes. Sections labeled separate stores belong in different databases. Real migrations need version/checksum guards, immutable-field triggers and the complete domain protocol. No setup result proves runtime safety.

Schema validation does not prove current term/epoch/fence, contiguous sequence, exact definition/manifest identity, safe retention, complete worker sets or correct state transitions. Strict parsing and domain transactions handle those rules. Keys/strings and arrays are bounded; proposed structural maxima need configuration review before implementation. Byte limits apply to decoded/canonical bytes, not merely character length.

Base64 syntax/contentEncoding does not prove decoded length or canonical form; decode/re-encode and enforce <=1 KiB. RPC terms/index relationships, NOOP versus command fields, snapshot safety and trusted membership require runtime checks.

Examples contain fictional readable identities and no real credentials or fabricated fixture checksums.
