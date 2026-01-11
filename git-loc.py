#!/usr/bin/env python3
import os
import sys
import json
from pathlib import Path

CONFIG_DIR = Path.home() / ".gitloc"
CONFIG_FILE = CONFIG_DIR / "config.json"

def load_config():
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    return {}

def save_config(cfg):
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(cfg, f)

def cmd_set(path):
    path = os.path.abspath(path)
    save_config({"base_dir": path})
    print(f"Git default directory set to: {path}")

def cmd_show():
    cfg = load_config()
    print(cfg.get("base_dir", "Not set"))

def cmd_clone(repo):
    cfg = load_config()
    base = cfg.get("base_dir")
    if not base:
        print("No default directory set. Use: git loc set <path>")
        sys.exit(1)
    os.makedirs(base, exist_ok=True)
    os.chdir(base)
    os.system(f"git clone {repo}")

def cmd_reset():
    if CONFIG_FILE.exists():
        CONFIG_FILE.unlink()
        print("Git location reset")
    else:
        print("No configuration found")

def cmd_gloco():
    """Show the current git location folder"""
    cfg = load_config()
    base = cfg.get("base_dir")
    if base:
        print(f"Your current Git default folder is: {base}")
    else:
        print("No Git default folder is set. Use: git loc set <path>")

def main():
    if len(sys.argv) < 2:
        print("Usage: git loc [set|clone|gclone|show|reset|gloco]")
        return

    action = sys.argv[1].lower()

    if action == "set" and len(sys.argv) > 2:
        cmd_set(sys.argv[2])
    elif action == "clone" and len(sys.argv) > 2:
        cmd_clone(sys.argv[2])
    elif action == "gclone" and len(sys.argv) > 2:
        cmd_clone(sys.argv[2])
    elif action == "show":
        cmd_show()
    elif action == "reset":
        cmd_reset()
    elif action == "gloco":
        cmd_gloco()
    else:
        print("Unknown command or missing argument")

if __name__ == "__main__":
    main()
