#!/usr/bin/env bash
# Neovim Quick Setup - All-in-one script for fresh installations
# Combines bootstrap + cleanup for foolproof setup

set -euo pipefail

# Parse arguments
FORCE=""
VERBOSE=""
SKIP_BOOTSTRAP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE="--force"
            shift
            ;;
        --verbose)
            VERBOSE="--verbose"
            shift
            ;;
        --skip-bootstrap)
            SKIP_BOOTSTRAP=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --force           Force reinstall"
            echo "  --verbose         Show detailed output"
            echo "  --skip-bootstrap  Only run cleanup"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_SCRIPT="$SCRIPT_DIR/bootstrap.sh"
CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "\n${CYAN}🎯 Neovim Quick Setup${NC}"
echo -e "${CYAN}================================${NC}\n"

# Step 1: Run cleanup first to ensure clean slate
echo -e "${CYAN}🧹 Step 1: Cleaning up any existing issues...${NC}"
"$CLEANUP_SCRIPT" --skip-sync
echo ""

# Step 2: Bootstrap if not skipped
if [[ "$SKIP_BOOTSTRAP" != "true" ]]; then
    echo -e "${CYAN}🚀 Step 2: Running bootstrap...${NC}"
    "$BOOTSTRAP_SCRIPT" $FORCE $VERBOSE
else
    echo -e "${GRAY}⏭️  Step 2: Skipping bootstrap${NC}"
fi

echo -e "\n${GREEN}✨ Setup complete!${NC}\n"
