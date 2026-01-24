#!/usr/bin/env python3
import os
import sys
import json
import subprocess
from pathlib import Path
from argparse import ArgumentParser

def resolve_config_dir():
    override = os.environ.get("GITLOC_DIR")
    if override:
        return Path(override).expanduser()
    return Path.home() / ".gitloc"

CONFIG_DIR = resolve_config_dir()
CONFIG_FILE = CONFIG_DIR / "config.json"

def load_config():
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    return {}

def save_config(cfg):
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        json.dump(cfg, f, indent=2)

def cmd_set(path):
    base = os.path.abspath(os.path.expanduser(path))
    save_config({"base_dir": base})
    print(f"Default Git folder set to: {base}")

def cmd_show():
    cfg = load_config()
    print(cfg.get("base_dir", "Not set"))

def cmd_clone(repo):
    cfg = load_config()
    base = cfg.get("base_dir")
    if not base:
        print("No default folder set. Run: gitloc set <path>")
        sys.exit(1)
    os.makedirs(base, exist_ok=True)
    try:
        subprocess.run(["git", "clone", repo], cwd=base, check=True)
    except subprocess.CalledProcessError as e:
        print(f"git clone failed with exit code {e.returncode}")
        sys.exit(e.returncode or 1)

def cmd_reset():
    if CONFIG_FILE.exists():
        CONFIG_FILE.unlink()
        print("Default Git folder cleared")
    else:
        print("No configuration found")

def cmd_gloco():
    cfg = load_config()
    base = cfg.get("base_dir")
    if base:
        print(base)
    else:
        print("Not set")

def dispatch_legacy(argv):
    if not argv:
        return None
    action = argv[0].lower()
    if action in ("gclone", "clone") and len(argv) > 1:
        cmd_clone(argv[1])
        return True
    if action == "set" and len(argv) > 1:
        cmd_set(argv[1])
        return True
    if action == "show":
        cmd_show()
        return True
    if action == "reset":
        cmd_reset()
        return True
    if action == "gloco":
        cmd_gloco()
        return True
    return None

def main():
    legacy = dispatch_legacy(sys.argv[1:])
    if legacy:
        return

    p = ArgumentParser(prog="gitloc")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_set = sub.add_parser("set")
    p_set.add_argument("path")

    p_show = sub.add_parser("show")

    p_clone = sub.add_parser("clone")
    p_clone.add_argument("repo")

    p_reset = sub.add_parser("reset")

    args = p.parse_args()
    if args.cmd == "set":
        cmd_set(args.path)
    elif args.cmd == "show":
        cmd_show()
    elif args.cmd == "clone":
        cmd_clone(args.repo)
    elif args.cmd == "reset":
        cmd_reset()

if __name__ == "__main__":
    main()
