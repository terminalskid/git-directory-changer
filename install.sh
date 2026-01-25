#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.gitloc/bin"
mkdir -p "$INSTALL_DIR"

cp ./git-loc.py "$INSTALL_DIR/git-loc.py"
chmod +x "$INSTALL_DIR/git-loc.py"

cat > "$INSTALL_DIR/git-loc" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
  python3 "$SCRIPT_DIR/git-loc.py" "$@"
else
  python "$SCRIPT_DIR/git-loc.py" "$@"
fi
EOF
chmod +x "$INSTALL_DIR/git-loc"

cat > "$INSTALL_DIR/gclone" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
  python3 "$SCRIPT_DIR/git-loc.py" gclone "$@"
else
  python "$SCRIPT_DIR/git-loc.py" gclone "$@"
fi
EOF
chmod +x "$INSTALL_DIR/gclone"

cat > "$INSTALL_DIR/gloco" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
  python3 "$SCRIPT_DIR/git-loc.py" gloco "$@"
else
  python "$SCRIPT_DIR/git-loc.py" gloco "$@"
fi
EOF
chmod +x "$INSTALL_DIR/gloco"

cat > "$INSTALL_DIR/gdc" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
  python3 "$SCRIPT_DIR/git-loc.py" menu "$@"
else
  python "$SCRIPT_DIR/git-loc.py" menu "$@"
fi
EOF
chmod +x "$INSTALL_DIR/gdc"

echo "=== Git Directory Changer Installer ==="
echo "Install directory: $INSTALL_DIR"
echo "Current shell: $SHELL"

# Check if INSTALL_DIR is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo -n "Adding $INSTALL_DIR to PATH... "
  SHELL_RC="$HOME/.bashrc"
  if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_RC="$HOME/.zshrc"
  fi
  echo "export PATH=\$PATH:$INSTALL_DIR" >> "$SHELL_RC"
  echo "✓ Added to $SHELL_RC"
else
  echo "✓ $INSTALL_DIR already in PATH"
fi

# Update current session PATH
echo -n "Updating current session PATH... "
export PATH="$PATH:$INSTALL_DIR"
echo "✓"

# Check Python availability
echo -n "Checking Python... "
PYTHON_CMD=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_CMD="python3"
  echo "✓ Found python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_CMD="python"
  echo "✓ Found python"
else
  echo "⚠ Python not found"
  echo "  Please install Python and add it to PATH"
fi

# Set default folder
echo -n "Setting default Git folder... "
DEFAULT="${GIT_DEFAULT:-$HOME/GitRepos}"
read -rp "Enter default Git folder [$DEFAULT]: " INPUT
INPUT=${INPUT:-$DEFAULT}

if [ -n "$PYTHON_CMD" ]; then
  GITLOC_DIR="$HOME/.gitloc" "$PYTHON_CMD" "$INSTALL_DIR/git-loc.py" set "$INPUT"
  echo "✓ Set to $INPUT"
else
  echo "⚠ Could not set default folder (Python not found)"
  echo "  Run 'git-loc set <path>' after installing Python"
fi

# Test installation
echo -n "Testing gclone... "
if command -v gclone >/dev/null 2>&1; then
  echo "✓ gclone is available! Try: gclone --help"
else
  echo "⚠ gclone not found in current session"
  echo "  Restart your terminal or run: source $SHELL_RC"
  echo "  Manual usage: $INSTALL_DIR/gclone <repo-url>"
fi

echo -e "\n=== Installation Complete ==="
echo "Commands installed: git-loc, gclone, gloco, gdc"
echo "Menu interface: gdc"
echo "Documentation: git-loc docs"
echo "\nTo uninstall: rm -rf $INSTALL_DIR"
echo "  (Also remove PATH entry from $SHELL_RC)"
