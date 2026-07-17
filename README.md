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

The Compose file ships with conservative runtime limits so QwenPaw cannot starve
the Coolify host:

| Variable | Default | Description |
| --- | --- | --- |
| `QWENPAW_CPUS` | `1.50` | Maximum CPU cores available to the container |
| `QWENPAW_MEMORY_LIMIT` | `2g` | Container memory limit |
| `QWENPAW_MEMORY_SWAP_LIMIT` | `2g` | Total memory plus swap; keep equal to memory to avoid swap growth |
| `QWENPAW_PIDS_LIMIT` | `256` | Maximum processes/threads inside the container |
| `QWENPAW_LOG_MAX_SIZE` | `10m` | Maximum size for each container log file |
| `QWENPAW_LOG_MAX_FILE` | `3` | Number of rotated log files to keep |

If QwenPaw is killed by the OOM killer during heavy use, raise
`QWENPAW_MEMORY_LIMIT` and `QWENPAW_MEMORY_SWAP_LIMIT` together in Coolify. On
small VPS instances, keep swap equal to the memory limit and reduce
`QWENPAW_CPUS` before adding other workloads to the same server.

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
