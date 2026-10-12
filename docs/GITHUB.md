# Push NEXUS frontend and backend to separate GitHub repositories

Create two empty GitHub repositories, one for the frontend and one for the backend. Do not add a README or license to either repository. These commands publish only each application folder, while preserving the working monorepo locally.

Open PowerShell in the NEXUS project root. Review the files before the first commit:

```powershell
git status --short
git check-ignore backend/data/nexus_db.mv.db
git check-ignore backend/.env
git check-ignore frontend/.env
```

The project repository is initialized already. Create its first commit, then connect and push each directory as its own `main` branch. Replace the example URLs with the HTTPS URLs of the two empty repositories:

```powershell
git add .
git status
git commit -m "Prepare NEXUS for deployment"
git branch -M main
git remote add frontend https://github.com/YOUR_USERNAME/nexus-frontend.git
git remote add backend https://github.com/YOUR_USERNAME/nexus-backend.git
git subtree push --prefix=frontend frontend main
git subtree push --prefix=backend backend main
```

GitHub will use its browser or credential-manager sign-in flow when needed. Never place a personal access token in a command, project file, or remote URL. Never commit `.env` files, API keys, database passwords, production JWT secrets, or `backend/data/`.

For future changes, commit the changes in the local project first, then publish whichever application changed:

```powershell
git add .
git commit -m "Describe the update"
git subtree push --prefix=frontend frontend main
git subtree push --prefix=backend backend main
```

You can also run just the applicable `git subtree push` command when only one application changed. After pushing, follow [`DEPLOYMENT.md`](DEPLOYMENT.md) to deploy the frontend and backend separately.
