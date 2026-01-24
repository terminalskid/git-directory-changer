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

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  SHELL_RC="$HOME/.bashrc"
  if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_RC="$HOME/.zshrc"
  fi
  echo "export PATH=\$PATH:$INSTALL_DIR" >> "$SHELL_RC"
fi

DEFAULT="${GIT_DEFAULT:-$HOME/GitRepos}"
read -rp "Enter default Git folder [$DEFAULT]: " INPUT
INPUT=${INPUT:-$DEFAULT}

if command -v python3 >/dev/null 2>&1; then
  GITLOC_DIR="$HOME/.gitloc" python3 "$INSTALL_DIR/git-loc.py" set "$INPUT" >/dev/null || true
else
  GITLOC_DIR="$HOME/.gitloc" python "$INSTALL_DIR/git-loc.py" set "$INPUT" >/dev/null || true
fi

echo "Installed git-loc, gclone, and gloco. Restart terminal to persist PATH."
