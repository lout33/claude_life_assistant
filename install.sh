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
curl -fsSL "$REPO_URL/CLAUDE.md" -o "$TMP_DIR/CLAUDE.md"
curl -fsSL "$REPO_URL/NOW.md" -o "$TMP_DIR/NOW.md"

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
    echo "  1) Claude Code (~/.claude/)"
    echo "  2) OpenCode (~/.config/opencode/)"
    echo "  3) Current directory (local project)"
    echo ""
    
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
            IS_OPENCODE=true
            ;;
        3)
            TARGET="."
            TARGET_NAME="current directory"
            echo ""
            echo "Which tool will you use with this project?"
            echo "  1) Claude Code (creates CLAUDE.md)"
            echo "  2) OpenCode (creates AGENTS.md)"
            echo ""
            if [ -e /dev/tty ]; then
                read -p "Choose [1/2]: " tool_choice < /dev/tty
            else
                echo "Non-interactive mode. Defaulting to CLAUDE.md."
                tool_choice=1
            fi
            case $tool_choice in
                1)
                    CONFIG_FILE="CLAUDE.md"
                    ;;
                2)
                    CONFIG_FILE="AGENTS.md"
                    IS_OPENCODE=true
                    ;;
                *)
                    echo "Invalid choice. Defaulting to CLAUDE.md."
                    CONFIG_FILE="CLAUDE.md"
                    ;;
            esac
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
    IS_OPENCODE=true
else
    echo "No Claude Code or OpenCode detected."
    echo "Installing to current directory..."
    echo ""
    echo "Which tool will you use with this project?"
    echo "  1) Claude Code (creates CLAUDE.md)"
    echo "  2) OpenCode (creates AGENTS.md)"
    echo ""
    if [ -e /dev/tty ]; then
        read -p "Choose [1/2]: " tool_choice < /dev/tty
    else
        echo "Non-interactive mode. Defaulting to CLAUDE.md."
        tool_choice=1
    fi
    case $tool_choice in
        1)
            CONFIG_FILE="CLAUDE.md"
            ;;
        2)
            CONFIG_FILE="AGENTS.md"
            IS_OPENCODE=true
            ;;
        *)
            echo "Invalid choice. Defaulting to CLAUDE.md."
            CONFIG_FILE="CLAUDE.md"
            ;;
    esac
    TARGET="."
    TARGET_NAME="current directory"
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
echo "Core files installed:"
echo "  $CONFIG_FILE  — Your identity, psychology, day triggers"
echo "  NOW.md        — Current state, day tracking, memory log"
echo ""
echo "Day flow:"
echo "  'awake' / 'morning' — Start your day"
echo "  'sync' / 'status'   — Mid-day check-in"
echo "  'gn' / 'done'       — Close the day"
echo ""
echo "Mobile capture: https://lout33.github.io/claude_life_assistant/capture/"
echo "  Just add your GitHub token — gist is created automatically."
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
