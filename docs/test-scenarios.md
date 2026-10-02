# Runtime test scenarios and results

Environment: local Docker Compose, n8n 1.121.0, and PostgreSQL. The Production Webhook endpoint used was `http://localhost:5678/webhook/reliability-lab/process`.

| Scenario | Result | Observed evidence |
|---|---|---|
| Valid Production Webhook request | **PASS** | Workflow returned success; PostgreSQL success logging was confirmed. Final post-troubleshooting request `req-final-002` returned success. |
| Required input missing | **PASS** | Validation branch returned HTTP 400. |
| Repeated `request_id` | **PASS** | Duplicate/idempotency branch handled the same request ID without a second API processing path. |
| External API transport failure | **PASS** | After retry configuration was corrected, the request returned HTTP 502. Retry handling was configured for three attempts with a 1,000 ms interval; the observed test took approximately 5.24 seconds. Normalize Result was also corrected so a missing `statusCode` on transport errors is not mistaken for success. |
| Request throttling / small batch | **PASS** | Three requests completed in approximately 4.08 seconds, passed through the per-request Wait behavior, and were recorded in PostgreSQL. |
| Unexpected main-workflow failure | **PASS** | A temporary forced failure triggered the separate Error Workflow. The Error Workflow execution showed `mode: error` and `status: success`; a row was stored in `reliability_errors`. The forced failure condition was removed and a later normal request succeeded. |

## Verification scope

These results are the runtime checks reported from the local instance. Timing values are approximate observations from that run. The batch check demonstrates per-request Wait/throttling behavior for three requests, not a global concurrency limit. The optional outbound alert webhook was not part of the runtime verification. The workflow JSON files in `../workflows/` are the current exports from the n8n 1.121.0 instance.

## Reproduction inputs

- `../sample-data/valid-request.json` — valid request example.
- `../sample-data/duplicate-request.json` — repeats the valid request ID by design.
- `../sample-data/invalid-request.json` — omits `user_id` to exercise validation.

Use new request IDs when replaying tests against a database that retains prior idempotency claims.
