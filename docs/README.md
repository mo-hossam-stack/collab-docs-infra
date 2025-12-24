# Collaborative document editor with Django & Next.js

## Project Overview
This project is a high-performance, real-time collaborative document editing platform designed to mimic the core functionality of Google Docs. It leverages a hybrid architecture with a robust Django backend for data integrity and complex business logic, paired with a Next.js frontend for a highly interactive, SEO-friendly user experience.

## High-Level Architecture
The system follows a headless architecture pattern:
- **Backend (API Layer)**: Django + Ninja. Serves as the source of truth for data, authentication, and business logic. Exposes a JSON API.
- **Frontend (Presentation Layer)**: Next.js (App Router). Consumes the backend API to render UI. Handles client-side routing and interactive state.
- **Database**: PostgreSQL. Primary relational store for user profiles, documents, and content.
- **Infrastructure**: Dockerized services orchestrated via Docker Compose for dev/prod parity. Ready for deployment on platforms like Railway.

## Tech Stack
### Backend
- **Framework**: Django 5.x, Ninja
- **Database**: PostgreSQL 17
- **Auth**: JWT / Session-based (custom implementation in `accounts` app)
- **AI Integration**: Custom AI module (`ai` app) for text enhancement features.

### Frontend
- **Framework**: Next.js 15+
- **Styling**: TailwindCSS
- **Language**: JavaScript

### Infrastructure
- **Containerization**: Docker, Docker Compose
- **Web Server**: Gunicorn (for Django)
- **Reverse Proxy**: Nginx (implied for production, or cloud provider routing)

## Non-Functional Requirements
- **Scalability**: Stateless backend design allows horizontal scaling of Django containers behind a load balancer. Next.js can be deployed to edge networks (Vercel/Cloudflare) or containerized.
- **Security**: 
    - CSRF protection enabled for state-changing requests.
    - Secure password hashing (Argon2/PBKDF2 via Django).
    - Environment variable management for secrets.
- **Performance**:
    - Optimistic UI updates on the frontend.
    - Efficient SQL queries with select_related/prefetch_related.
    - Postgres connection pooling (via middleware or PGBouncer recommended for scale).

## End-to-End System Flow
1.  **User Request**: User visits the Next.js frontend.
2.  **Rendering**: Next.js serves the initial page (SSR or Static).
3.  **Interaction**: User performs an action (e.g., "Create Document").
4.  **API Call**: Next.js sends an authenticated HTTP POST request to Django.
5.  **Processing**: Django validates the request, writes to PostgreSQL, and returns a JSON response.
6.  **Update**: Frontend updates the UI state based on the response.

## Current Service Status
| Component | Status | Notes |
| :--- | :--- | :--- |
| **User Authentication** | not Implemented | Registration, Login using `accounts` app. |
| **Document Management** | not Implemented | CRUD operations in `documents` app. |
| **Profiles** | not Implemented | User profile management. |
| **AI Features** | 🚧 In Progress | Integration logic exists in `ai` app. |
| **Real-time Collab** |  not Implemented | WebSocket/Channels integration pending. |
| **Infrastructure** | not Implemented | Docker Compose & Railway config ready. |

---
