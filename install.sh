#!/usr/bin/env bash

INSTALL_DIR="$HOME/.gitloc/bin"
mkdir -p "$INSTALL_DIR"

# Copy git-loc.py as git-loc wrapper
cp ./git-loc.py "$INSTALL_DIR/git-loc"
chmod +x "$INSTALL_DIR/git-loc"

# Create gclone wrapper
echo -e '#!/usr/bin/env bash\npython3 "$HOME/.gitloc/bin/git-loc" gclone "$@"' > "$INSTALL_DIR/gclone"
chmod +x "$INSTALL_DIR/gclone"

# Create gloco wrapper
echo -e '#!/usr/bin/env bash\npython3 "$HOME/.gitloc/bin/git-loc" gloco "$@"' > "$INSTALL_DIR/gloco"
chmod +x "$INSTALL_DIR/gloco"

# Add INSTALL_DIR to PATH if not already
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  SHELL_RC="$HOME/.bashrc"
  if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
  fi
  echo "export PATH=\$PATH:$INSTALL_DIR" >> "$SHELL_RC"
fi

echo "Git Location Changer installed with gclone and gloco integrated. Restart your terminal."
