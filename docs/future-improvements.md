# Future Improvements & Roadmap

## 1. Implemented Features (Current State)
*   **Backend Core**: User Auth, Document CRUD, basic admin panel.
*   **Frontend Core**: Landing page, Dashboard, Rich Text Editor (Basic).
*   **Infrastructure**: Docker Compose, simple deployment config.

## 2. Planned Improvements

### Backend (API & Data)
| Feature | Priority | Dependencies | Notes |
| :--- | :--- | :--- | :--- |
| **Real-time Collaboration** | **High** | Redis, Django Channels | The "killer feature" for a Docs collaberation. Needs OT/CRDT logic. |
| **Full Text Search** | Medium | Postgres `tsvector` | Search across document content, not just titles. |
| **Background Tasks** | Medium | Celery/Dramatiq | Move AI processing and email sending out of the request loop. |
| **S3 Storage** | Low | AWS S3/Cloudflare R2 | Move user uploads (images in docs) off local disk to object storage. |

### Frontend (UX & Logic)
| Feature | Priority | Dependencies | Notes |
| :--- | :--- | :--- | :--- |
| **Offline Mode** | **High** | Service Workers, IndexDB | Allow editing without internet; sync when back online. |
| **Collaborator Cursors** | High | Real-time Backend | Show where other users are typing. |
| **Dark Mode Toggle** | Medium | Tailwind | System preference already detected; need UI toggle. |
| **Export to PDF** | Low | PDF Lib | Generate PDFs client-side or server-side. |

### Infrastructure & DevOps
| Feature | Priority | Dependencies | Notes |
| :--- | :--- | :--- | :--- |
| **CI/CD Pipeline** | **High**  | Automated Linting, Testing, and Deploy to Staging. |
| **Monitoring** | Medium | Prometheus/Grafana | Dashboards for Request Latency and Error Rates. |
| **K8s Manifests** | Low | Kubernetes | Helm charts for enterprise deployment. |

## 3. Long-Term Roadmap (Q1-Q2 2026)
*   **Enterprise SSO**: SAML/OIDC support for business plans.
*   **Mobile Apps**: React Native implementation reusing the existing API.
*   **Marketplace**: Allow users to publish templates.

---