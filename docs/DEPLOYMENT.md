# NEXUS deployment guide

Deploy the React frontend and Spring Boot REST API as separate services. This guide uses Vercel for the static frontend, Render for the Java backend, and a managed MySQL database (the existing configuration is compatible with Aiven). The frontend and backend each have their own GitHub repository; see [GITHUB.md](GITHUB.md).

## 1. Deploy the backend to Render

Create a Render Web Service from the backend GitHub repository:

- Runtime: **Docker**
- Root directory: leave blank (the backend repository root contains the Dockerfile)
- Health check path: `/api/health`

Set these environment variables in the Render dashboard:

| Key | Value |
| --- | --- |
| `SPRING_PROFILES_ACTIVE` | `prod` |
| `DB_URL` | `jdbc:mysql://YOUR-MYSQL-HOST:3306/YOUR-DATABASE?sslMode=REQUIRED&serverTimezone=UTC` |
| `DB_USERNAME` | Your managed MySQL username |
| `DB_PASSWORD` | Your managed MySQL password |
| `JWT_SECRET` | A newly generated, random secret of at least 32 characters |
| `CORS_ALLOWED_ORIGINS` | The exact HTTPS origin assigned to the Vercel frontend, with no path or trailing slash |
| `AI_ENABLED` | `false` (set `true` only if you configure an AI API key) |

Render supplies `PORT`. Do not set database credentials or `JWT_SECRET` in GitHub, the repository, or a committed `.env` file. In PowerShell, generate a strong JWT value with:

```powershell
[Convert]::ToBase64String([Security.Cryptography.RandomNumberGenerator]::GetBytes(48))
```

Once deployed, check `https://YOUR-BACKEND-DOMAIN/api/health`; the JSON response should contain `"status":"UP"`.

## 2. Deploy the frontend to Vercel

Import the separate frontend GitHub repository into Vercel. The React app is built with Vite:

- Framework preset: **Vite**
- Root directory: leave blank (the frontend repository root contains `package.json`)
- Build command: `npm run build`
- Output directory: `dist`

Set this Vercel project environment variable for the production environment:

```text
VITE_API_URL=https://YOUR-BACKEND-DOMAIN/api
```

Use your deployed backend URL, ending in `/api`. Deploy the frontend, copy its exact HTTPS origin (for example, `https://your-project.vercel.app`), and set that origin as `CORS_ALLOWED_ORIGINS` in Render. Redeploy the backend after changing the variable.

## 3. Verify the deployed application

1. Open the Vercel site and register a new account.
2. Sign in, select domains, and open the dashboard, discovery, resources, opportunities, events, community, and AI assistant pages.
3. Confirm browser developer tools show no failed API requests or CORS errors.
4. Open the backend health URL and verify the database uses the managed MySQL service. The local H2 file is for development only.
5. Enable AI only after setting `AI_API_KEY` in Render. Keep it out of source control.

## Local build checks

Run these from the project root on Windows:

```powershell
Push-Location frontend
npm ci
npm run build
Pop-Location

Push-Location backend
mvn -B test
mvn -B package -DskipTests
Pop-Location
```
