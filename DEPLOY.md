# Deploying the Reunion App

Backend → **Render** (free web service + free PostgreSQL).
Frontend → **Firebase Hosting** (free).

You'll need to run these commands yourself — I can't sign in to your accounts.

---

## One-time setup

You need:
- A GitHub account, the project pushed to a repo (public or private).
- A Render account (https://render.com) — sign in with GitHub.
- A Firebase / Google account, and the Firebase CLI installed:
  ```bash
  npm install -g firebase-tools
  firebase login
  ```

---

## Step 1 — Push the repo to GitHub

```bash
cd /Users/ishaque/school_reunion
git init
git add .
git commit -m "Initial reunion app"
gh repo create school-reunion --public --source=. --remote=origin --push
# or create the repo manually on github.com and:
# git remote add origin https://github.com/<you>/school-reunion.git
# git branch -M main
# git push -u origin main
```

---

## Step 2 — Deploy the backend to Render

1. Go to https://dashboard.render.com → **New +** → **Blueprint**.
2. Connect your GitHub repo. Render will detect [`render.yaml`](render.yaml)
   at the repo root and propose:
   - a **free PostgreSQL** database named `reunion-db`
   - a **free Docker web service** named `reunion-backend` (built from [`backend/Dockerfile`](backend/Dockerfile))
3. Click **Apply**. First build takes ~5–10 minutes.
4. When it's live, copy the service URL — it looks like
   `https://reunion-backend-xxxx.onrender.com`. Test it:
   ```bash
   curl https://reunion-backend-xxxx.onrender.com/api/alumni/stats
   # {"total":0,"perBatch":{"SCIENCE":0,"COMMERCE_A":0,"COMMERCE_B":0,"COMMERCE_C":0}}
   ```

> **Free-tier caveat:** the service sleeps after 15 minutes of inactivity and
> takes ~30 seconds to wake on the next request. Render's free Postgres
> persists the registered alumni between sleeps. The DB expires after 90 days
> — Render emails a reminder.

---

## Step 3 — Build & deploy the frontend to Firebase Hosting

```bash
cd /Users/ishaque/school_reunion/frontend

# 1. Create a Firebase project once (or reuse an existing one)
firebase projects:create class-reunion-2026   # name must be globally unique

# 2. Point this folder at that project
#    Edit .firebaserc and replace REPLACE_WITH_YOUR_FIREBASE_PROJECT_ID
#    with the project id from the previous step.

# 3. Build the Flutter web bundle, baking in the Render backend URL
flutter build web --release \
  --dart-define=API_URL=https://reunion-backend-xxxx.onrender.com/api

# 4. Deploy
firebase deploy --only hosting
```

The CLI prints your hosting URL, e.g.
`https://class-reunion-2026.web.app`.

---

## Step 4 — Lock down CORS on the backend

For security, restrict the backend to accept calls only from your Firebase
Hosting URL.

1. Back in the Render dashboard, open the `reunion-backend` service →
   **Environment** tab.
2. Set the `CORS_ALLOWED_ORIGINS` variable to (no trailing slash):
   ```
   https://class-reunion-2026.web.app,https://class-reunion-2026.firebaseapp.com
   ```
3. Save — Render redeploys automatically (~2 minutes).

---

## Re-deploying after a code change

```bash
# Backend — just push to GitHub, Render auto-deploys on every commit to main.
git add -A && git commit -m "…" && git push

# Frontend — rebuild and redeploy.
cd frontend
flutter build web --release --dart-define=API_URL=https://reunion-backend-xxxx.onrender.com/api
firebase deploy --only hosting
```

---

## Local dev (no deploy needed)

```bash
# Terminal 1 — backend (H2 in-memory, no Postgres needed)
cd backend && mvn spring-boot:run

# Terminal 2 — frontend pointed at localhost
cd frontend && flutter run -d chrome
```

---

## What to share with classmates

Just the Firebase Hosting URL: `https://class-reunion-2026.web.app`.
It works on phones, tablets, and desktops. They tap **Register Yourself**,
fill in the form, and immediately appear in the directory for everyone else.
