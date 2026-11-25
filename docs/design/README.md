# Low-level component designs

The [transaction rules](transactions.md) and [state machines](state-machines.md) apply across components.

- [Single-key semantics logged reads and deduplication](state-machine.md)
- [Durable elections votes and term transitions](elections.md)
- [Log matching conflict repair and majority commitment](replication.md)
- [Node durability atomic application and snapshots](storage-snapshots.md)
- [Controlled peer transport admission and client uncertainty](transport.md)
- [Independent bounded-history checker and large-run audits](checker.md)
- [Storage](storage.md)
- [Browser/API modules](browser.md)
- [Observability](observability.md)

The component algorithms identify atomic boundaries, failure outcomes and source contracts. [Schemas/examples](../../schemas/README.md) make the request formats concrete.
