# ADR 002: Database Choice (PostgreSQL)

## Status
Accepted

## Context
The application requires storing structured, relational data involving Users, Documents, Permissions, and potentially complex rich-text content structures. Data consistency and referential integrity are paramount.

## Decision
We will use **PostgreSQL** as the primary relational database management system.

## Alternatives Considered
*   **MySQL**: Capable, but historically less robust support for complex JSON operations (JSONB) which might be needed for document storage.
*   **MongoDB (NoSQL)**: Good for flexible document schemas, but weak on relational integrity (User <-> Document permissions). We primarily need relational structure.
*   **SQLite**: Excellent for dev, but lacks concurrency features for production load of a real-time collaborative app.

## Consequences
### Positive
*   **JSONB Support**: Allows us to store semi-structured document content (e.g., editor state) efficiently alongside relational columns.
*   **Ecosystem**: Native Django support is best-in-class.
*   **Reliability**: ACID properties ensure no data loss during concurrent edits.

### Negative
*   **Operational Overhead**: more complex to manage/tune than SQLite.
*   **Cost**: Managed Postgres instances (AWS RDS, Railway) are more expensive than simple file storage.

## Trade-offs
We prioritize data integrity and advanced query capabilities (JSONB) over initial setup simplicity.
