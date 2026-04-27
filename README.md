# Grocify Setup Guide

This project contains the Grocify grocery tracker PWA.

## Files

- App: [Grocify/grocify-app.html](E:\AI_Grocery_Tracker\Grocify\grocify-app.html)
- Local server: [serve-grocify.ps1](E:\AI_Grocery_Tracker\Grocify\serve-grocify.ps1)
- PWA manifest: [Grocify/manifest.json](E:\AI_Grocery_Tracker\Grocify\manifest.json)
- Service worker: [Grocify/service-worker.js](E:\AI_Grocery_Tracker\Grocify\service-worker.js)

## Run On Laptop

Do not open the HTML file with `file:///...`.  
Run it through the local server instead.

Open PowerShell and run:

```powershell
cd E:\AI_Grocery_Tracker\Grocify
powershell -ExecutionPolicy Bypass -File .\serve-grocify.ps1
```

Then open this URL in your browser:

[http://localhost:8080/grocify-app.html](http://localhost:8080/grocify-app.html)

Keep the PowerShell window open while using the app.

## Install On Laptop

1. Open the app in Chrome or Edge.
2. Wait a few seconds.
3. Click `Install App` inside the page, or use the browser install button in the address bar/menu.
4. Confirm install.

## First App Setup

When the app opens:

1. Paste your Google Apps Script Web App URL.
2. Enter a sync code if you want shared data across devices.
3. Click `Start Tracking`.

## Mobile Testing

For mobile, the phone must open the app from a live URL, not from `localhost`.

Restart the local server:

```powershell
cd E:\AI_Grocery_Tracker\Grocify
powershell -ExecutionPolicy Bypass -File .\serve-grocify.ps1
```

The script prints a `Mobile:` URL like:

```text
http://192.168.x.x:8080/grocify-app.html
```

Requirements:

1. Phone and laptop must be on the same Wi-Fi.
2. Open the printed `Mobile:` URL in the real Chrome or Safari app.
3. Android: use `Add to Home screen` or `Install app`.
4. iPhone: use `Share` -> `Add to Home Screen`.

Note: local mobile access is mainly for testing. For regular mobile use, hosting the app online is better.

## Apply New Changes To The Installed App

When code changes are made:

1. Keep the PowerShell server running.
2. Open the browser version again:
   [http://localhost:8080/grocify-app.html](http://localhost:8080/grocify-app.html)
3. Refresh the browser page.
4. Close the installed app completely.
5. Open the installed app again.

If the installed app still shows the old version:

1. Refresh the browser page 1 to 2 times.
2. Reopen the installed app.
3. If needed, uninstall and install the app again.

This is needed because PWAs can cache files through the service worker.

## Current More Tab Calendar Flow

In the `More` tab:

1. Tap `Calendar`.
2. The month calendar opens.
3. Tap any date.
4. Only that day’s transactions appear below the calendar.

## Next Improvements

- Export real PNG app icons for broader device compatibility.
- Host the app online for easier mobile install.
- Improve the More tab calendar card visuals.
