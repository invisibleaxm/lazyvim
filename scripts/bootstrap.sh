#!/usr/bin/env bash
# Neovim Bootstrap Script
# Performs initial setup, plugin installation, and configuration headlessly

set -euo pipefail

# Parse arguments
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --force      Force reinstall even if already bootstrapped"
            echo "  --verbose    Show detailed output"
            echo "  -h, --help   Show this help message"
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
BOOTSTRAP_MARKER="$DATA_DIR/.bootstrapped"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo -e "\n${CYAN}🚀 Neovim Bootstrap Script${NC}"
echo -e "${CYAN}================================${NC}"

# Check if already bootstrapped
if [[ -f "$BOOTSTRAP_MARKER" ]] && [[ "$FORCE" != "true" ]]; then
    echo -e "\n${GREEN}✅ Neovim already bootstrapped!${NC}"
    echo -e "   ${GRAY}Use --force to run again${NC}"
    read -p $'\nContinue anyway? (y/N) ' -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Step 1: Prerequisites check
echo -e "\n${CYAN}📋 Step 1: Checking prerequisites...${NC}"

# Check Neovim
echo -n "  Checking Neovim..."
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9.]+')
    echo -e " ${GREEN}✓ $NVIM_VERSION${NC}"
else
    echo -e " ${RED}✗ Not found${NC}"
    echo -e "\n${RED}❌ Neovim is not installed or not in PATH${NC}"
    exit 1
fi

# Check C compiler (for Treesitter)
echo -n "  Checking C compiler..."
HAS_COMPILER=false
COMPILER=""

if command -v gcc &> /dev/null; then
    GCC_VERSION=$(gcc --version | head -n1)
    echo -e " ${GREEN}✓ gcc ($GCC_VERSION)${NC}"
    HAS_COMPILER=true
    COMPILER="gcc"
elif command -v clang &> /dev/null; then
    CLANG_VERSION=$(clang --version | head -n1)
    echo -e " ${GREEN}✓ clang ($CLANG_VERSION)${NC}"
    HAS_COMPILER=true
    COMPILER="clang"
else
    echo -e " ${YELLOW}⚠ Not found${NC}"
    echo -e "    ${YELLOW}Treesitter parser compilation will fail${NC}"
    echo -e "    ${GRAY}Install: xcode-select --install (macOS)${NC}"
    echo -e "    ${GRAY}Or: sudo apt install build-essential (Ubuntu/Debian)${NC}"
fi

# Check tree-sitter CLI
echo -n "  Checking tree-sitter CLI..."
if command -v tree-sitter &> /dev/null; then
    echo -e " ${GREEN}✓ Found${NC}"
else
    echo -e " ${YELLOW}⚠ Not found (optional)${NC}"
fi

# Check Git
echo -n "  Checking Git..."
if command -v git &> /dev/null; then
    echo -e " ${GREEN}✓ Found${NC}"
else
    echo -e " ${RED}✗ Not found${NC}"
    echo -e "\n${RED}❌ Git is required for plugin management${NC}"
    exit 1
fi

# Step 2: Clean slate
echo -e "\n${CYAN}🧹 Step 2: Preparing clean environment...${NC}"

