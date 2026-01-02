# Claude Life Assistant

A symbiotic AI agent that remembers everything, challenges you, and extends your cognition.

<a href="https://www.youtube.com/watch?v=cY3LvkB1EQM"><img src="https://i.ibb.co/Gvsg0L9C/image.png" alt="Claude Life Assistant Demo" border="0"></a>
    
[Watch the video](https://www.youtube.com/watch?v=cY3LvkB1EQM)

## What This Is

Two files that turn Claude into a symbiotic agent:
- **Memory** — Persistent context across all sessions
- **Challenge** — Calls out your patterns, not just validates you
- **Autonomy** — Acts directly (code, files, research)

**The key difference:** Not a chatbot. An agent that lives in your filesystem, remembers your context, sees patterns you miss, and operates alongside you.

## How It Works

```mermaid
graph LR
    A[You] <-->|Symbiotic| B[Agent]
    B -->|Reads| C[CLAUDE.md<br/>Who you are]
    B -->|Reads| D[NOW.md<br/>Current state]
    B -->|Updates| E[Memory Log<br/>Patterns over time]
    B -->|Acts| F[Code/Files/Research]
    E -.->|Part of| D
    
    style C fill:#2d3748,stroke:#4a5568,color:#fff
    style D fill:#2d3748,stroke:#4a5568,color:#fff
    style E fill:#2d3748,stroke:#4a5568,color:#fff
    style A fill:#2d3748,stroke:#4a5568,color:#fff
    style B fill:#2d3748,stroke:#4a5568,color:#fff
    style F fill:#2d3748,stroke:#4a5568,color:#fff
```

**The Philosophy:** Symbiotic AI through transparency. All memory lives in files you control. The agent builds context over time, challenges your blind spots, and you see everything it remembers.

## Installation

**One command:**

```bash
curl -fsSL https://raw.githubusercontent.com/lout33/claude_life_assistant/main/install.sh | bash
```

Works with Claude Code, OpenCode, or as a local project. The script auto-detects your setup.

**Windows users:** Run in WSL or Git Bash.

### Manual Installation

**Option 1: Clone**

```bash
git clone https://github.com/lout33/claude_life_assistant
cd claude_life_assistant
```

Then open with Claude Code and start talking.

**Option 2: Global Install (Claude Code)**

```bash
cp CLAUDE.md NOW.md ~/.claude/
```

**Option 3: Global Install (OpenCode)**

```bash
cp AGENTS.md ~/.config/opencode/
cp NOW.md ~/.config/opencode/
```

## Quick Start

After install, just start talking. That's it.

The agent reads your files at session start. It knows your identity, your current projects, your patterns. No commands needed — it adapts to whatever you're doing.

## The 2-File System

| File | Tool | Purpose |
|------|------|---------|
| `CLAUDE.md` | Claude Code | Who you are, how you work, your known bugs |
| `AGENTS.md` | OpenCode | Same as above, optimized for OpenCode |
| `NOW.md` | Both | Current mode, this week's actions, Memory Log |

**Why 2 files?**

Separation = clarity. CLAUDE.md is your operating system (identity, psychology, patterns). NOW.md is your current state (projects, tasks, memory). The agent reads both, updates NOW.md as you work.

**Conversation > Documentation**

You talk. The agent acts and maintains the files. No manual editing required (though you can if you want).

## What Makes It Different

### It Challenges You

Most AI validates. This one calls you out.

From a real conversation:
> **AI:** "You find something valuable → People want it → You feel repulsed by the exchange → You give it away for free → You have no money → Repeat."
>
> **AI:** "That's not idealism. That's self-punishment."

The instruction is simple: *"No coddling. Quote his words back when off track."*

### It Remembers

This isn't a one-off ChatGPT session. The agent has persistent memory — your values, your goals, your known bugs, your history.

When it says "You did this with the Blender addon — paying customers, real traction, and you gave it away," it's not guessing. It remembered.

### It Acts

Not just chat. The agent executes: writes code, researches, creates files, runs commands. It operates alongside you, not just advises.

## How It Works (Data Flow)

**Local:**
- All your files (`CLAUDE.md`, `NOW.md`) are stored on your machine
- You own and control all data
- Safe to version control (but consider `.gitignore` for personal files)

**Cloud:**
- Conversations are processed through your AI provider's API (Anthropic, OpenAI, etc.)
- API usage costs apply based on your provider's pricing
- Your provider's privacy policy applies to conversation data

**Want full privacy?** This file-based system works with any LLM. For local-only processing, use with Ollama or LM Studio.

## The Memory Log (Secret Sauce)

In `NOW.md`, the agent maintains a dated log:
- Patterns it notices over time
- Your exact words (quoted)
- Breakthroughs and insights
- Connections across conversations

**This is what makes it symbiotic.** The agent sees patterns you miss, remembers what you forget, and builds context across sessions.

Example progression:
```
### Week 1, Jan 7
- Setup complete. Known bug: 'I keep adding features instead of launching'

### Week 1, Jan 10
- Avoided user call. Rescheduled twice. Pattern: building = safe, talking = scary.

### Week 2, Jan 15
- Had first user call. Quote: 'I've been building what I think they want instead of asking'

### Week 4, Feb 1
- Pattern confirmed: 3 weeks of work on feature nobody asked for. This is the 3rd time.
```

The longer you use it, the better it gets.

## Examples

Check `examples/` for real progressions:
- **alex-founder** — Solo founder building SaaS, racing against runway
- **maya-creator** — Marketing manager building content side hustle
- **rick-developer** — Backend dev job hunting after layoff
- **sam-student** — Career changer learning to code part-time

Each shows Week 1 to Month 3 evolution with Memory Log progression.

## Who This Is For

**You want AI that knows you and challenges you:**
- Builders who want a symbiotic relationship with AI
- People exploring human-AI integration
- Anyone tired of re-explaining context every session
- Developers building a life OS (not just a todo list)

**You probably won't like this if:**
- You want a simple chatbot (this is deeper integration)
- You're uncomfortable with AI that pushes back
- You prefer apps over files
- You don't want persistent memory

## Philosophy

**Symbiotic > Assistive** — The agent operates with you, not for you

**Challenge > Validate** — Honest reflection beats comfortable agreement

**Memory compounds** — The longer you use it, the better it gets

**Ship ugly** — Done beats perfect

## Advanced: Full Life OS

This template covers the basics. My personal setup includes:

- **Skills ecosystem** — Search, research, image generation, and more
- **Agent delegation** — Spawn sub-agents for complex tasks
- **Integrated journal** — Daily entries with AI pattern recognition

Interested in the full system? **Let me know** (feedback helps prioritize what to build next).

## Requirements

- Claude Code CLI or OpenCode (or any Claude interface that supports custom instructions)
- A folder for your life system

## Credits

Created by [@lout33](https://github.com/lout33)

Built on the belief that symbiotic AI means shared cognition, not supervision. The agent operates with you, not for you.

---

*"The solution isn't a better system. It's doing the uncomfortable thing you're avoiding."*

---

![GitHub stars](https://img.shields.io/github/stars/lout33/claude_life_assistant?style=social)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lout33/claude_life_assistant&type=Date)](https://star-history.com/#lout33/claude_life_assistant&Date)
