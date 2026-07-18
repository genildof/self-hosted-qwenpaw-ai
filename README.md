<div align="center">
  <img
    src="https://gw.alicdn.com/imgextra/i1/O1CN01sens5C1TuwioeGexL_!!6000000002443-55-tps-771-132.svg"
    alt="QwenPaw logo"
    width="360"
  />

  <h1>Self-Hosted QwenPaw AI</h1>

  <p>
    Coolify-ready QwenPaw deployment with persistent storage, operational
    defaults, and conservative limits for small Linux servers.
  </p>

  <p>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT License" /></a>
    <a href="https://hub.docker.com/r/agentscope/qwenpaw">
      <img src="https://img.shields.io/badge/docker-agentscope%2Fqwenpaw-blue" alt="QwenPaw Docker image" />
    </a>
    <a href="https://coolify.io"><img src="https://img.shields.io/badge/Coolify-ready-green" alt="Coolify ready" /></a>
    <a href="https://github.com/agentscope-ai/QwenPaw">
      <img src="https://img.shields.io/badge/powered%20by-QwenPaw-orange" alt="Powered by QwenPaw" />
    </a>
  </p>

  <p>
    <a href="#quick-start">Quick Start</a> •
    <a href="#deployment-profile">Deployment Profile</a> •
    <a href="#resource-profile">Resource Profile</a> •
    <a href="#persistence">Persistence</a> •
    <a href="#credits">Credits</a>
  </p>
</div>

---

## Overview

This repository packages the official
[QwenPaw](https://github.com/agentscope-ai/QwenPaw) container for self-hosting
on a small Ubuntu server through Docker and Coolify.

It is tuned for small Linux servers where the configuration must prioritize host
stability over maximum QwenPaw throughput.

<div align="center">
  <img
    src="https://img.alicdn.com/imgextra/i2/O1CN01EP1ra01iOAcBvF0TC_!!6000000004402-2-tps-3822-2070.png"
    alt="QwenPaw console screenshot"
    width="760"
  />
</div>

## What This Deployment Includes

- Official QwenPaw Docker image used directly by Docker Compose.
- Persistent QwenPaw data, secrets, backups, temporary files, and runtime cache.
- Docker resource limits for low-memory servers.
- Log rotation to prevent Docker JSON logs from growing without bound.
- Container settings compatible with QwenPaw's desktop/headless runtime stack.

## Quick Start

1. Create a new resource in Coolify.
2. Select public repository and use this repository URL.
3. Choose the included `docker-compose.yaml` deployment.
4. Set the application port to `8088`.
5. Deploy.
6. Open the QwenPaw console and configure your LLM provider and channels.

Recommended authentication variables:

| Variable | Default | Notes |
| --- | --- | --- |
| `QWENPAW_AUTH_ENABLED` | `false` | Set to `true` if the console is exposed outside a trusted private network. |
| `QWENPAW_AUTH_USERNAME` | `admin` | Console login username. |
| `QWENPAW_AUTH_PASSWORD` | empty | Required when authentication is enabled. |

## Deployment Profile

The default Compose profile runs the official QwenPaw image directly and keeps
runtime settings focused on a stable, lightweight deployment.

This makes the repository a clean baseline for:

- private QwenPaw workspaces;
- persistent agent memory and configuration;
- Coolify-managed networking and redeploys;
- controlled CPU, memory, process, and log usage.

Additional QwenPaw capabilities can be configured in the QwenPaw console or by
building a custom image when a deployment needs extra Python packages.

## Resource Profile

The default profile targets an Ubuntu server with an Intel Core i5, 4 GB RAM,
Docker, Coolify, and several existing services.

Current defaults:

- CPU limit: `1.00`
- Memory hard limit: `1300m`
- Memory plus swap: `1300m`
- Memory reservation: `1g`
- Swappiness: `0`
- PID/process limit: `256`
- `/tmp` tmpfs: `64m`
- Docker logs: `5m` x `2` files
- Linux capability hardening: drop `NET_RAW`

The memory and swap limits are intentionally equal. This prevents QwenPaw from
using unbounded swap and helps avoid host-wide swap thrashing.

### Runtime Variables

Configure these in Coolify only when you need to override the defaults:

| Variable | Default |
| --- | --- |
| `QWENPAW_CPUS` | `1.00` |
| `QWENPAW_MEMORY_LIMIT` | `1300m` |
| `QWENPAW_MEMORY_SWAP_LIMIT` | `1300m` |
| `QWENPAW_MEMORY_RESERVATION` | `1g` |
| `QWENPAW_MEMORY_SWAPPINESS` | `0` |
| `QWENPAW_PIDS_LIMIT` | `256` |
| `QWENPAW_NPROC_LIMIT` | `256` |
| `QWENPAW_NOFILE_SOFT_LIMIT` | `2048` |
| `QWENPAW_NOFILE_HARD_LIMIT` | `4096` |
| `QWENPAW_TMPFS_SIZE` | `64m` |
| `QWENPAW_LOG_MAX_SIZE` | `5m` |
| `QWENPAW_LOG_MAX_FILE` | `2` |

## Persistence

The Compose file uses named Docker volumes:

| Volume | Container path | Purpose |
| --- | --- | --- |
| `qwenpaw-data` | `/app/working` | Main config, workspaces, memory, temp files, and caches. |
| `qwenpaw-secrets` | `/app/working.secret` | Secret material and provider credentials. |
| `qwenpaw-backups` | `/app/working.backups` | Backup archives. |

QwenPaw logs show that configuration is saved under:

```text
/app/working/config.json
```

Because `/app/working` is persisted, normal Coolify redeploys should keep the
QwenPaw console settings, workspaces, memory, and runtime cache.
Do not delete or recreate the named volumes unless you intend to reset the
instance.

## Operational Notes

- Keep `QWENPAW_MEMORY_SWAP_LIMIT` equal to `QWENPAW_MEMORY_LIMIT` to avoid
  uncontrolled swap usage.
- Keep `QWENPAW_PIDS_LIMIT` and `QWENPAW_NPROC_LIMIT` above `200`, which leaves
  enough process headroom for QwenPaw's runtime services.
- Use the QwenPaw console for provider, channel, workspace, and agent settings.
  Those settings are persisted under the `qwenpaw-data` volume.
- Keep the named Docker volumes when redeploying through Coolify. Recreating the
  volumes resets the instance.
- Pin the upstream QwenPaw image tag or digest if you need fully reproducible
  production deployments.

## Credits

This repository is a deployment wrapper maintained by Genildo Ferreira.

QwenPaw, its official Docker image, documentation, screenshots, and visual
identity belong to the
[agentscope-ai/QwenPaw](https://github.com/agentscope-ai/QwenPaw) project and
its contributors. QwenPaw is licensed by its upstream project under
Apache-2.0.

This wrapper repository is licensed under the MIT License.

---

## Support & Donations

<div align="center">
  <p>If this deployment wrapper is useful to you, consider supporting the maintainer.</p>

  <p>
    <a href="https://www.buymeacoffee.com/genildof">
      <img
        src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png"
        alt="Buy Me A Coffee"
        style="height: 60px !important; width: 217px !important;"
      />
    </a>
  </p>

  <p>
    <a href="https://buymeacoffee.com/genildof">
      <img
        src="assets/bmc_qr.png"
        alt="Buy Me A Coffee QR code"
        width="180"
      />
    </a>
  </p>
</div>

---

## License

[MIT](LICENSE)
