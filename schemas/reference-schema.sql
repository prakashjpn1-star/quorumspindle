-- Run this node-local schema in three separate private directories.
PRAGMA foreign_keys=ON;
CREATE TABLE hard_state(id INTEGER PRIMARY KEY CHECK(id=1), cluster_id TEXT NOT NULL, node_id TEXT NOT NULL CHECK(node_id IN('node-a','node-b','node-c')), current_term INTEGER NOT NULL CHECK(current_term>=0), voted_for TEXT CHECK(voted_for IS NULL OR voted_for IN('node-a','node-b','node-c')));
CREATE TABLE log_entries(log_index INTEGER PRIMARY KEY CHECK(log_index>0), term INTEGER NOT NULL CHECK(term>0), entry_type TEXT NOT NULL CHECK(entry_type IN('COMMAND','NOOP')), client_id TEXT, operation_id TEXT, payload_digest TEXT NOT NULL, command_json TEXT, CHECK((entry_type='COMMAND' AND client_id IS NOT NULL AND operation_id IS NOT NULL AND command_json IS NOT NULL AND json_valid(command_json)) OR (entry_type='NOOP' AND command_json IS NULL)));
CREATE TABLE applied_meta(id INTEGER PRIMARY KEY CHECK(id=1), last_applied INTEGER NOT NULL CHECK(last_applied>=0), commit_index INTEGER NOT NULL CHECK(commit_index>=0), CHECK(last_applied<=commit_index));
CREATE TABLE key_state(key TEXT PRIMARY KEY, value BLOB CHECK(value IS NULL OR length(value)<=1024), version INTEGER NOT NULL CHECK(version>0), deleted INTEGER NOT NULL CHECK(deleted IN(0,1)), CHECK((deleted=1 AND value IS NULL) OR (deleted=0 AND value IS NOT NULL)));
CREATE TABLE request_results(client_id TEXT NOT NULL, operation_id TEXT NOT NULL, payload_digest TEXT NOT NULL, response_json TEXT NOT NULL CHECK(json_valid(response_json)), applied_index INTEGER NOT NULL CHECK(applied_index>0), PRIMARY KEY(client_id,operation_id));
CREATE TABLE snapshots(id TEXT PRIMARY KEY, format_version INTEGER NOT NULL, included_index INTEGER NOT NULL CHECK(included_index>=0), included_term INTEGER NOT NULL CHECK(included_term>=0), payload BLOB NOT NULL, checksum TEXT NOT NULL, state_digest TEXT NOT NULL, results_digest TEXT NOT NULL, state TEXT NOT NULL CHECK(state IN('STAGED','COMMITTED')));
CREATE TABLE selected_snapshot(id INTEGER PRIMARY KEY CHECK(id=1), snapshot_id TEXT NOT NULL REFERENCES snapshots(id));
CREATE TABLE snapshot_chunks(transfer_id TEXT NOT NULL, chunk_no INTEGER NOT NULL CHECK(chunk_no>=0), payload BLOB NOT NULL, digest TEXT NOT NULL, PRIMARY KEY(transfer_id,chunk_no));
CREATE TABLE local_audit(sequence INTEGER PRIMARY KEY, current_term INTEGER NOT NULL CHECK(current_term>=0), event_type TEXT NOT NULL, payload_json TEXT NOT NULL CHECK(json_valid(payload_json)));
CREATE INDEX log_terms ON log_entries(term,log_index);
-- HARNESS STORE: separate from all node stores; never elects or commits.
CREATE TABLE run_reports(id TEXT PRIMARY KEY, seed INTEGER NOT NULL, build TEXT NOT NULL, config_json TEXT NOT NULL CHECK(json_valid(config_json)), result TEXT NOT NULL CHECK(result IN('NOT_RUN','PASS','FAIL','INCONCLUSIVE')));
CREATE TABLE history_operations(run_id TEXT NOT NULL REFERENCES run_reports(id), operation_no INTEGER NOT NULL, invocation_tick INTEGER NOT NULL, response_tick INTEGER, command_json TEXT NOT NULL CHECK(json_valid(command_json)), response_json TEXT, PRIMARY KEY(run_id,operation_no));
-- Raft domain rules govern term/vote, committed-prefix protection, current-term
-- majority commitment and snapshot suffix retention. Local SQL is not consensus.
