#!/bin/bash

# Claude Life Assistant - One-liner installer
# Usage: curl -fsSL https://raw.githubusercontent.com/lout33/claude_life_assistant/main/install.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/lout33/claude_life_assistant/main"
TMP_DIR="/tmp/claude_life_assistant_install"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Downloading Claude Life Assistant..."
echo ""

# Create temp directory
mkdir -p "$TMP_DIR"

# Download files (always CLAUDE.md from repo)
curl -fsSL "$REPO_URL/CLAUDE.md" -o "$TMP_DIR/CLAUDE.md" || { echo "Failed to download CLAUDE.md"; exit 1; }
curl -fsSL "$REPO_URL/NOW.md" -o "$TMP_DIR/NOW.md" || { echo "Failed to download NOW.md"; exit 1; }

# Download commands
mkdir -p "$TMP_DIR/commands"
curl -fsSL "$REPO_URL/commands/start-day.md" -o "$TMP_DIR/commands/start-day.md" || { echo "Failed to download start-day.md"; exit 1; }
curl -fsSL "$REPO_URL/commands/check-day.md" -o "$TMP_DIR/commands/check-day.md" || { echo "Failed to download check-day.md"; exit 1; }
curl -fsSL "$REPO_URL/commands/end-day.md" -o "$TMP_DIR/commands/end-day.md" || { echo "Failed to download end-day.md"; exit 1; }
curl -fsSL "$REPO_URL/commands/reflect.md" -o "$TMP_DIR/commands/reflect.md" || { echo "Failed to download reflect.md"; exit 1; }

# Detect installed tools
CLAUDE_CODE=false
OPENCODE=false

if [ -d "$HOME/.claude" ]; then
    CLAUDE_CODE=true
fi

if [ -d "$HOME/.config/opencode" ]; then
    OPENCODE=true
fi

# Determine install target
TARGET=""
TARGET_NAME=""
CONFIG_FILE=""
IS_OPENCODE=false

if [ "$CLAUDE_CODE" = true ] && [ "$OPENCODE" = true ]; then
    echo "Detected both Claude Code and OpenCode."
    echo ""
    echo "Where do you want to install?"
    echo "  1) Claude Code - Global (~/.claude/)"
    echo "  2) Claude Code - Local (./CLAUDE.md)"
    echo "  3) OpenCode - Global (~/.config/opencode/)"
    echo "  4) OpenCode - Local (./AGENTS.md)"
    echo ""
    
    if [ -e /dev/tty ]; then
        read -p "Choose [1/2/3/4]: " choice < /dev/tty
    else
        echo "Non-interactive mode. Exiting."
        rm -rf "$TMP_DIR"
        exit 1
    fi
    
    case $choice in
        1)
            TARGET="$HOME/.claude"
            TARGET_NAME="Claude Code (Global)"
            CONFIG_FILE="CLAUDE.md"
            ;;
        2)
            TARGET="."
            TARGET_NAME="Claude Code (Local)"
            CONFIG_FILE="CLAUDE.md"
            ;;
        3)
            TARGET="$HOME/.config/opencode"
            TARGET_NAME="OpenCode (Global)"
            CONFIG_FILE="AGENTS.md"
            IS_OPENCODE=true
            ;;
        4)
            TARGET="."
            TARGET_NAME="OpenCode (Local)"
            CONFIG_FILE="AGENTS.md"
            IS_OPENCODE=true
            ;;
        *)
            echo "Invalid choice. Exiting."
            rm -rf "$TMP_DIR"
            exit 1
            ;;
    esac
elif [ "$CLAUDE_CODE" = true ]; then
    echo "Detected: Claude Code"
    echo ""
    echo "Where do you want to install?"
    echo "  1) Global (~/.claude/)"
    echo "  2) Local (./CLAUDE.md)"
    echo ""
    
    if [ -e /dev/tty ]; then
        read -p "Choose [1/2]: " choice < /dev/tty
    else
        echo "Non-interactive mode. Exiting."
        rm -rf "$TMP_DIR"
        exit 1
    fi
    
    case $choice in
        1)
            TARGET="$HOME/.claude"
            TARGET_NAME="Claude Code (Global)"
            CONFIG_FILE="CLAUDE.md"
            ;;
        2)
            TARGET="."
            TARGET_NAME="Claude Code (Local)"
            CONFIG_FILE="CLAUDE.md"
            ;;
        *)
            echo "Invalid choice. Exiting."
            rm -rf "$TMP_DIR"
            exit 1
            ;;
    esac
