# ADR 001: Initial Architecture Strategy (Decoupled Frontend/Backend)

## Status
Accepted

## Context
The project requires a high degree of interactivity (Google Docs editing) while maintaining a robust, secure data layer. Traditional Django templates offer tight integration but lack the modern, client-side state management capabilities required for complex real-time applications. Conversely, a full Single Page Application (SPA) can suffer from SEO and initial load time issues.

## Decision
We will adopt a **Decoupled Architecture**:
1.  **Backend**: Django + Ninja as a headless API.
2.  **Frontend**: Next.js (App Router) as a standalone client consuming the API.

## Alternatives Considered
*   **Django Templates + HTMX**: Good for simplicity, but managing complex, concurrent text editing state solely in the DOM/Server fragments is brittle compared to React's state model.
*   **Django + React (embedded)**: Serving React bundles within Django templates. Complicates the build pipeline and development experience (no hot-reloading out of the box).
*   **MERN Stack**: Too loose on data structure. We need the rigid schema and admin tools Postgres and Django provide.

## Consequences
### Positive
*   **Separation of Concerns**: Backend focuses on data/logic, Frontend on UI/UX.
*   **Hiring**: Can hire specialized React devs and Python devs independently.
*   **Multi-Client Ready**: The API can eventually serve Mobile Apps (iOS/Android) without changes.

### Negative
*   **Complexity**: Two distinct build pipelines, two deployments.
*   **Auth Friction**: Maintaining auth state between distinct domains/ports requires careful JWT/Cookie handling.
*   **Duplication**: Types/Validations often need to be defined in both Python and TypeScript.

## Trade-offs
We accept the operational complexity of managing two services in exchange for superior user experience and future-proofing for multi-platform support.
