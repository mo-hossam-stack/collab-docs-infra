# ADR 004: Scaling and Performance Strategy

## Status
Proposed

## Context
As a collaborative editing tool, the system may face bursty traffic and high read/write ratios. We need a strategy to handle growth without rewriting the core architecture.

## Decision
We will adopt a **Horizontal Scaling** strategy for the application layer and a **Vertical + Read-Replica** strategy for the database layer.

## Alternatives Considered
*   **Serverless (Lambda/Cloud Functions)**: Good for infrequent bursts, but "warm-up" latency is unacceptable for a real-time app. Django's boot time is non-trivial.
*   **Microservices**: Breaking the monolithic Django app into tiny services. rejected due to extreme operational complexity for a team of this size.

## Consequences
### Positive
*   **Simplicity**: Docker containers can be replicated easily (e.g., `docker-compose up --scale backend=3`).
*   **Cost Effective**: We can run on commodity VPS hardware.

### Negative
*   **Database Bottleneck**: All writes still go to a single Primary Postgres node. This is the hard scalability limit.
*   **WebSocket State**: (Future) Scaling WebSockets for collaboration requires a `Redis` backplane (Django Channels) to sync messages across containers, adding infrastructure complexity.

## Trade-offs
We accept the single-writer database limit, as it works well up to very high usage (millions of rows). We defer sharding or complex distributed databases until strictly necessary.
