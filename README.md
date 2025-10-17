

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
