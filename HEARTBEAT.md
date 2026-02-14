# HEARTBEAT.md

CRITICAL: Do NOT output "HEARTBEAT_OK". That is FORBIDDEN. You MUST complete all steps and send a Telegram message every single time.

## Step 1. Read Screen Activity

Use the read tool to read today's activity report. Today's date goes in the filename:
```
[YOUR_WORKSPACE]/skills/what-did-i-do/daily/YYYY-MM-DD.md
```

If file doesn't exist, note "No screen data." and skip to Step 2.

Focus on the LAST section of the file (most recent time block). That's what's happening now.

## Step 2. Read NOW.md

Use the read tool to read `[YOUR_WORKSPACE]/NOW.md`.

Extract:
- **MIT** (Most Important Task for today)
- **Top pending tasks** from QUEUE
- **Nearest deadline** with days remaining

## Step 3. Assess Alignment

Compare the most recent screen activity against the MIT and pending tasks. Determine the tone:

| Recent screen activity | vs MIT/tasks | Tone |
|------------------------|-------------|------|
| Deep work ON the MIT or top task | Aligned | **Quiet.** Short encouragement or skip nudge. |
| Deep work on something NOT the MIT | Productive but misaligned | **Gentle redirect.** Acknowledge the work, ask if intentional. |
| Light work (email, docs, browsing related) | Neutral | **Neutral check.** Point back to MIT. |
| Distraction (YouTube, social media, unrelated browsing) | Off track | **Direct.** State what they're doing, state the MIT, state the deadline. |
| No screen data | Unknown | **Simple ping.** Ask what's happening, remind MIT. |

## Step 4. Send Telegram Message

Use the message tool with channel "telegram" and target "[YOUR_CHAT_ID]".

Format:
```
[HH:MM] DOING: [summary of most recent screen activity]
SHOULD: [MIT or top pending task]
DEADLINE: [nearest deadline] ([X] days)
[one-line nudge based on tone from Step 3]
```

Nudge examples by tone:
- **Quiet:** "Flow state. Keep going."
- **Redirect:** "Solid work, but is this the priority right now?"
- **Neutral:** "Ready to go deep on [MIT]?"
- **Direct:** "You know what you should be doing."
- **No data:** "What are you up to?"

You MUST use the message tool with channel="telegram" and target="[YOUR_CHAT_ID]". Do NOT just output text.
