# Local setup shutdown and restore

The runtime setup will inventory permitted interpreters/drivers/packages, pin exact versions and record synchronous settings. Product launch/test commands are future implementation deliverables, not commands already available in this documentation baseline. The browser and services work offline over loopback.

Normal startup validates identity, schema and checksums; it never auto-resets. Explicit migrations have checksums, compatibility guards and prior verified backup. Live data belongs in separate local runtime directories, not this synchronized checkout.

Each node restores/restarts from its own directory; current term/vote/log and last applied state remain durable. Cluster initialization is a distinct explicit action. Snapshot installation is a Raft protocol step, not copying a leader’s live database over another node. A coordinated cold backup may preserve all three stores for lab reproduction, but that is not independent-machine failure tolerance.

Use the selected database’s consistent backup facility or quiesce/close stores before copying. A live main-file copy omitting WAL-visible commits is not a backup. Restore into new isolated paths, verify integrity and format, preserve original files, then restart with fresh process identity where required. A snapshot cannot recover later commits it never contained.

Graceful shutdown stops admission and drains bounded current transactions. Hard-stop behavior follows the protocol’s durable positions, not guessed response outcomes. Record actual readiness/recovery errors and retain evidence.
