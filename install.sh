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

if [ "$CLAUDE_CODE" = true ] && [ "$OPENCODE" = true ]; then
    echo "Detected both Claude Code and OpenCode."
    echo ""
    echo "Where do you want to install?"
    echo "  1) Claude Code (~/.claude/)"
    echo "  2) OpenCode (~/.config/opencode/)"
    echo "  3) Current directory (local project)"
    echo ""
    
    # Read from /dev/tty to handle curl | bash
    if [ -e /dev/tty ]; then
        read -p "Choose [1/2/3]: " choice < /dev/tty
    else
        echo "Non-interactive mode. Defaulting to current directory."
        choice=3
    fi
    
    case $choice in
        1)
            TARGET="$HOME/.claude"
            TARGET_NAME="Claude Code"
            CONFIG_FILE="CLAUDE.md"
            ;;
        2)
            TARGET="$HOME/.config/opencode"
            TARGET_NAME="OpenCode"
            CONFIG_FILE="AGENTS.md"
            ;;
        3)
            TARGET="."
            TARGET_NAME="current directory"
            CONFIG_FILE="CLAUDE.md"
            ;;
        *)
            echo "Invalid choice. Exiting."
            rm -rf "$TMP_DIR"
            exit 1
            ;;
    esac
elif [ "$CLAUDE_CODE" = true ]; then
    echo "Detected: Claude Code (~/.claude/)"
    TARGET="$HOME/.claude"
    TARGET_NAME="Claude Code"
    CONFIG_FILE="CLAUDE.md"
elif [ "$OPENCODE" = true ]; then
    echo "Detected: OpenCode (~/.config/opencode/)"
    TARGET="$HOME/.config/opencode"
    TARGET_NAME="OpenCode"
    CONFIG_FILE="AGENTS.md"
else
    echo "No Claude Code or OpenCode detected."
    echo "Installing to current directory..."
    TARGET="."
    TARGET_NAME="current directory"
    CONFIG_FILE="CLAUDE.md"
fi

echo ""
echo "Installing to $TARGET_NAME..."
echo ""

# Download the correct config file and NOW.md
curl -fsSL "$REPO_URL/$CONFIG_FILE" -o "$TMP_DIR/$CONFIG_FILE"
curl -fsSL "$REPO_URL/NOW.md" -o "$TMP_DIR/NOW.md"

# Copy config file (CLAUDE.md or AGENTS.md)
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

# Cleanup temp files
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Your symbiotic agent is ready."
echo ""
echo "Two files power the system:"
echo "  $CONFIG_FILE  — Your identity, psychology, patterns"
echo "  NOW.md        — Current state, projects, memory log"
echo ""
echo "The agent reads both at session start."
echo "Just start talking. It already knows you."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$TARGET_NAME" = "Claude Code" ]; then
    echo "Run: claude"
elif [ "$TARGET_NAME" = "OpenCode" ]; then
    echo "Run: opencode"
else
    echo "Open this directory with Claude Code or OpenCode."
fi

echo ""
echo "Go ship."
echo ""
