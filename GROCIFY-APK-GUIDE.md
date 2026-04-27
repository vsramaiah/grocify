# Grocify → APK: Complete Guide

---

## STEP 1 — Replace These Files in Your Grocify Folder

Download the fixed files provided alongside this guide and replace:

| File | What Changed |
|---|---|
| `manifest.json` | Fixed `id` and `start_url` to absolute paths; `theme_color` and `background_color` now match app green |
| `service-worker.js` | Fixed offline error — returns 503 instead of crashing |
| `index.html` | Removed duplicate `<meta>` redirect (kept only JS redirect) |
| `icon.svg` | New Grocify cart + ₹ icon |
| `icon-maskable.svg` | Android-safe version with full-bleed background |

---

## STEP 2 — Host on GitHub Pages (Free, HTTPS automatic)

### 2a. Create a GitHub account
1. Go to https://github.com
2. Click **Sign up** → enter email, password, username
3. Verify your email

### 2b. Create a new repository
1. Click the **+** button (top right) → **New repository**
2. Repository name: `grocify`
3. Set to **Public**
4. Click **Create repository**

### 2c. Upload your files
1. Click **uploading an existing file** (link on the empty repo page)
2. Drag and drop ALL files from your `Grocify/` folder:
   - `grocify-app.html`
   - `index.html`
   - `manifest.json`
   - `service-worker.js`
   - `offline.html`
   - `icon.svg`
   - `icon-maskable.svg`
   - `icon-192.png`
   - `icon-512.png`
   - `icon-maskable.png`
   - `apple-touch-icon.png`
3. Scroll down → click **Commit changes**

### 2d. Enable GitHub Pages
1. Click **Settings** tab (in your repo)
2. Left sidebar → click **Pages**
3. Under **Source** → select **Deploy from a branch**
4. Branch: `main` | Folder: `/ (root)`
5. Click **Save**
6. Wait 2–3 minutes
7. Your URL will appear: `https://YOUR-USERNAME.github.io/grocify`

✅ Test it — open that URL in Chrome on your phone. It should load Grocify.

---

## STEP 3 — Build APK with PWABuilder

### 3a. Open PWABuilder
1. Go to https://pwabuilder.com
2. Paste your GitHub Pages URL: `https://YOUR-USERNAME.github.io/grocify`
3. Click **Start**

### 3b. Review the audit score
PWABuilder will score your PWA. You need:
- ✅ Manifest detected
- ✅ Service Worker detected
- ✅ HTTPS (GitHub Pages gives this automatically)
- ✅ Icons (192px + 512px + maskable)

If all green → proceed. If anything is red, check the error message.

### 3c. Package for Android
1. Click **Package for stores**
2. Click **Android** tile
3. Settings to fill in:

| Field | Value |
|---|---|
| Package ID | `com.yourname.grocify` (e.g. `com.ravi.grocify`) |
| App name | `Grocify` |
| App version | `1.0.0` |
| Version code | `1` |
| Display mode | `Standalone` |
| Signing | Select **Generate new** (PWABuilder signs it for you) |

4. Click **Generate** → wait 30–60 seconds
5. Download the `.zip` file

### 3d. Extract the APK
1. Unzip the downloaded file
2. You'll find a file named `grocify.apk` (or similar)

---

## STEP 4 — Share & Install the APK

### Share options:
- **WhatsApp / Telegram** — send the `.apk` file directly in chat
- **Google Drive** — upload and share the link
- **Email** — attach and send

### How recipients install it:
1. Download the `.apk` on their Android phone
2. Open the file
3. Android will ask to allow installation:
   - Go to **Settings → Security → Install unknown apps**
   - Allow for the app used to open the file (Files, Chrome, WhatsApp, etc.)
4. Tap **Install**
5. Done — Grocify appears on their home screen!

### Minimum Android requirement:
- Android 5.0 (API 21) or higher — covers 99%+ of devices

---

## STEP 5 — Update the App Later

Whenever you update the HTML file:
1. Go to your GitHub repo
2. Click the file → click the pencil ✏️ icon to edit, or drag-drop a new version
3. Commit the change
4. GitHub Pages updates automatically within 2–3 minutes
5. The app on everyone's phone updates silently via the service worker — **no need to resend the APK!**

---

## Troubleshooting

| Problem | Fix |
|---|---|
| PWABuilder shows red for manifest | Make sure `manifest.json` is uploaded and accessible at your GitHub Pages URL |
| "Install blocked" on phone | Enable *Install unknown apps* in Android settings |
| App shows blank screen | Check that `index.html` redirects to the correct HTML filename |
| PWABuilder score < 100 | Add `"screenshots": []` to manifest (already done in the fixed version) |
| Service worker not updating | Hard refresh: hold Shift + reload in Chrome DevTools |

---

## Your Checklist

- [ ] Replaced `manifest.json`, `index.html`, `service-worker.js`, icons
- [ ] Created GitHub account
- [ ] Created `grocify` repo (public)
- [ ] Uploaded all Grocify files
- [ ] Enabled GitHub Pages
- [ ] Tested URL in phone browser
- [ ] Ran URL through PWABuilder
- [ ] Downloaded and extracted APK
- [ ] Shared APK with friends/family
