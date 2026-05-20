# CoffeeCode — AGENTS.md

## Project structure

Monorepo with **two separate packages** (no root workspace):

- `backend/` — Node.js + Express 5 + PostgreSQL (Supabase) + Socket.IO
- `front-end/` — Vue 3 + TypeScript + Vite + Pinia + Vue Router

No CI, no pre-commit hooks, no Docker, no test framework.

## Setup

```sh
# Backend
cd backend
npm install
# requires backend/.env (gitignored) — see .env.example or Supabase project
npm run dev   # (none defined — start via: node index.js)

# Frontend
cd front-end
npm install
npm run dev          # Vite dev server on http://localhost:5173
```

Frontend CORS is configured to `http://localhost:5173` only. Backend runs on port 3000.

## Frontend commands (all from `front-end/`)

| Command | What it runs |
|---|---|
| `npm run dev` | `vite` (hot-reload dev server) |
| `npm run build` | `type-check && vite build` (type-check before build) |
| `npm run type-check` | `vue-tsc --build` |
| `npm run lint` | oxlint → eslint (both with `--fix`), no prettier |
| `npm run format` | `prettier --write src/` |

Lint order: oxlint first, then ESLint. Both auto-fix by default.

## API conventions

- All routes under `/api/...` (e.g. `/api/ordenes`, `/api/productos`)
- Auth via `auth-token` header (JWT, not `Authorization: Bearer`)
- Response shape: `{ status: "..." , mensaje: "..." , ... }`
- Protected routes use `verificarToken` middleware from `backend/middleware/auth.js`
- JWT secret from `process.env.JWT_SECRET`

## Database

- PostgreSQL via Supabase, connection string in `backend/.env`
- Uses `pg` `Pool` with SSL (`rejectUnauthorized: false`) — see `backend/db.js`

## Frontend specifics

- Path alias `@/` → `src/` (configured in `vite.config.ts` and `tsconfig.app.json`)
- State management: Pinia stores in `src/stores/`
- Router: `src/router/index.ts` with role-based guards (admin, gerente, cajero, cocinero)
- Mock mode: set `VITE_USE_MOCKS=true` in front-end `.env` to bypass API — see `src/services/api.ts`
- ESLint config is TypeScript (`eslint.config.ts`)
- Style: `no semicolons`, `single quotes`, `printWidth 100` (enforced by Prettier)

## Real-time

Socket.IO on the same HTTP server, emitting events like `rfid_detectado`. Frontend connects to `http://localhost:3000`.

## Hardware

`backend/Codigo_ESP/` contains Arduino ESP32 firmware for RFID reader + HID keyboard emulation. Connects directly to backend API for RFID operations.
