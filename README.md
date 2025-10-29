

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

### Manual check
1. Open site in browser, DevTools → Network.
2. Filter: `plausible.js` → confirm it loads.
3. Console: `typeof window.plausible` → should be `"function"`.
4. Click CTA on home → look for `plausible.io/api/event?name=cta-estimate`.
5. Visit checklist.html → look for `plausible.io/api/event?name=dl-checklist`.