if [[ -d "$DATA_DIR" ]]; then
    PLUGIN_COUNT=0
    if [[ -d "$LAZY_DIR" ]]; then
        PLUGIN_COUNT=$(find "$LAZY_DIR" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    fi

    if [[ $PLUGIN_COUNT -gt 0 ]] && [[ "$FORCE" == "true" ]]; then
        echo -e "  ${YELLOW}Removing existing plugins ($PLUGIN_COUNT)...${NC}"
        rm -rf "$LAZY_DIR"/*
        echo -e "  ${GREEN}✓ Cleaned plugin directory${NC}"
    elif [[ $PLUGIN_COUNT -gt 0 ]]; then
        echo -e "  ${GRAY}ℹ Found $PLUGIN_COUNT existing plugins (use --force to reinstall)${NC}"
    fi
fi

# Remove lock file for fresh start
if [[ -f "$CONFIG_DIR/lazy-lock.json" ]]; then
    rm -f "$CONFIG_DIR/lazy-lock.json"
    echo -e "  ${GREEN}✓ Removed lock file${NC}"
fi

# Step 3: Install plugins
echo -e "\n${CYAN}📦 Step 3: Installing plugins...${NC}"
echo -e "  ${GRAY}This will take 1-2 minutes...${NC}"

OUTPUT=$(nvim --headless "+Lazy! sync" +qa 2>&1 || true)

if [[ "$VERBOSE" == "true" ]]; then
    echo -e "\n${GRAY}--- Plugin Installation Output ---${NC}"
    echo "$OUTPUT"
    echo -e "${GRAY}--- End Output ---${NC}\n"
fi

# Check for errors
if echo "$OUTPUT" | grep -iE "error|failed" &> /dev/null; then
    echo -e "  ${YELLOW}⚠ Some plugins had issues:${NC}"
    echo "$OUTPUT" | grep -iE "error|failed" | sed 's/^/    /'
else
    echo -e "  ${GREEN}✓ Plugins installed successfully${NC}"
fi

# Count installed plugins
if [[ -d "$LAZY_DIR" ]]; then
    PLUGIN_COUNT=$(find "$LAZY_DIR" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    echo -e "  ${GRAY}ℹ Installed: $PLUGIN_COUNT plugins${NC}"
fi

# Step 4: Compile Treesitter parsers
echo -e "\n${CYAN}🌳 Step 4: Compiling Treesitter parsers...${NC}"

if [[ "$HAS_COMPILER" == "true" ]]; then
    echo -e "  ${GRAY}Compiling with $COMPILER...${NC}"

    TS_OUTPUT=$(nvim --headless "+TSUpdateSync" +qa 2>&1 || true)

    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "\n${GRAY}--- Treesitter Output ---${NC}"
        echo "$TS_OUTPUT"
        echo -e "${GRAY}--- End Output ---${NC}\n"
    fi

    # Count compiled parsers
    PARSER_DIR="$DATA_DIR/site/parser"
    if [[ -d "$PARSER_DIR" ]]; then
        PARSER_COUNT=$(find "$PARSER_DIR" -name "*.so" 2>/dev/null | wc -l)
        echo -e "  ${GREEN}✓ Compiled $PARSER_COUNT parsers${NC}"
    else
        echo -e "  ${YELLOW}⚠ Parser directory not created${NC}"
    fi
else
    echo -e "  ${YELLOW}⏭️  Skipped (no C compiler)${NC}"
fi

# Step 5: Install Mason tools
echo -e "\n${CYAN}🔧 Step 5: Installing Mason tools...${NC}"
echo -e "  ${GRAY}Installing LSP servers, formatters, linters...${NC}"

# Create a Lua script to install all Mason tools defined in config
MASON_SCRIPT=$(cat <<'EOF'
-- Mason bootstrap script
local ok, mason_registry = pcall(require, 'mason-registry')
if not ok then
  print('Mason not available yet')
  return
end

-- Wait for registry to load
if not mason_registry.is_installed('lua-language-server') then
  mason_registry.refresh()
end

-- Get all tools that should be installed from LSP config
local tools = {
  -- LSP servers
  'lua-language-server',
  'pyright',
  'rust-analyzer',
  'typescript-language-server',
  -- Formatters
  'stylua',
  'black',
  'isort',
  'prettier',
  -- Linters (if needed)
}

local installed = 0
for _, tool_name in ipairs(tools) do
  local ok, pkg = pcall(mason_registry.get_package, tool_name)
  if ok and not pkg:is_installed() then
    print('Installing ' .. tool_name)
    pkg:install()
    installed = installed + 1
  end
end

print('Queued ' .. installed .. ' tools for installation')
EOF
)

MASON_SCRIPT_PATH="/tmp/nvim-mason-bootstrap-$$.lua"
echo "$MASON_SCRIPT" > "$MASON_SCRIPT_PATH"

MASON_OUTPUT=$(nvim --headless -c "luafile $MASON_SCRIPT_PATH" -c "sleep 5" +qa 2>&1 || true)

if [[ "$VERBOSE" == "true" ]]; then
    echo -e "\n${GRAY}--- Mason Output ---${NC}"
    echo "$MASON_OUTPUT"
    echo -e "${GRAY}--- End Output ---${NC}\n"
fi

# Give Mason time to install tools in background
echo -e "  ${GRAY}ℹ Mason installations run in background${NC}"
echo -e "  ${GRAY}ℹ Check progress with :Mason in Neovim${NC}"

rm -f "$MASON_SCRIPT_PATH"

# Step 6: Final verification
echo -e "\n${CYAN}✅ Step 6: Verification${NC}"
echo -e "${CYAN}================================${NC}"

ALL_GOOD=true

# Check plugins
if [[ -d "$LAZY_DIR" ]]; then
    PLUGIN_COUNT=$(find "$LAZY_DIR" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    echo -e "  ${GREEN}📦 Plugins: $PLUGIN_COUNT${NC}"
    if [[ $PLUGIN_COUNT -lt 50 ]]; then
        echo -e "     ${YELLOW}⚠ Expected ~60+ plugins${NC}"
        ALL_GOOD=false
    fi
else
    echo -e "  ${RED}📦 Plugins: ✗ None installed${NC}"
    ALL_GOOD=false
fi

# Check parsers
PARSER_DIR="$DATA_DIR/site/parser"
if [[ -d "$PARSER_DIR" ]]; then
    PARSER_COUNT=$(find "$PARSER_DIR" -name "*.so" 2>/dev/null | wc -l)
    echo -e "  ${GREEN}🌳 Treesitter parsers: $PARSER_COUNT${NC}"
    if [[ $PARSER_COUNT -eq 0 ]] && [[ "$HAS_COMPILER" == "true" ]]; then
        echo -e "     ${YELLOW}⚠ No parsers compiled${NC}"
        ALL_GOOD=false
    fi
else
    if [[ "$HAS_COMPILER" == "true" ]]; then
        echo -e "  ${RED}🌳 Treesitter parsers: ✗ None compiled${NC}"
        ALL_GOOD=false
    else
        echo -e "  ${GRAY}🌳 Treesitter parsers: ⏭️  Skipped (no compiler)${NC}"
    fi
fi

# Check Mason
MASON_DIR="$DATA_DIR/mason/packages"
if [[ -d "$MASON_DIR" ]]; then
    MASON_COUNT=$(find "$MASON_DIR" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    echo -e "  ${GREEN}🔧 Mason packages: $MASON_COUNT (installing in background)${NC}"
else
    echo -e "  ${GRAY}🔧 Mason packages: 0 (will install on first use)${NC}"
fi

# Mark as bootstrapped
if [[ "$ALL_GOOD" == "true" ]]; then
    date > "$BOOTSTRAP_MARKER"
    echo -e "\n${GREEN}✨ Bootstrap complete!${NC}"
    echo -e "   ${GREEN}Neovim is ready to use.${NC}"
else
    echo -e "\n${YELLOW}⚠ Bootstrap completed with warnings${NC}"
    echo -e "   ${YELLOW}Neovim should work, but may need manual fixes.${NC}"
fi

echo -e "\n${CYAN}📚 Next Steps:${NC}"
echo -e "  ${GRAY}1. Launch Neovim: nvim${NC}"
echo -e "  ${GRAY}2. Check health: :checkhealth${NC}"
echo -e "  ${GRAY}3. View plugins: :Lazy${NC}"
echo -e "  ${GRAY}4. Check Mason: :Mason${NC}"
echo ""
