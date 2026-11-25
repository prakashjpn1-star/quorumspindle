# Review findings and resolved boundaries

| Risk | Design response |
| --- | --- |
| Vote or term response sent before persistence | Hard state commits before the dependent vote/RPC response. |
| Local append mistaken for commit | Success requires majority commitment and durable ordered application. |
| Snapshot loses dedup results | Snapshot includes applied state, tombstones and all retained request results. |
| Checker certifies a timed-out search | Timeout is INCONCLUSIVE; adversarial illegal histories challenge the checker. |

The reference stack is Python/local SQLite/HTML-CSS-JavaScript, with exact permitted dependencies still open. This resolves the language direction without claiming desktop/package verification. Required oracle independence, concurrency, resource and pass bars remain intact.

Original ownership/approval wording is archived separately. Active documents contain technical requirements and explicit design choices, not instructions to compose participant submission answers. AI assistance remains disclosed. Runtime performance, correctness and programme approval are not implied by the documentation.
