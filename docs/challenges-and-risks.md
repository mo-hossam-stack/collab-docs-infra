# Challenges and Risks

## 1. Technical Challenges

### 1.1 Synchronization of Decoupled State
**Challenge**: The Next.js frontend and Django backend maintain separate state. Keeping them in sync (e.g., user is logged out on backend but session invalidation hasn't reached frontend) causes race conditions.
**Status**: Partially Mitigated.
**Mitigation**:
*   Implemented strict 401 error handling interceptors in the frontend `API Client` to trigger immediate client-side redirection to login.
*   Future: Implement WebSockets for real-time state push (e.g., "User B deleted this doc").

### 1.2 Database Connection Saturation
**Challenge**: Django's synchronous nature means every concurrent request holds a database connection open for its duration. Under load, Postgres `max_connections` can be exhausted.
**Status**: Watch Item.
**Mitigation**:
*   Use `PgBouncer` for connection pooling (Planned).
*   Optimize Views to be faster (less time holding connections).

## 2. Scaling Bottlenecks

### 2.1 Single Writer Database
**Challenge**: We have one primary Postgres instance. Write-heavy workloads (e.g., 1000 users typing simultaneously) will hit IOPS limits.
**Mitigation Strategy**:
*   **Batching**: Frontend debounces save requests (autosave every 2s, not keypress).
*   **Operational Transformation (OT)**: Move collaborative logic to an in-memory Redis layer before flushing to SQL.

### 2.2 Build Times
**Challenge**: Next.js build times increase linearly with the number of generated static pages.
**Mitigation Strategy**:
*   Use Incremental Static Regeneration (ISR).
*   Split the app into smaller micro-frontends if it grows beyond 50k LOC.

## 3. Security Risks

### 3.1 XSS (Cross Site Scripting)
**Risk**: Storing document content as raw HTML exposes users to script injection if they view malicious documents.
**Mitigation**:
*   **Strict Sanitization**: All content rendering on Frontend must pass through `dompurify` or similar library before being dangerously set as innerHTML.
*   **CSP**: Strict Content Security Policy headers.

### 3.2 Improper Access Control (IDOR)
**Risk**: A user guessing a Document ID `123` and viewing it without permission.
**Mitigation**:
*   **UUIDs**: Use UUIDs instead of auto-increment integers for Document IDs.
*   **Permission Classes**: Every viewset explicitly checks `request.user == document.owner` or `request.user in document.collaborators`.

---
**Note for APT Packaging**:
Location: `/usr/share/doc/my-project/challenges-and-risks.md`.
