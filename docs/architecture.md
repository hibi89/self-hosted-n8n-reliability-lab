# Architecture

```text
Client → Webhook → Validate → PostgreSQL atomic idempotency claim
                              ├─ invalid → HTTP 400
                              ├─ existing key → duplicate response
                              └─ claimed → 1-second rate-limit wait → JSONPlaceholder
                                  → 3 attempts / 5-second timeout
                                  → normalize → PostgreSQL success/failure log → response

Unexpected n8n error → Error Trigger workflow → normalized PostgreSQL error log
                                                → optional alert webhook
```

The primary key on `reliability_requests.request_id` makes the claim atomic under concurrent deliveries. A request ID is reserved before the external call, so retries and duplicates cannot produce a second API action. Failed IDs remain reserved intentionally; operators can inspect the log and create a new request ID for a deliberate replay.
