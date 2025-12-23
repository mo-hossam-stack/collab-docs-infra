# ADR 003: Authentication Strategy

## Status
Accepted

## Context
Users must authenticate to access their documents. The decoupling of Frontend (Next.js) and Backend (Django) presents cross-domain authentication challenges. We need a mechanism that is secure, stateless (preferred for scaling), and compatible with standard browser security policies.

## Decision
We will use **Session-based Authentication via Cookies** (HttpOnly, Secure) for the primary web client, with optional **JWT (JSON Web Tokens)** support for future mobile or third-party API access.
*   *Implementation Note*: Currently leveraging Django's session framework exposed via API or a custom `accounts` app implementation that mimics standard session flow.

## Alternatives Considered
*   **Pure JWT stored in LocalStorage**: Vulnerable to XSS. Tokens can be stolen easily by rogue scripts.
*   **OAuth2 / Social Login Only**: Too restrictive for an initial MVP. We need email/password as a fallback.
*   **Basic Auth**: Insecure without SSL everywhere, and poor UX (browser popup).

## Consequences
### Positive
*   **Security**: HttpOnly cookies prevent XSS attacks from extracting credentials.
*   **Simplicity**: Django handles session creation and validation out of the box.

### Negative
*   **CSRF**: Cookie-based auth requires strict CSRF protection (Double Submit Cookie or similar), which can be tricky to configure across domains (Next.js server vs Browser vs Django).
*   **Stateful**: Sessions are stored in the DB (by default), putting load on the database on every request.

## Trade-offs
We prioritize security (XSS protection) over the pure statelessness of JWTs. The DB load from sessions is acceptable for the projected scale, or can be offloaded to Redis later.
