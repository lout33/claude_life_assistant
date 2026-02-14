# HEARTBEAT Setup Guide

Your AI watches your screen, compares what you're doing against your tasks in NOW.md, and pings you on Telegram when you drift. Quiet during deep work. Direct during distraction.

## What You Need

| Component | Purpose | Link |
|-----------|---------|------|
| **OpenClaw** | Runs the agent on a schedule, sends Telegram messages | [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw) |
| **Telegram Bot** | Receives the heartbeat messages | [BotFather](https://t.me/BotFather) |
| **what-did-i-do** | Passive screen tracker (screenshots + Gemini Vision analysis) | [github.com/lout33/what-did-i-do](https://github.com/lout33/what-did-i-do) |
| **Gemini API Key** | Powers the screenshot analysis | [aistudio.google.com/apikey](https://aistudio.google.com/apikey) |

## Step 1: Install OpenClaw

```bash
npm install -g openclaw@latest
openclaw onboard --install-daemon
```

The wizard walks you through setting up the gateway, workspace, and channels. When asked about workspace, point it to the directory containing your Symbiotic AI files.

Docs: [docs.openclaw.ai/start/getting-started](https://docs.openclaw.ai/start/getting-started)

## Step 2: Create a Telegram Bot

1. Open Telegram, search for [@BotFather](https://t.me/BotFather)
2. Send `/newbot`, follow the prompts
3. Copy the bot token (looks like `123456:ABCDEF...`)
4. Send a message to your new bot (this activates the chat)
5. Get your chat ID: visit `https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates` and find `"chat":{"id":YOUR_CHAT_ID}`

## Step 3: Configure Telegram in OpenClaw

Edit `~/.openclaw/openclaw.json` and add the Telegram channel:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN",
      "dmPolicy": "allowlist",
      "allowFrom": ["YOUR_CHAT_ID"]
    }
  },
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true
      }
    }
  }
}
```

## Step 4: Set Up the Screen Watcher

```bash
git clone https://github.com/lout33/what-did-i-do
```

Copy the `scripts/` folder into your workspace skills directory:
```
your-workspace/
  skills/
    what-did-i-do/
      scripts/
        watcher.sh
        analyze.py
      daily/        (created automatically)
      temp/         (created automatically)
```

Set your Gemini API key in `analyze.py` (line 12) or as an environment variable:
```bash
export GEMINI_API_KEY="your-key-here"
```

Start the watcher:
```bash
./skills/what-did-i-do/scripts/watcher.sh start
```

The watcher captures a screenshot every 60 seconds (9am-10pm), analyzes every 5 captures with Gemini Vision, and writes daily reports to `daily/YYYY-MM-DD.md`.

## Step 5: Configure the Heartbeat

Add the heartbeat config to `~/.openclaw/openclaw.json` under `agents.defaults`:

```json
{
  "agents": {
    "defaults": {
      "workspace": "/path/to/your/workspace",
      "heartbeat": {
        "every": "5m",
        "target": "telegram",
        "session": "heartbeat",
        "to": "YOUR_CHAT_ID",
        "prompt": "You are a background monitoring agent. EVERY time you receive this prompt, you MUST execute ALL steps in HEARTBEAT.md. Read it NOW with the read tool.",
        "activeHours": {
          "start": "09:00",
          "end": "22:00",
          "timezone": "America/New_York"
        }
      }
    }
  }
}
```

| Setting | What it does |
|---------|-------------|
| `every` | How often the heartbeat fires (e.g. `"5m"`, `"10m"`, `"15m"`) |
| `target` | Which channel to send messages to |
| `to` | Your Telegram chat ID |
| `activeHours` | Only fires during these hours (your timezone) |
| `session` | Isolates heartbeat from your main chat sessions |

## Step 6: Place HEARTBEAT.md

Copy `HEARTBEAT.md` into your workspace root (same directory as NOW.md, SOUL.md, etc.):

```
your-workspace/
  AGENTS.md
  SOUL.md
  USER.md
  NOW.md
  HEARTBEAT.md    <-- here
  skills/
    what-did-i-do/
      ...
```

Update the file paths in HEARTBEAT.md to match your workspace location.

## Step 7: Start Everything

The OpenClaw gateway runs automatically via launchd (macOS) or systemd (Linux) if you used `--install-daemon`. The heartbeat fires on schedule.

Start the screen watcher (if not already running):
```bash
./skills/what-did-i-do/scripts/watcher.sh start
```

Check status:
```bash
./skills/what-did-i-do/scripts/watcher.sh status
openclaw health
```

## How It Works

```
Every 5 minutes (during active hours):

  OpenClaw fires heartbeat
       |
       v
  Agent reads HEARTBEAT.md
       |
       v
  Reads today's screen activity    Reads NOW.md
  (what-did-i-do daily report)     (MIT, tasks, deadlines)
       |                                |
       +---------- compares -----------+
                      |
                      v
              Determines tone:
         aligned / redirect / distraction
                      |
                      v
           Sends Telegram message
           with adapted nudge
```

## Example Messages

**You're focused on your MIT:**
```
[14:30] DOING: VS Code - building landing page components
SHOULD: Ship landing page
DEADLINE: Feb 28 (14 days)
Flow state. Keep going.
```

**You drifted to YouTube:**
```
[15:15] DOING: YouTube - watching programming streams (45 min)
SHOULD: Ship landing page
DEADLINE: Feb 28 (14 days)
You know what you should be doing.
```

**You're productive but on the wrong thing:**
```
[16:00] DOING: Refactoring auth module
SHOULD: Ship landing page
DEADLINE: Feb 28 (14 days)
Solid work, but is this the priority right now?
```

## Adjusting the Frequency

- **5m** -- Tight accountability. Good for days when you know you'll drift.
- **10m** -- Balanced. Enough to catch drift without being annoying.
- **15m** -- Light touch. For days you're mostly on track.
- **30m** -- Background awareness. Just periodic check-ins.

Change `"every"` in your openclaw.json heartbeat config.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| No Telegram messages | Check `openclaw health`, verify bot token and chat ID |
| "No screen data" every time | Make sure `watcher.sh start` is running. Check `watcher.sh status` |
| Messages outside active hours | Verify `timezone` in activeHours matches your local timezone |
| Watcher not analyzing | Check Gemini API key is set. Look at `/tmp/what-did-i-do-analyze.log` |
