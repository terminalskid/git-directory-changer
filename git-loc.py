#!/usr/bin/env python3
import os
import sys
import json
import subprocess
from pathlib import Path
from argparse import ArgumentParser
import re
from urllib.parse import urlparse, urlunparse
import webbrowser

DOCS_URL = "https://gdc-docs.vercel.app/"

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
    repo = normalize_repo_input(repo)
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

def cmd_docs():
    webbrowser.open(DOCS_URL)
    print("Opening docs...")

def normalize_repo_input(s: str) -> str:
    raw = s.strip()
    if not raw:
        print("Missing repository argument. Example: gclone github.com/user/repo")
        sys.exit(2)
    if not looks_like_repo(raw):
        print(f"Unrecognized repository format: {raw}")
        print("Try: gclone github.com/user/repo or gclone https://host/user/repo.git")
        sys.exit(2)
    if "://" not in raw and ("@" in raw and ":" in raw):
        return raw if raw.endswith(".git") else raw + ".git"
    raw = re.sub(r"^(https?):/+", r"\1://", raw)
    if not re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*://", raw):
        raw = "https://" + raw
    u = urlparse(raw)
    if not u.netloc and u.path:
        parts = u.path.split("/")
        domain = parts[0]
        rest = "/".join(parts[1:]) if len(parts) > 1 else ""
        u = u._replace(netloc=domain, path=("/" + rest) if rest else "")
    out = urlunparse(u)
    if "?" not in out and "#" not in out and not out.endswith(".git"):
        out = out + ".git"
    return out

def looks_like_repo(s: str) -> bool:
    if "://" in s:
        return True
    if "@" in s and ":" in s:
        return True
    if "." in s and "/" in s:
        return True
    return False

def dispatch_legacy(argv):
    if not argv:
        run_menu()
        return True
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
    if action == "menu":
        run_menu()
        return True
    if action == "docs":
        cmd_docs()
        return True
    return None

def run_menu():
    while True:
        print("")
        print("###############################")
        print("#  Git Location Changer (GDC) #")
        print("###############################")
        print("1) Set default folder")
        print("2) Clone repository")
        print("3) Show default folder")
        print("4) Reset configuration")
        print("5) Open docs")
        print("6) Exit")
        choice = input("Select an option [1-6]: ").strip()
        if choice == "1":
            path = input("Enter folder path: ").strip()
            if path:
                cmd_set(path)
        elif choice == "2":
            repo = input("Enter repo (e.g. github.com/user/repo): ").strip()
            if repo:
                cmd_clone(repo)
        elif choice == "3":
            cmd_gloco()
        elif choice == "4":
            cmd_reset()
        elif choice == "5":
            cmd_docs()
        elif choice == "6":
            break
        else:
            print("Invalid selection")

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
    sub.add_parser("menu")
    sub.add_parser("docs")

    args = p.parse_args()
    if args.cmd == "set":
        cmd_set(args.path)
    elif args.cmd == "show":
        cmd_show()
    elif args.cmd == "clone":
        cmd_clone(args.repo)
    elif args.cmd == "reset":
        cmd_reset()
    elif args.cmd == "menu":
        run_menu()
    elif args.cmd == "docs":
        cmd_docs()

if __name__ == "__main__":
    main()
