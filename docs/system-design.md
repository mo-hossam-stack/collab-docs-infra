# System Design Document

## 1. Introduction
This document outlines the architectural design of the Google Docs Clone project. It follows the C4 model to describe the system at different levels of abstraction.

## 2. C4 Model

### 2.1 Context Diagram
**Description**: The system interacting with external entities.
*   **User**: End-user accessing the application via a web browser.
*   **System**: The "Docs Clone" platform.
*   **External AI Service**: (Optional) OpenAI/Gemini API for text processing.

**Flow**: User -> HTTPS -> System -> HTTPS -> External AI.

### 2.2 Container Diagram
**Description**: High-level containers that make up the system.

| Container | Technology | Description |
| :--- | :--- | :--- |
| **Web Application** | Next.js (React) | Distributes UI assets (JS/CSS/HTML). Handles client-side logic. |
| **API Server** | Django + Gunicorn | Processes API requests, enforces auth, executes business logic. |
| **Database** | PostgreSQL | Stores persistent data (Users, Docs, Content). |
| **Reverse Proxy** | Nginx / Cloud LB | Terminate SSL, route traffic, serve static assets. |

### 2.3 Component Diagram (API Server)
**Description**: Decomposition of the Django API Server.
*   **Accounts App**: Handles User Registration, Authentication (JWT), Profile management.
*   **Hello/Home App**: Landing page logic.
*   **Documents App**: Core domain logic.
    *   `Document` Model: Stores title, content (JSON/Text), owner.
    *   `DocumentViewSet`: CRUD interfaces.
*   **AI App**: Interfaces with LLMs for summarization or text generation.

## 3. Request Lifecycle
1.  **Ingress**: Request hits the Load Balancer/Proxy on port 80/443.
2.  **Routing**: `/api/*` requests routed to Gunicorn (Django). Other requests routed to Next.js.
3.  **Middleware Processing**: Django SecurityMiddleware, CORS, User Authentication.
4.  **View Execution**: DRF Serializers validate input -> Model fetch/save -> Response generation.
5.  **Database Interaction**: SQL transactions managed by Django ORM (atomic requests).

## 4. Data Flow & Schema Design
### Conceptual Schema
*   **User** (1) <---> (N) **Document**: A user owns multiple documents.
*   **Document** (1) <---> (N) **Collaborator**: (Planned) Many-to-many through a join table for shared access.

### Critical Tables
*   `accounts_user`: Custom user model (email, password_hash, is_active).
*   `documents_document`: (id, title, content, created_at, updated_at, user_id).

## 5. Scalability Strategy
*   **Stateless Backend**: The Django API is stateless. Session data is stored in the DB (or Redis in future). This allows running $N$ replicas of the API container.
*   **Read Replicas**: Database reads can be offloaded to Postgres read replicas for high-traffic endpoints (e.g., viewing public docs).
*   **CDN**: Static files (JS bundles, Images) served via CDN to reduce server load.

## 6. Caching Strategy
*   **Browser Caching**: Aggressive caching for immutable static assets (hashed filenames).
*   **Application Caching**: (Planned) Redis to cache frequent API responses that rarely change (e.g., user profile data).
*   **Query Caching**: Django's internal query cache for repeated lookups in same request.

## 7. Authentication & Authorization
*   **Auth**: JWT (JSON Web Tokens) or Session Cookies.
    *   *Current Choice*: Check `settings.py` (Likely Session or Simple JWT).
*   **Authorization**: Row-level permissions.
    *   Users can only edit documents they own.
    *   Permissions enforced via DRF `IsAuthenticated` and custom `IsOwner` classes.

## 8. Error Handling & Observability
*   **Structured Logging**: All 5xx errors logged with stack traces to stdout (captured by Docker logs).
*   **API Errors**: Standardized JSON error responses: `{ "detail": "Error message", "code": "error_code" }`.
*   **Monitoring**: (Recommended) Sentry for error tracking; Prometheus for metric scraping.

---