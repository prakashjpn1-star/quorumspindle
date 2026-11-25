# Quality workload and resource requirements

Correctness and local workload pass bars are explicit release requirements. None is a measured result yet.

## Local scale and pass bars

| Workload | Required target |
| --- | --- |
| Cluster | Three actual server processes; majority is two |
| Stored state | 50,000 synthetic keys, with values up to 1 KiB |
| Healthy benchmark | At least 200 completed successful operations/second for 60 measured seconds after warm-up; 70% writes/CAS and 30% reads; p95 latency at most 2 seconds |
| Client population | 1,000 logical client tasks; at most 256 simultaneous client TCP connections; client queuing time included in end-to-end latency |
| CAS race | 1,000 distinct contenders against the same expected version, repeated for 100 rounds; exactly one successful mutation each round |
| Recovery | After a leader is killed, a stable connected majority resumes successful commands within 5 seconds in 20 consecutive trials |
| Fault campaign | At least 100 seeded schedules, including partitions, delayed replies, crashes, and snapshot restoration |
| Soak | 30 minutes at 100 offered operations/second, with bounded request admission and explicit overload responses |

These are proposed local acceptance thresholds, not observed results or production capacity claims. Record CPU, memory, filesystem, runtime, storage durability settings, and commit hash. If the supplied desktop cannot sustain a threshold, report the measured result and revise the scope openly before approval or acceptance; do not replace measurement with extrapolation.
