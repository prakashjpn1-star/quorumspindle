# Delivery and release gates

Each milestone ends in runnable behavior, actual evidence, remaining failures and a continuation note.

## Work split across sessions

1. Freeze semantics, invariants, failure model, and reference histories. Verify local runtime and storage availability.
2. Build the deterministic single-node state machine, request deduplication, and atomic application.
3. Implement durable election and a controllable peer transport; test vote persistence and term transitions.
4. Add replication, conflict repair, majority commitment, and ordered application.
5. Finish client retries and replicated reads; run CAS races and minority-partition cases.
6. Implement snapshots, installation, restart, and interruption hooks.
7. Build and challenge the history checker; run seeded fault campaigns and resolve counterexamples.
8. Add the browser console and end-to-end tests.
9. Measure load and recovery, tune bounded admission without weakening durability, and complete the soak.
10. Produce the reproducible evidence bundle and review every acceptance item.

Each session ends with a runnable checkpoint, tests actually executed, remaining failures, and the next concrete task. Session length follows the program's separate time rules; this plan does not assume everything fits one session.

## Deliverables and completion evidence

Deliver source, local setup/run commands, protocol transition notes, storage format/version notes, generated fixtures, test harness, checker, basic UI, acceptance matrix, benchmark report, and a failure-analysis document with at least three reproduced bugs and their fixes if such bugs are found. Do not invent bugs to fill that document.

Reports retain seed, commit, configuration, machine details, command line, counts, percentiles, failures, and immutable history paths. Separate expected request conflicts from transport errors and safety violations. Keep raw evidence for failed runs.
