# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- The scoped `/mnt/d` mount and disabled WSL automount (`configuration.nix`) are
  intentional isolation: this sandbox should only ever see
  `D:\Software_Installations\nix`, not all of `C:\`/`D:\`. Don't restore full-drive
  automount. The `metadata` mount option is required - without it `chmod` fails
  (breaks `git init`, `ssh-keygen`, etc).
- No `NOPASSWD` sudo (`configuration.nix`). Removed on purpose: it let a live
  session bypass the mount isolation above via a plain `sudo mount`. Don't
  re-add it for convenience.
- `herdr` is built from its own flake input (`ogulcancelik/herdr`, pinned to a
  release tag in `flake.nix`), not nixpkgs - it isn't packaged there.
- Claude Code stays npm-installed on purpose (see `notest`) - nixpkgs' `claude-code`
  lags behind the latest release. Don't switch it to `pkgs.claude-code`.
- `home/.claude` tracks only `settings.json`, and `home/.config/herdr` tracks
  only `config.toml` (see `.gitignore`). Never point a symlink or `home.file`
  entry at either whole directory - `.claude` holds `.credentials.json` and
  full conversation history, `herdr` writes `session.json`/`herdr-*.log`/
  `*.sock` at runtime, and this repo is public. Same rule applies to any
  future tool added the same way: symlink the one config file, not the
  directory, unless you've confirmed the tool writes no runtime state there.
- `home/PROJECTS/` is gitignored scratch space, not repo content - the user
  keeps all new work-in-progress projects there, outside this dotfiles repo.
- `notest` is the user's personal scratch notes. Don't stage or commit it
  unless asked.
- Config files under `home/` (wezterm, nvim, herdr, claude) are symlinked
  out-of-store via `mkOutOfStoreSymlink` in `home.nix` - edit them in place,
  no rebuild needed. Only `./rebuild.sh` (not raw `nixos-rebuild`) when
  changing a package list or system setting, since it also re-pins
  `~/.dotfiles` to wherever this repo actually lives.
- `home/AGENTS.md` is the personal, cross-project agent policy - symlinked to
  `~/.claude/CLAUDE.md` so it applies globally, not just here. This file
  (repo root `AGENTS.md`) is the one that stays repo-specific and unlinked.
  Don't merge them back together.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
