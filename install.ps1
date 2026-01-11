#!/usr/bin/env bash

INSTALL_DIR="$HOME/.gitloc/bin"
mkdir -p "$INSTALL_DIR"

cp ./git-loc.py "$INSTALL_DIR/git-loc"
chmod +x "$INSTALL_DIR/git-loc"

# Create gclone wrapper
echo -e '#!/usr/bin/env bash\npython3 "$HOME/.gitloc/bin/git-loc" gclone "$@"' > "$INSTALL_DIR/gclone"
chmod +x "$INSTALL_DIR/gclone"

# Add to PATH if missing
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  SHELL_RC="$HOME/.bashrc"
  if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
  fi
  echo "export PATH=\$PATH:$INSTALL_DIR" >> "$SHELL_RC"
fi

echo "Git Location Changer installed with gclone. Restart your terminal."
