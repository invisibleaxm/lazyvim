#!/usr/bin/env bash
# Neovim Lazy.nvim Cleanup and Sync Script
# Cleans corrupted plugins, resets local changes, and syncs all plugins

set -euo pipefail

# Parse arguments
FULL_CLEAN=false
SKIP_SYNC=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --full-clean)
            FULL_CLEAN=true
            shift
            ;;
        --skip-sync)
            SKIP_SYNC=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --full-clean    Remove entire lazy plugin directory"
            echo "  --skip-sync     Skip the final sync step"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Detect config and data directories
if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_DIR="$HOME/.config/nvim"
    DATA_DIR="$HOME/.local/share/nvim"
else
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
fi

LAZY_DIR="$DATA_DIR/lazy"
PARSER_DIR="$DATA_DIR/site/parser"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo -e "\n${CYAN}🧹 Neovim Lazy.nvim Cleanup Script${NC}"
echo -e "${CYAN}================================${NC}"

# Function to safely remove file/directory
remove_safely() {
    local path="$1"
    local desc="$2"
    if [[ -e "$path" ]]; then
        if rm -rf "$path" 2>/dev/null; then
            echo -e "  ${GREEN}✓ Removed $desc${NC}"
            return 0
        else
            echo -e "  ${YELLOW}⚠ Failed to remove $desc${NC}"
            return 1
        fi
    fi
    return 1
}

# Step 1: Remove lock file
echo -e "\n${CYAN}📌 Step 1: Removing lock file...${NC}"
remove_safely "$CONFIG_DIR/lazy-lock.json" "lazy-lock.json" || true

# Step 2: Full clean or targeted cleanup
if [[ "$FULL_CLEAN" == "true" ]]; then
    echo -e "\n${CYAN}🗑️  Step 2: Full clean (removing all plugins)...${NC}"
    if remove_safely "$LAZY_DIR" "all plugins"; then
        echo -e "  ${GRAY}ℹ All plugins will be reinstalled on next launch${NC}"
    fi
else
    # Step 2: Clean corrupted parser files
    echo -e "\n${CYAN}🔍 Step 2: Cleaning corrupted parser files...${NC}"
    if [[ -d "$PARSER_DIR" ]]; then
        CORRUPTED_COUNT=$(find "$PARSER_DIR" -name "*.so2*" 2>/dev/null | wc -l)
        if [[ $CORRUPTED_COUNT -gt 0 ]]; then
            find "$PARSER_DIR" -name "*.so2*" -type f -print -delete 2>/dev/null
            echo -e "  ${GREEN}✓ Removed $CORRUPTED_COUNT corrupted parser(s)${NC}"
        else
            echo -e "  ${GREEN}✓ No corrupted parsers found${NC}"
        fi
    else
        echo -e "  ${GRAY}ℹ Parser directory doesn't exist yet${NC}"
    fi

    # Step 3: Clean .cloning temp directories
    echo -e "\n${CYAN}🧼 Step 3: Cleaning temporary clone directories...${NC}"
    if [[ -d "$LAZY_DIR" ]]; then
        CLONING_COUNT=$(find "$LAZY_DIR" -maxdepth 1 -name "*.cloning" -type d 2>/dev/null | wc -l)
        if [[ $CLONING_COUNT -gt 0 ]]; then
            find "$LAZY_DIR" -maxdepth 1 -name "*.cloning" -type d -exec basename {} \; -exec rm -rf {} \; 2>/dev/null
            echo -e "  ${GREEN}✓ Removed $CLONING_COUNT temp clone dir(s)${NC}"
        else
            echo -e "  ${GREEN}✓ No temp directories found${NC}"
        fi
    fi

    # Step 4: Reset plugins with local changes
    echo -e "\n${CYAN}🔄 Step 4: Resetting plugins with local changes...${NC}"
    if [[ -d "$LAZY_DIR" ]]; then
        RESET_COUNT=0
        for plugin_dir in "$LAZY_DIR"/*/; do
            if [[ -d "$plugin_dir/.git" ]]; then
                cd "$plugin_dir"
                if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
                    echo -e "  ${YELLOW}Resetting: $(basename "$plugin_dir")${NC}"
                    git reset --hard HEAD >/dev/null 2>&1
                    git clean -fd >/dev/null 2>&1
                    ((RESET_COUNT++))
                fi
            fi
        done
        if [[ $RESET_COUNT -gt 0 ]]; then
            echo -e "  ${GREEN}✓ Reset $RESET_COUNT plugin(s)${NC}"
        else
            echo -e "  ${GREEN}✓ No local changes found${NC}"
        fi
    fi
fi

# Step 5: Sync plugins
if [[ "$SKIP_SYNC" != "true" ]]; then
    echo -e "\n${CYAN}🔄 Step 5: Syncing all plugins...${NC}"
    echo -e "  ${GRAY}This may take a minute...${NC}"

    SYNC_OUTPUT=$(nvim --headless "+Lazy! sync" +qa 2>&1 || true)

    # Check for errors
    if echo "$SYNC_OUTPUT" | grep -iE "error|failed|local changes" >/dev/null; then
        echo -e "  ${YELLOW}⚠ Sync completed with warnings:${NC}"
        echo "$SYNC_OUTPUT" | grep -iE "error|failed|local changes" | sed 's/^/    /'
    else
        echo -e "  ${GREEN}✓ All plugins synced successfully${NC}"
    fi
else
    echo -e "\n${GRAY}⏭️  Skipping sync step${NC}"
fi

# Step 6: Summary
echo -e "\n${CYAN}📊 Summary${NC}"
echo -e "${CYAN}================================${NC}"

if [[ -d "$LAZY_DIR" ]]; then
    PLUGIN_COUNT=$(find "$LAZY_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l)
    echo -e "  ${GREEN}📦 Plugins: $PLUGIN_COUNT${NC}"
else
    echo -e "  ${YELLOW}📦 Plugins: 0 (will install on next launch)${NC}"
fi

if [[ -d "$PARSER_DIR" ]]; then
    PARSER_COUNT=$(find "$PARSER_DIR" -name "*.so" 2>/dev/null | wc -l)
    echo -e "  ${GREEN}🌳 Treesitter parsers: $PARSER_COUNT${NC}"
else
    echo -e "  ${GRAY}🌳 Treesitter parsers: 0${NC}"
fi

echo -e "\n${GREEN}✨ Cleanup complete! Launch Neovim to verify.${NC}\n"