elif [ "$OPENCODE" = true ]; then
    echo "Detected: OpenCode"
    echo ""
    echo "Where do you want to install?"
    echo "  1) Global (~/.config/opencode/)"
    echo "  2) Local (./AGENTS.md)"
    echo ""
    
    if [ -e /dev/tty ]; then
        read -p "Choose [1/2]: " choice < /dev/tty
    else
        echo "Non-interactive mode. Exiting."
        rm -rf "$TMP_DIR"
        exit 1
    fi
    
    case $choice in
        1)
            TARGET="$HOME/.config/opencode"
            TARGET_NAME="OpenCode (Global)"
            CONFIG_FILE="AGENTS.md"
            IS_OPENCODE=true
            ;;
        2)
            TARGET="."
            TARGET_NAME="OpenCode (Local)"
            CONFIG_FILE="AGENTS.md"
            IS_OPENCODE=true
            ;;
        *)
            echo "Invalid choice. Exiting."
            rm -rf "$TMP_DIR"
            exit 1
            ;;
    esac
else
    echo "No Claude Code or OpenCode installation detected."
    echo ""
    echo "Please install one of the following first:"
    echo "  - Claude Code: https://docs.anthropic.com/en/docs/claude-code"
    echo "  - OpenCode: https://opencode.ai/docs"
    echo ""
    echo "Then run this installer again."
    rm -rf "$TMP_DIR"
    exit 1
fi

echo ""
echo "Installing to $TARGET_NAME..."
echo ""

# Prepare config file (rename for OpenCode if needed)
if [ "$IS_OPENCODE" = true ]; then
    # Replace CLAUDE.md references with AGENTS.md in the file
    sed -i.bak 's/CLAUDE\.md/AGENTS.md/g' "$TMP_DIR/CLAUDE.md"
    rm -f "$TMP_DIR/CLAUDE.md.bak"
    mv "$TMP_DIR/CLAUDE.md" "$TMP_DIR/AGENTS.md"
fi

# Copy config file
TARGET_CONFIG="$TARGET/$CONFIG_FILE"
if [ -f "$TARGET_CONFIG" ]; then
    echo -e "${YELLOW}! $CONFIG_FILE already exists at $TARGET_CONFIG${NC}"
    echo "  Backup created at $TARGET_CONFIG.backup"
    cp "$TARGET_CONFIG" "$TARGET_CONFIG.backup"
fi
cp "$TMP_DIR/$CONFIG_FILE" "$TARGET_CONFIG"
echo -e "${GREEN}✓ Copied $CONFIG_FILE${NC}"

# Copy NOW.md
TARGET_NOW="$TARGET/NOW.md"
if [ -f "$TARGET_NOW" ]; then
    echo -e "${YELLOW}! NOW.md already exists at $TARGET_NOW${NC}"
    echo "  Backup created at $TARGET_NOW.backup"
    cp "$TARGET_NOW" "$TARGET_NOW.backup"
fi
cp "$TMP_DIR/NOW.md" "$TARGET_NOW"
echo -e "${GREEN}✓ Copied NOW.md${NC}"

# Copy commands to appropriate location
if [ "$TARGET" = "." ]; then
    # Local project - use .claude or .opencode subdirectory
    if [ "$IS_OPENCODE" = true ]; then
        COMMANDS_DIR=".opencode/commands"
    else
        COMMANDS_DIR=".claude/commands"
    fi
else
    # Global install
    COMMANDS_DIR="$TARGET/commands"
fi

mkdir -p "$COMMANDS_DIR"
cp "$TMP_DIR/commands/"*.md "$COMMANDS_DIR/"
echo -e "${GREEN}✓ Copied commands (start-day, check-day, end-day, reflect)${NC}"

# Cleanup temp files
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Your symbiotic agent is ready."
echo ""
echo "Two files power the system:"
echo "  $CONFIG_FILE  — Your identity, psychology, patterns"
echo "  NOW.md        — Current state, projects, memory log"
echo ""
echo "Commands available:"
echo "  /start-day    — Morning kickoff, set MIT"
echo "  /check-day    — Quick accountability check-in"
echo "  /end-day      — Evening review, capture wins"
echo "  /reflect      — Deep reflection, creates journal entry"
echo ""
echo "The agent reads both files at session start."
echo "Just start talking. It already knows you."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$TARGET_NAME" = "Claude Code" ]; then
    echo "Run: claude"
elif [ "$TARGET_NAME" = "OpenCode" ]; then
    echo "Run: opencode"
else
    if [ "$CONFIG_FILE" = "CLAUDE.md" ]; then
        echo "Open this directory with Claude Code."
    else
        echo "Open this directory with OpenCode."
    fi
fi

echo ""
echo "Go ship."
echo ""
