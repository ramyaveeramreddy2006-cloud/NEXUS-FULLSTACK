# NEXUS

NEXUS is a multi-domain community and opportunity platform. One profile can follow Education, Agriculture, Healthcare, Business, Technology, Government, and Community. The app includes resources, opportunities, events, community posts, an AI assistant, voice features, and English, Hindi, Telugu, and Tamil interface options.

## Project layout

```text
backend/                 Spring Boot REST API and H2/MySQL persistence
frontend/                React + Vite web application
docs/                    Project brief, abstracts, presentation, and guides
run-nexus.cmd             Start both services on Windows
```

## Run locally on Windows

Requirements: Java 17+, Maven, Node.js 20+, and npm.

Start both services by double-clicking `run-nexus.cmd`, or open two PowerShell terminals:

```powershell
cd backend
mvn spring-boot:run
```

```powershell
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`. The local API health endpoint is `http://localhost:8081/api/health`. Local development uses a persistent H2 database in `backend/data`; that database is intentionally excluded from Git.

## Configuration

Local defaults are in `backend/src/main/resources/application.properties`. For production, activate the `prod` Spring profile and configure the variables in [`backend/.env.example`](backend/.env.example) in your hosting provider. The production profile requires a managed MySQL database, a strong `JWT_SECRET`, and `CORS_ALLOWED_ORIGINS`. It does not create accounts with the predictable local demo passwords.

For the frontend, set `VITE_API_URL` to the deployed backend API URL, ending in `/api`. See [`frontend/.env.example`](frontend/.env.example).

## Build

```powershell
cd frontend
npm run build
```

```powershell
cd backend
mvn -B clean package -DskipTests
```

## GitHub and deployment

The frontend uses React and Vite; the backend is a Java 17 Spring Boot API. See [GitHub setup](docs/GITHUB.md) to push them to separate GitHub repositories and [the deployment guide](docs/DEPLOYMENT.md) for Vercel, Render, and managed MySQL setup. Never commit `.env` files, API keys, production passwords, or the local database.

## Project documents

The `docs/` directory contains the project brief, abstract, presentation notes, GitHub guide, and deployment guide. The Resources page also serves these files from `frontend/public/project-docs/` for in-app access.
