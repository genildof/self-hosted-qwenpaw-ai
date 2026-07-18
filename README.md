# QwenPaw on Coolify: One-Click Deployment Guide 🚀

[![License](https://img.shields.io/badge/license-Apache--2.0-blue)](LICENSE)[![Docker](https://img.shields.io/badge/docker-official-blue)](https://hub.docker.com/r/agentscope/qwenpaw)[![Coolify](https://img.shields.io/badge/coolify-friendly-green)](https://coolify.io)

**Deploy your own private AI Agent in minutes.** This repository provides the optimized `Dockerfile` and `docker-compose.yaml` needed to run **QwenPaw** on a **Coolify** server with persistent storage, automated networking, and secure memory.

---

## 🤖 What is QwenPaw?

[QwenPaw](https://github.com/agentscope-ai/QwenPaw) is a powerful, self-hosted personal AI assistant built on the **Agent OS** architecture. It is designed to be your autonomous companion, featuring:

- **Three-Layer Memory:** Live context, full history, and distilled knowledge (nothing is lost).

- **Kernel-Level Sandbox:** Secure execution of tools and commands.

- **Multi-Channel Ops:** Connect to Discord, Telegram, WeChat, Slack, and more.

- **Agent OS Drivers:** Protocol-neutral connectors for MCP and cloud providers.

## 🛠️ Why use this Coolify setup?

While QwenPaw is easy to run locally, deploying it on a VPS via **Coolify** gives you a professional-grade AI workstation:

- **24/7 Availability:** Your agent handles news digests and report generation while you sleep.

- **Automated SSL/HTTPS:** Secure access from any device (Desktop, iPad, Mobile).

- **Persistent Storage:** Custom volume mappings ensure your agent's memory survives updates.

- **Automated Health Monitoring:** Built-in health checks ensure Coolify only routes traffic to a healthy agent.

- **One-Click Updates:** Stay on the latest version of QwenPaw with zero downtime.

---

## 🚀 Quick Start (1-Click Deploy)

1. **Create a New Resource** in your Coolify dashboard.

1. **Select Public Repository** and paste this repository URL: `https://github.com/YOUR_USERNAME/qwenpaw-coolify-one-click`

1. **Choose Build Pack:** Select `Dockerfile`.

1. **Network Configuration:** Set the destination port to **`8088`**.

1. **Deploy!**

### Environment Variables (Optional )

You can configure these in the Coolify UI before or after deployment:

| Variable | Default | Description |
| --- | --- | --- |
| `QWENPAW_AUTH_ENABLED` | `false` | Set to `true` to enable console login |
| `QWENPAW_AUTH_USERNAME` | `admin` | Your console username |
| `QWENPAW_AUTH_PASSWORD` | *(empty)* | **Required** if authentication is enabled |

### Coolify resource limits

The Compose file is tuned for small servers where Coolify, Traefik, databases,
mail services, and other containers are already running. The default profile
prioritizes host stability over maximum QwenPaw performance.

Recommended baseline for a 4 GB RAM host:

| Resource | Default | Why |
| --- | --- | --- |
| Memory hard limit | `1536m` | Gives local Whisper enough room while still capping QwenPaw below half of a 4 GB host |
| Memory reservation | `1g` | Lets Docker account for expected memory pressure before the hard limit |
| Memory plus swap | `1536m` | Prevents swap growth beyond the hard limit and reduces the risk of host swap thrashing |
| CPU limit | `1.00` | Leaves CPU time available for Coolify, Traefik, PostgreSQL, Redis, and mail services |
| PID/process limit | `256` | Stays above QwenPaw/supervisord's 200-process startup requirement while still limiting runaway process creation |
| `/tmp` limit | `256m` | Provides room for audio/STT temporary files while still preventing unbounded growth |
| Log retention | `5m` x `2` files | Limits Docker JSON log growth |
| Linux capabilities | Drop `NET_RAW` only | Keeps the desktop/dbus stack compatible while removing raw socket access |

#### Runtime variables

Configure these in the Coolify UI if the defaults are too strict or too loose:

| Variable | Default | Description | Adjustment guidance |
| --- | --- | --- | --- |
| `QWENPAW_CPUS` | `1.00` | Maximum CPU cores available to the container | Lower to `0.50` if the server remains CPU-bound; raise only if the host has spare CPU |
| `QWENPAW_MEMORY_LIMIT` | `1536m` | Hard memory limit for the container | Use `1g` only for text-only deployments; local Whisper commonly needs more headroom |
| `QWENPAW_MEMORY_SWAP_LIMIT` | `1536m` | Total memory plus swap allowed to the container | Keep equal to `QWENPAW_MEMORY_LIMIT` to avoid swap thrashing |
| `QWENPAW_MEMORY_RESERVATION` | `1g` | Soft memory reservation used by Docker scheduling/accounting | Set below the hard limit; `768m` is safer but may reduce responsiveness |
| `QWENPAW_MEMORY_SWAPPINESS` | `0` | Kernel preference for swapping container memory | Keep `0` on small hosts to avoid Docker/Coolify becoming unresponsive |
| `QWENPAW_PIDS_LIMIT` | `256` | Maximum PIDs inside the container | Keep above `200`; QwenPaw uses supervisord and may fail startup below this |
| `QWENPAW_NPROC_LIMIT` | `256` | Process limit exposed through Linux ulimit | Keep aligned with `QWENPAW_PIDS_LIMIT` and above `200` |
| `QWENPAW_NOFILE_SOFT_LIMIT` | `2048` | Soft open-file limit | Raise if logs show "too many open files" |
| `QWENPAW_NOFILE_HARD_LIMIT` | `4096` | Hard open-file limit | Keep at or above the soft limit |
| `QWENPAW_TMPFS_SIZE` | `256m` | Size of the in-memory `/tmp` mount | Raise if uploads, voice processing, or temporary operations fail due to lack of temp space |
| `QWENPAW_LOG_MAX_SIZE` | `5m` | Maximum size for each Docker JSON log file | Raise only if you need more local log history |
| `QWENPAW_LOG_MAX_FILE` | `2` | Number of rotated Docker JSON log files to keep | Keep low on small disks |
| `QWENPAW_TMPDIR` | `/app/working` | Temporary directory used by Python tools and runtime installs | Keep under `/app/working`; the default path always exists because it is the persisted data volume |
| `QWENPAW_CACHE_HOME` | `/app/working/.cache` | Persistent cache directory for Python/model caches | Keep under `/app/working` to avoid re-downloading voice/STT assets |
| `QWENPAW_HF_HOME` | `/app/working/.cache/huggingface` | Persistent Hugging Face cache path | Keep under `/app/working` if local Whisper downloads model assets |
| `QWENPAW_TRANSCRIPTION_PROVIDER_TYPE` | `local_whisper` | Voice transcription provider hint for QwenPaw | Also verify the saved setting in the QwenPaw console |
| `QWENPAW_OMP_NUM_THREADS` | `1` | OpenMP thread limit for Whisper/numeric libraries | Keep low on small hosts to avoid CPU and memory spikes |
| `QWENPAW_OPENBLAS_NUM_THREADS` | `1` | OpenBLAS thread limit | Keep low unless the host has spare CPU and RAM |
| `QWENPAW_MKL_NUM_THREADS` | `1` | MKL thread limit | Keep low unless the host has spare CPU and RAM |
| `QWENPAW_NUMEXPR_NUM_THREADS` | `1` | NumExpr thread limit | Keep low unless the host has spare CPU and RAM |
| `QWENPAW_TOKENIZERS_PARALLELISM` | `false` | Disables tokenizer worker fan-out | Keep disabled on small hosts |

#### Native Telegram voice transcription

This deployment uses QwenPaw's native voice transcription path instead of a
custom file watcher or skill workaround.

What is included in this repository:

- The Dockerfile extends the official QwenPaw image and installs
  `qwenpaw[whisper]` at build time. This makes the local Whisper backend
  available after every Coolify rebuild.
- The Compose service uses `build.context: .`, so Coolify builds this custom
  image instead of running the unmodified upstream image.
- `transcription_provider_type=local_whisper` is set in the container
  environment as a default provider hint.
- `TMPDIR`, `XDG_CACHE_HOME`, and `HF_HOME` point under `/app/working`, which is
  persisted by the `qwenpaw-data` Docker volume.
- `/tmp` is raised to `256m` for audio processing and temporary files.
- Numeric/ML thread pools are limited to one thread by default to reduce memory
  and CPU spikes during local Whisper transcription.

After deployment, verify the native setting in the QwenPaw console:

| Setting | Value |
| --- | --- |
| Settings -> Voice transcription -> Audio mode | `Auto` |
| Settings -> Voice transcription -> Transcription backend | `Local Whisper` |

If QwenPaw saves these settings to `/app/working/config.json`, they persist
across normal Coolify redeploys because `/app/working` is mounted as the
`qwenpaw-data` named volume. Do not delete or recreate the `qwenpaw-data`,
`qwenpaw-secrets`, or `qwenpaw-backups` volumes unless you intend to reset the
instance.

TTS responses remain handled by QwenPaw's native skill/configuration layer. Keep
the TTS credentials and provider settings in the QwenPaw console or persisted
configuration, not in temporary paths.

#### Operational notes

- If the host starts using heavy swap after QwenPaw is deployed, do not raise
  `QWENPAW_MEMORY_SWAP_LIMIT`. Lower `QWENPAW_CPUS`, keep memory plus swap equal
  to the memory limit, and check which other services are consuming RAM.
- If QwenPaw is killed or restarted under normal voice use, raise
  `QWENPAW_MEMORY_LIMIT` and `QWENPAW_MEMORY_SWAP_LIMIT` together in small steps
  above the default, for example from `1536m` to `1792m`.
- If logs show `app (terminated by SIGKILL; not expected)` after the service has
  started, treat it as a container memory-limit kill first. For local Whisper,
  keep the default `1536m`; if the host still has free memory, raise in small
  steps such as `1792m`. Do not allow extra swap unless you accept slower
  failover instead of a fast container restart.
- If QwenPaw fails with a `supervisord` `minprocs` error, keep
  `QWENPAW_PIDS_LIMIT` and `QWENPAW_NPROC_LIMIT` above `200`. Lower values can
  prevent the container from starting.
- The image starts a headless desktop stack (`xvfb`, `xfce4`, and `dbus`).
  Avoid `cap_drop: ALL`; it can remove capabilities required by `dbus` and cause
  repeated `exited: dbus (exit status 1)` errors. This Compose file drops only
  `NET_RAW` as a safer compatibility baseline.
- If QwenPaw fails during startup, check whether the `/tmp` tmpfs limit or the
  PID limits are too restrictive for the current upstream image.
- The `latest` image tag is convenient but can change memory behavior without a
  Compose change. For production, pin a tested image tag or digest.
- Keep `QWENPAW_AUTH_ENABLED=true` when the service is exposed outside a private
  network such as Tailscale or a protected Coolify/Traefik route.

---

## ☕ Support & Donations

If this deployment tool saved you time or helped you build your AI assistant, consider supporting the development!

<a href="https://www.buymeacoffee.com/genildof"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

<a href="https://buymeacoffee.com/genildof"><img src="assets/bmc_qr.png" alt="Buy Me A Coffee QR code" width="180"></a>

---

## 🌟 Star the Repo

If you find this useful, please give it a **Star**! It helps the project grow and makes it easier for other developers to find this self-hosted AI solution.

---

## 📄 License

This project is licensed under the Apache-2.0 License - see the [LICENSE](LICENSE) file for details.

---

*Built for the AI Agent community. Powered by AgentScope and Coolify.*
