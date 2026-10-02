-- Reliability Lab application tables.
-- Mounted into the official PostgreSQL image's init directory by Compose.

CREATE TABLE IF NOT EXISTS reliability_requests (
    request_id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    query_text TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    result JSONB,
    error_type TEXT,
    error_message TEXT
);

CREATE TABLE IF NOT EXISTS reliability_errors (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL,
    request_id TEXT,
    status TEXT NOT NULL,
    error_type TEXT NOT NULL,
    message TEXT NOT NULL,
    last_node TEXT,
    workflow_id TEXT,
    workflow_name TEXT,
    execution_id TEXT
);
