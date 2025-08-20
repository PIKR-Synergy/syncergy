# Copilot Instructions for Syncergy CMS

## Big Picture Architecture
- **Monorepo** with `backend` (Node.js/Express) and `frontend` (React/Next.js) folders.
- **Backend** exposes RESTful APIs for user, session, rapat, konseling, program kerja, kegiatan, tamu, file uploads, and audit/logging.
- **Frontend** consumes backend APIs, handles UI/UX, and session management.
- **Database**: MySQL schema defined in `dev-note/database.sql` (import required for setup).
- **Roles**: Rich user role system (admin, ketua, wakil, bendahara, sekretaris, kominfo, humas, konselor, pendidik_sebaya, anggota, tamu).

## Developer Workflows
- **Backend setup**:
  - `cd backend && npm install`
  - Copy `.env.example` to `.env` and configure DB connection.
  - Import `dev-note/database.sql` into MySQL.
  - Start backend: `npm run dev` (default port: 3001).
- **Frontend setup**:
  - `cd frontend && npm install`
  - Start frontend: `npm run dev` (default port: 5173 or as configured).
- **Database**:
  - Import schema: `SOURCE d:/Pribadi/xampp/htdocs/CMS/dev-note/database.sql;` in MySQL.
  - Default users/passwords are set; change after install.
- **Testing**: No explicit test runner found; follow Node.js/Express/React conventions if adding tests.

## Project-Specific Patterns & Conventions
- **API routes**: Backend routes are modularized in `src/routes/` (e.g., `auth.js`, `dashboard.js`, `pengurus.js`).
- **Session & audit**: Session management and audit logging are first-class features (see `user_sessions`, `activity_logs`).
- **Soft delete**: Use `deleted_at` fields for soft deletion.
- **Password policy**: Enforced via triggers and procedures in DB.
- **Stored procedures/events**: DB triggers, procedures, and events automate reporting, cleanup, and security.
- **Frontend-backend communication**: Always via REST API, JSON format, with token-based authentication (JWT in `Authorization` header).
- **Error handling**: Standard REST error codes and JSON error responses.

## Integration Points
- **Frontend**: Communicates with backend via REST endpoints (see API table in `dev-note/README.md`).
- **Database**: All business logic, audit, and versioning are tightly coupled to MySQL procedures/events.
- **File uploads**: Handled via dedicated API endpoints.
- **Session & security**: Custom middleware for logging and rate limiting.

## Key Files & Directories
- `backend/src/routes/` — API route definitions
- `backend/src/db.js` — DB connection logic
- `dev-note/database.sql` — DB schema, triggers, procedures, events
- `dev-note/README.md` — Architecture, workflows, API reference
- `backend/README.md` — Quickstart for backend setup

## Examples
- To add a new API route, create a file in `backend/src/routes/` and register it in `src/index.js`.
- To update DB schema, edit `dev-note/database.sql` and re-import.
- To enforce password policy, check DB triggers and procedures.

---

**For unclear or missing conventions, consult `dev-note/README.md` and `database.sql` comments.**

---

*Last updated: August 2025*
