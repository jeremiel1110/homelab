# Homelab

Config files and scripts for my homelab (Proxmox, Docker, and soon Kubernetes).

## Structure

| Folder | What it holds |
| --- | --- |
| `homepage/` | [Homepage](https://gethomepage.dev) dashboard: `docker-compose.yml` and `config/` |
| `scripts/` | Small helper scripts |

## Homepage

```bash
cd homepage
touch .env          # required by docker-compose.yml, never committed
docker compose up -d
```

Edits to `homepage/config/*.yaml` are picked up by Homepage automatically.
On the Docker LXC, `scripts/sync-homepage.sh` pulls this repo every 2 minutes, so a push is enough to update the dashboard.

## Scripts

| Script | Purpose |
| --- | --- |
| `scripts/setup-terminal.sh` | zsh + Starship prompt on a fresh Ubuntu/Debian VM |
| `scripts/sync-homepage.sh` | Pulls the repo and re-applies the Homepage stack if its compose file changed (run from cron) |

Set up the terminal on a new VM:

```bash
curl -fsSL https://raw.githubusercontent.com/jeremiel1110/homelab/main/scripts/setup-terminal.sh | bash
```

The prompt icons need a [Nerd Font](https://www.nerdfonts.com) on the machine you connect from, not on the VM.

## Conventions

- Commit messages start with a type: `feat`, `fix`, `docs`, `chore`, for example `feat(scripts): add ...`.
- Secrets (`.env`, keys, kubeconfigs) are never committed. See `.gitignore`.
