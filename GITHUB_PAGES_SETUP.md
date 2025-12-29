# GitHub Pages Setup for Trek Legal Documents

**Created**: December 29, 2025

## Overview

This guide shows how to host Trek's Privacy Policy and Terms of Service on GitHub Pages for free. This provides the required live URLs for App Store submission.

## Prerequisites

- [ ] GitHub account
- [ ] Trek repository on GitHub (or create one)
- [ ] Privacy Policy and Terms of Service markdown files

## Option 1: Quick Setup (Recommended)

### Step 1: Create GitHub Repository

If you don't have one yet:

1. Go to [GitHub](https://github.com)
2. Click **+** → **New repository**
3. Repository name: `trek` or `trek-website`
4. Description: "Trek Fitness Tracking App"
5. Public: ✅ (required for free GitHub Pages)
6. Initialize with README: ✅
7. Click **Create repository**

### Step 2: Enable GitHub Pages

1. Go to repository **Settings**
2. Scroll to **Pages** section (left sidebar)
3. **Source**: Deploy from a branch
4. **Branch**: `main` (or `master`)
5. **Folder**: `/ (root)` or `/docs` (choose `/docs` recommended)
6. Click **Save**
7. Wait 1-2 minutes for deployment

**Your site will be live at**:
```
https://[yourusername].github.io/trek/
```

or with custom domain:
```
https://www.trekapp.com/
```

### Step 3: Create Website Structure

Create these files in your repository (in `/docs` folder if you chose that option):

```
docs/
├── index.html
├── privacy.html
├── terms.html
└── support.html
```

### Step 4: Create index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trek - Track Your Fitness Journey</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1 {
            color: #007AFF;
        }
        .cta {
            background: #007AFF;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            margin: 20px 0;
        }
        footer {
            margin-top: 50px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
    <h1>🏃‍♀️ Trek</h1>
    <p><strong>Track Your Fitness Journey</strong></p>

    <p>Trek is a GPS fitness tracking app for iOS that helps you record and analyze your running, cycling, walking, and hiking activities.</p>

    <h2>Features</h2>
    <ul>
        <li>Real-time GPS tracking</li>
        <li>Beautiful route maps</li>
        <li>Detailed statistics and splits</li>
        <li>Full offline support</li>
        <li>Privacy-first design</li>
        <li>GPX export</li>
    </ul>

    <a href="https://apps.apple.com/app/trek/id..." class="cta">Download on the App Store</a>

    <h2>Legal</h2>
    <ul>
        <li><a href="privacy.html">Privacy Policy</a></li>
        <li><a href="terms.html">Terms of Service</a></li>
    </ul>

    <h2>Support</h2>
    <ul>
        <li><a href="support.html">Support & FAQ</a></li>
        <li>Email: <a href="mailto:support@trekapp.com">support@trekapp.com</a></li>
    </ul>

    <footer>
        <p>&copy; 2025 Trek App. All rights reserved.</p>
    </footer>
</body>
</html>
```

### Step 5: Create privacy.html

Convert `PRIVACY_POLICY.md` to HTML:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - Trek</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1 { color: #007AFF; }
        h2 { margin-top: 30px; color: #333; }
        h3 { margin-top: 20px; color: #555; }
        code { background: #f5f5f5; padding: 2px 6px; border-radius: 3px; }
        .back { color: #007AFF; text-decoration: none; }
    </style>
</head>
<body>
    <a href="index.html" class="back">← Back to Home</a>

    <h1>Privacy Policy for Trek</h1>
    <p><strong>Effective Date</strong>: December 29, 2025</p>
    <p><strong>Last Updated</strong>: December 29, 2025</p>

    <!-- Copy content from PRIVACY_POLICY.md and convert to HTML -->
    <!-- Use a Markdown to HTML converter or manually format -->

    <h2>Introduction</h2>
    <p>Welcome to Trek ("we," "our," or "us"). We respect your privacy...</p>

    <!-- ... rest of privacy policy content ... -->

    <p><strong>Last Updated</strong>: December 29, 2025</p>
</body>
</html>
```

**Quick conversion**:
```bash
# If you have pandoc installed
pandoc PRIVACY_POLICY.md -o docs/privacy.html -s --metadata title="Privacy Policy - Trek"
```

### Step 6: Create terms.html

Same process as privacy.html but for Terms of Service:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms of Service - Trek</title>
    <style>
        /* Same CSS as privacy.html */
    </style>
</head>
<body>
    <a href="index.html" class="back">← Back to Home</a>

    <h1>Terms of Service for Trek</h1>
    <p><strong>Effective Date</strong>: December 29, 2025</p>

    <!-- Copy content from TERMS_OF_SERVICE.md and convert to HTML -->

</body>
</html>
```

### Step 7: Create support.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support - Trek</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1 { color: #007AFF; }
        .faq { margin: 30px 0; }
        .question { font-weight: 600; margin-top: 20px; }
        .answer { margin: 10px 0 20px 20px; }
    </style>
</head>
<body>
    <a href="index.html" class="back">← Back to Home</a>

    <h1>Trek Support</h1>

    <h2>Contact Us</h2>
    <p>Email: <a href="mailto:support@trekapp.com">support@trekapp.com</a></p>
    <p>We typically respond within 24 hours.</p>

    <h2>Frequently Asked Questions</h2>

    <div class="faq">
        <div class="question">How do I record an activity?</div>
        <div class="answer">
            1. Open Trek<br>
            2. Tap the "Record" tab<br>
            3. Select your activity type (Run, Ride, Walk, or Hike)<br>
            4. Tap "Start" to begin recording<br>
            5. Tap "Finish" when done
        </div>

        <div class="question">Why is my GPS not working?</div>
        <div class="answer">
            Make sure you've granted Trek permission to access your location:<br>
            Settings → Trek → Location → "While Using the App"
        </div>

        <div class="question">How do I export my data?</div>
        <div class="answer">
            Go to Profile → Export Data. You can download all your activities in GPX format.
        </div>

        <div class="question">Does Trek work offline?</div>
        <div class="answer">
            Yes! Trek works completely offline. Activities are saved locally and sync automatically when you're back online.
        </div>

        <div class="question">How do I delete my account?</div>
        <div class="answer">
            Go to Profile → Settings → Delete Account. This will permanently delete all your data.
        </div>

        <div class="question">Is Trek free?</div>
        <div class="answer">
            Yes! Trek is completely free with no ads and no in-app purchases.
        </div>
    </div>

    <h2>Feature Requests</h2>
    <p>We'd love to hear your ideas! Email us at <a href="mailto:hello@trekapp.com">hello@trekapp.com</a></p>

    <h2>Bug Reports</h2>
    <p>Found a bug? Please email us at <a href="mailto:support@trekapp.com">support@trekapp.com</a> with:
    <ul>
        <li>Device model and iOS version</li>
        <li>Steps to reproduce the issue</li>
        <li>Screenshots if applicable</li>
    </ul>
    </p>
</body>
</html>
```

### Step 8: Push to GitHub

```bash
cd /path/to/trek

# Add docs folder
git add docs/

# Commit
git commit -m "Add GitHub Pages website with legal documents"

# Push
git push origin main
```

### Step 9: Verify Deployment

1. Wait 1-2 minutes for GitHub Pages to build
2. Visit: `https://[yourusername].github.io/trek/`
3. Check links work:
   - https://[yourusername].github.io/trek/privacy.html
   - https://[yourusername].github.io/trek/terms.html
   - https://[yourusername].github.io/trek/support.html

---

## Option 2: Custom Domain (Optional)

### Purchase Domain

Options:
- **Namecheap**: ~$10/year for .com
- **Google Domains**: ~$12/year
- **Cloudflare**: ~$10/year (with free HTTPS)

### Configure DNS

In your domain registrar:

1. Add CNAME record:
   - **Type**: CNAME
   - **Name**: www
   - **Value**: [yourusername].github.io
   - **TTL**: 3600

2. Add A records (for apex domain):
   - **Type**: A
   - **Name**: @
   - **Value**:
     - 185.199.108.153
     - 185.199.109.153
     - 185.199.110.153
     - 185.199.111.153

### Configure GitHub Pages

1. Go to repository **Settings** → **Pages**
2. **Custom domain**: Enter `www.trekapp.com`
3. Click **Save**
4. Wait for DNS check (can take 24-48 hours)
5. Enable **Enforce HTTPS** (after DNS propagates)

**Your URLs will be**:
- https://www.trekapp.com/
- https://www.trekapp.com/privacy.html
- https://www.trekapp.com/terms.html
- https://www.trekapp.com/support.html

---

## Option 3: Automated Setup with Jekyll (Advanced)

GitHub Pages supports Jekyll for easier maintenance.

### Create _config.yml

```yaml
title: Trek
description: Track Your Fitness Journey
baseurl: ""
url: "https://yourusername.github.io/trek"

theme: minima

header_pages:
  - privacy.md
  - terms.md
  - support.md
```

### Create Markdown Files

Keep `.md` files instead of `.html`:
- `index.md`
- `privacy.md`
- `terms.md`
- `support.md`

Jekyll will automatically convert to HTML.

**Example privacy.md**:
```markdown
---
layout: page
title: Privacy Policy
permalink: /privacy/
---

# Privacy Policy for Trek

**Effective Date**: December 29, 2025

## Introduction

Welcome to Trek...

[Copy content from PRIVACY_POLICY.md]
```

---

## URLs for App Store Connect

Once deployed, use these URLs in App Store Connect:

| Field | URL |
|-------|-----|
| Marketing URL | https://yourusername.github.io/trek/ |
| Support URL | https://yourusername.github.io/trek/support.html |
| Privacy Policy URL | https://yourusername.github.io/trek/privacy.html |

Or with custom domain:

| Field | URL |
|-------|-----|
| Marketing URL | https://www.trekapp.com/ |
| Support URL | https://www.trekapp.com/support |
| Privacy Policy URL | https://www.trekapp.com/privacy |

---

## Updating Documents

### Update Privacy Policy or Terms

1. Edit `privacy.html` or `terms.html`
2. Update "Last Updated" date
3. Commit and push:
```bash
git add docs/
git commit -m "Update privacy policy"
git push
```
4. Changes live in 1-2 minutes

---

## Testing

### Pre-Launch Checklist

- [ ] All HTML files created
- [ ] Privacy Policy complete and accurate
- [ ] Terms of Service complete
- [ ] Support page with contact info
- [ ] Links work (test clicking between pages)
- [ ] Mobile-responsive (test on phone)
- [ ] No typos or formatting issues
- [ ] "Last Updated" dates are current
- [ ] Contact email addresses are correct

### Accessibility Test

- [ ] Test on mobile device
- [ ] Text is readable (font size adequate)
- [ ] Links are tappable (not too small)
- [ ] Works in Safari, Chrome, Firefox
- [ ] Works on both light and dark mode

---

## Alternative Hosting Options

If you don't want to use GitHub Pages:

### Option 1: Firebase Hosting (Free)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
```

**URL**: `https://trek-xxxxx.web.app/`

### Option 2: Netlify (Free)

1. Sign up at [Netlify](https://www.netlify.com)
2. Connect GitHub repository
3. Auto-deploys on push
4. Free SSL

**URL**: `https://trek.netlify.app/`

### Option 3: Vercel (Free)

Same as Netlify:
1. Sign up at [Vercel](https://vercel.com)
2. Import GitHub repository
3. Auto-deploys

**URL**: `https://trek.vercel.app/`

---

## Markdown to HTML Conversion Tools

### Online Converters

- [Markdowntohtml.com](https://markdowntohtml.com)
- [Dillinger.io](https://dillinger.io)
- [StackEdit](https://stackedit.io)

### Command Line

```bash
# Using pandoc
brew install pandoc
pandoc PRIVACY_POLICY.md -o docs/privacy.html -s --metadata title="Privacy Policy"

# Using markdown-it
npm install -g markdown-it
markdown-it PRIVACY_POLICY.md > docs/privacy.html
```

### Python Script

```python
import markdown

with open('PRIVACY_POLICY.md', 'r') as f:
    text = f.read()

html = markdown.markdown(text)

with open('docs/privacy.html', 'w') as f:
    f.write(html)
```

---

## Template Files

### Minimal index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Trek</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <h1>Trek</h1>
    <p>Track Your Fitness Journey</p>
    <ul>
        <li><a href="privacy.html">Privacy Policy</a></li>
        <li><a href="terms.html">Terms of Service</a></li>
        <li><a href="support.html">Support</a></li>
    </ul>
</body>
</html>
```

This minimal version works but is not recommended for production.

---

## Quick Start (Copy-Paste Ready)

### 1. Create docs/ folder structure

```bash
mkdir -p docs
touch docs/index.html docs/privacy.html docs/terms.html docs/support.html
```

### 2. Use provided HTML templates above

Copy templates from Steps 4-7.

### 3. Convert markdown to HTML

Use online converter or pandoc for privacy.html and terms.html.

### 4. Commit and push

```bash
git add docs/
git commit -m "Add website for legal documents"
git push origin main
```

### 5. Enable GitHub Pages

Settings → Pages → Source: main branch, /docs folder → Save

### 6. Wait 2 minutes and test

Visit `https://yourusername.github.io/trek/privacy.html`

---

## Troubleshooting

**Issue**: "404 Page not found"
- **Solution**: Wait 2-5 minutes after push
- **Solution**: Check Settings → Pages shows green checkmark
- **Solution**: Verify files are in `/docs` folder (if selected)

**Issue**: Styling is broken
- **Solution**: Check CSS is inline in HTML (no external stylesheets)
- **Solution**: Verify HTML is valid (use W3C validator)

**Issue**: Changes don't appear
- **Solution**: Clear browser cache (Cmd+Shift+R)
- **Solution**: Check latest commit pushed to GitHub

**Issue**: Custom domain not working
- **Solution**: Wait 24-48 hours for DNS propagation
- **Solution**: Verify DNS records in domain registrar
- **Solution**: Check GitHub Pages settings

---

## Summary

**Fastest Setup** (15 minutes):
1. Create `/docs` folder with HTML files
2. Enable GitHub Pages in repository settings
3. Push to GitHub
4. Done! ✅

**URLs will be**:
- Privacy: `https://yourusername.github.io/trek/privacy.html`
- Terms: `https://yourusername.github.io/trek/terms.html`
- Support: `https://yourusername.github.io/trek/support.html`

**Use these URLs in App Store Connect!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Setup Time**: 15-30 minutes
