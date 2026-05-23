# DormConnect

Hostel Management Ecosystem — Backend API + Web Panel

## Modules
- `backend/` — FastAPI REST API
- `web/` — Next.js Admin Panel (Chief Warden / Asst. Chief Warden)
- Flutter Mobile Apps — separate repository

## Quick Start

### Prerequisites
- Python 3.11+
- Node 18+
- Docker (for local postgres + redis)

### Backend

```bash
cd backend
cp .env.example .env          # fill your values
docker-compose up -d postgres redis
pip install -r requirements.txt
alembic upgrade head
python -m app.utils.seed
uvicorn app.main:app --reload
```

API: http://localhost:8000
Docs: http://localhost:8000/api/docs

### Web Panel

```bash
cd web
cp .env.local.example .env.local   # set NEXT_PUBLIC_INSTITUTION_ID from seed output
npm install
npm run dev
```

Web: http://localhost:3000

## Default Login Credentials (Dev Only)

| Role | Email | Password |
|------|-------|----------|
| Chief Warden | cw@dormconnect.dev | password123 |
| Asst. Chief Warden | acw@dormconnect.dev | password123 |
| Warden 1 | warden1@dormconnect.dev | password123 |
| Caretaker 1 | caretaker1@dormconnect.dev | password123 |
| Guard (PIN) | phone: 9000000001 | PIN: 1234 |
| Student (OTP) | phone: 9100000001 | OTP logged to console |

## Architecture

```
┌─────────────────────────────────────────────────┐
│  Clients                                        │
│  Next.js Web Panel  Flutter Apps (4)            │
└────────────┬────────────────────┬───────────────┘
             │                    │
             ▼                    ▼
┌─────────────────────────────────────────────────┐
│  DormConnect API (FastAPI)                      │
│  /api/v1/auth   /gate   /students               │
│  /complaints    /maintenance  /leaves           │
│  /visitors      /mess   /sos  /comms            │
│  /shifts        /analytics    /audit            │
└────────────┬────────────────────┬───────────────┘
             │                    │
             ▼                    ▼
        PostgreSQL              Redis
      (data store)           (OTP + sessions)
```

## API Modules

| Module | Endpoints | Roles |
|--------|-----------|-------|
| Auth | send-otp, verify-otp, staff-login, guard-login | All |
| Students | enroll, approve, profile, hostel list | Student, Caretaker+ |
| Gate | generate OTP, confirm, manual entry, live status | Student, Guard, Caretaker+ |
| Complaints | create, lifecycle (6 states), stats | Student, Caretaker+ |
| Maintenance | create, lifecycle (4 states), stats | Student, Caretaker+ |
| Leaves | apply, approve, guardian confirm, calendar | Student, Caretaker+, Guardian |
| Visitors | request, approve, guard entry/exit | Student, Guard, Caretaker+ |
| Mess | post menu, count, mess-off requests | Student, Caretaker+ |
| SOS | trigger, respond, history | Student, Caretaker+ |
| Communications | broadcast, notices | Caretaker+ |
| Shifts | assign, handover notes | Caretaker, Senior |
| Analytics | health score, institution overview, staff perf | Warden+, Senior |
| Audit | full audit trail (read-only) | Senior |

## Not Included (Separate Repositories)
- Flutter Student App
- Flutter Staff App
- Flutter Guard App
- Flutter Guardian App
- FCM real integration
- MSG91 SMS integration
- Production deployment config

## Running All Services (PM2)

### Prerequisites
- Python 3.11+ with virtualenv activated (`source backend/venv/bin/activate`)
- Node.js 18+
- PM2: `npm install -g pm2`
- PostgreSQL + Redis running: `docker-compose up -d`

### Dev
```bash
npm start
```

### Production
```bash
npm run start:prod
```

### Common commands
```bash
npm run status       # PM2 process table
npm run logs         # all logs live
npm run logs:api     # FastAPI logs only
npm run logs:web     # Next.js logs only
npm run restart      # restart all
npm run stop         # stop all
npm run monit        # CPU/mem dashboard
```

### Auto-start on reboot (run once)
```bash
npm run startup      # follow printed instructions
pm2 save
```

## Services & Ports
| Service           | Port | URL                            |
|-------------------|------|--------------------------------|
| FastAPI Backend   | 8000 | http://localhost:8000          |
| API Docs          | 8000 | http://localhost:8000/api/docs |
| Next.js Web Panel | 3000 | http://localhost:3000          |
