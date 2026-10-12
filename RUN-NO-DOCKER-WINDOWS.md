# Run NEXUS on Windows

## Start the full project

Install Java 17 or later, Maven, and Node.js. From the project folder, double-click `run-nexus.cmd`. It starts any service that is not already running and reuses healthy services, so running the launcher again will not start a second backend against the same database.

Open `http://localhost:5173` after the frontend finishes starting. The backend should report `{"status":"UP"}` at `http://localhost:8081/api/health`.

The backend uses an embedded H2 database by default and creates its persistent local database under `backend/data`. No MySQL server or manual database setup is needed for local development. The starter catalogue is populated automatically the first time the backend starts. Do not delete the database files to resolve a database-lock error; stop the extra backend process or use the existing healthy backend.

## Start each part separately

For the backend, double-click `backend/run-backend.cmd`. It reuses a healthy backend and refuses to start another instance if port 8081 is still starting. If running Maven directly, first stop any other backend instance.

For the frontend, double-click `frontend/run-frontend.cmd`, or run `npm run dev` from the `frontend` directory. The frontend installs its npm dependencies when `node_modules` is missing.

## Use Aiven as the database provider

1. In the Aiven console, open your MySQL service and copy its host, port, database name, and username. Make sure the service is running and allow your network/IP in its connection settings.
2. Stop any backend already running in a separate terminal. Do not delete the local H2 database.
3. From the project folder, run:

   ```powershell
   .\backend\run-aiven.ps1
   ```

4. Press Enter to accept the displayed host, port, database name, and username. Enter the Aiven password at its hidden prompt. The launcher generates a temporary JWT secret for this run; users will need to sign in again after restarting the backend.
5. In another terminal, start the frontend with `.\frontend\run-frontend.cmd`, then open `http://localhost:5173`.

The production profile reads `AIVEN_HOST`, `AIVEN_PORT`, `AIVEN_DATABASE`, `AIVEN_USERNAME`, and `AIVEN_PASSWORD` and connects with TLS. Aiven is the database provider; if your Aiven service is MySQL, the project must still use its MySQL JDBC driver to speak that database's protocol. Configure these Aiven variables plus `JWT_SECRET` and `CORS_ALLOWED_ORIGINS` in your hosting provider's secret settings for deployment. The sample names and values are in `backend/.env.example`; it is a template only and is not loaded automatically by Spring Boot.

## Demo accounts

- admin@nexus.local / Admin@123
- student@nexus.local / Student@123
- faculty@nexus.local / Faculty@123
- farmer@nexus.local / Farmer@123
