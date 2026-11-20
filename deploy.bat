@echo off
setlocal
echo ========================================================
echo  ZOZO99 - Flutter Web Build & Vercel Deploy Script
echo ========================================================

:: 1. Add Node and npm to PATH if not already in session
set "PATH=C:\Program Files\nodejs;%APPDATA%\npm;%PATH%"

echo.
echo [1/3] Building Flutter Web (Release Mode)...
call flutter build web --release --base-href / --no-tree-shake-icons
if errorlevel 1 (
    echo [ERROR] Flutter build failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Syncing vercel.json configuration into build/web...
copy /Y vercel.json build\web\vercel.json >nul

echo.
echo [3/3] Deploying build/web to Vercel...
call vercel deploy build/web --prod

echo.
echo ========================================================
echo  Deployment complete! Check your Vercel Dashboard.
echo ========================================================
pause
