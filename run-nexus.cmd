@echo off
setlocal
set "NEXUS_ROOT=%~dp0"
curl.exe -fsS --max-time 2 http://localhost:8081/api/health >nul 2>&1
if errorlevel 1 (
  echo Starting the NEXUS backend...
  start "NEXUS backend - port 8081" cmd /k "cd /d ""%NEXUS_ROOT%backend"" && call run-backend.cmd"
) else (
  echo NEXUS backend is already running. Reusing it.
)
curl.exe -fsS --max-time 2 http://localhost:5173/ >nul 2>&1
if errorlevel 1 (
  echo Starting the NEXUS frontend...
  start "NEXUS frontend - port 5173" cmd /k "cd /d ""%NEXUS_ROOT%frontend"" && call run-frontend.cmd"
) else (
  echo NEXUS frontend is already running. Reusing it.
)
echo.
echo Open http://localhost:5173 after the frontend finishes starting.
echo Backend health: http://localhost:8081/api/health
echo If the backend fails to start, check its terminal for the specific error.
endlocal
