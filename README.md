# Crawlspace Help TN
[![Link Check](https://github.com/bentley-michael/CrawlspaceHelpTN/actions/workflows/link-check.yml/badge.svg)](https://github.com/bentley-michael/CrawlspaceHelpTN/actions/workflows/link-check.yml)



---

## Optional automation integration

If you plan to automate content posting via your Operator Agent or n8n Publish Pipeline, define these environment variables:

```bash
# Discord notifications (Operator Agent)
DISCORD_WEBHOOK_OPS=https://discord.com/api/webhooks/your_webhook_here

# n8n publish pipeline endpoint (content webhook)
N8N_WEBHOOK_PUBLISH=http://127.0.0.1:5678/webhook/publish/run
```

These are placeholders only — nothing posts automatically until you connect them.

## Plausible Events
- Global script loaded in `<head>` on: index.html, estimate.html, checklist.html
- Shared events file: /assets/js/plausible-events.js
- Events:
	- `cta-estimate`: fires on click of #cta-estimate (index.html)
	- `dl-checklist`: fires automatically on checklist.html via `data-plausible-event="dl-checklist"`
	- `header-email-click`: header CTA (mailto) click
	- `footer-email-click`: footer CTA (mailto) click

### Manual check
1. Open site in browser, DevTools → Network.
2. Filter: `plausible.js` → confirm it loads.
3. Console: `typeof window.plausible` → should be `"function"`.
4. Click CTA on home → look for `plausible.io/api/event?name=cta-estimate`.
5. Visit checklist.html → look for `plausible.io/api/event?name=dl-checklist`.

## Plausible Tracking

**Events (custom):**
- `cta-estimate` — homepage CTA click (#cta-estimate)
- `dl-checklist` — fired automatically on `checklist.html` via `<body data-plausible-event="dl-checklist">`
- `cta-question` — add `data-plausible-click="cta-question"` to “Ask a Question” CTA(s)
- `header-email-click` — header mailto CTA click
- `footer-email-click` — footer mailto CTA click
- `click-email` — auto for `mailto:` links; props: `{ address }`
- `outbound-link` — auto for off-site `<a>` clicks; props: `{ host, url }`
- `scroll-depth` — auto at 25/50/75/100; props: `{ percent }`
- `video-play`, `video-complete` — for `<video data-track-video>`; props: `{ id, src }`

**Test page buttons:**
- `plausible-test.html` contains buttons for: `cta-estimate`, `dl-checklist`, `header-email-click`, `footer-email-click`.

**Plausible UI (mark as Goals):**
1. Open Plausible → your site → Goals
2. Add goals for these events: `cta-estimate`, `dl-checklist`, `cta-question`, `header-email-click`, `footer-email-click`
3. Optional Funnel suggestion: CTA → Estimate → Checklist
	- Step 1: `cta-estimate`
	- Step 2: (optional future) `estimate-submit` if you emit it later
	- Step 3: `dl-checklist`

## Verifying in Plausible Realtime
1. Open Plausible → Realtime for `crawlspacehelptn.xyz`.
2. In a browser, visit `/plausible-test.html` and click each button once.
3. Confirm events appear in realtime: `cta-estimate`, `dl-checklist`, `header-email-click`, `footer-email-click`.
4. Optionally, open the homepage `/` and click the header/footer mailto CTAs; confirm network POSTs to `plausible.io/api/event` return 202.
