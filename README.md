<p align="center">
<img src="https://raw.githubusercontent.com/YOUR_USERNAME/Smart-DNS-Server/main/assets/banner.png" width="100%">
</p>

<h1 align="center">
🚀 Smart DNS Server
</h1>

<p align="center">

A Lightweight • Intelligent • Privacy-First DNS Server

Powered by <b>Unbound + Smart Race Engine</b>

</p>

<p align="center">

<img src="https://img.shields.io/github/license/YOUR_USERNAME/Smart-DNS-Server?style=for-the-badge">

<img src="https://img.shields.io/github/stars/YOUR_USERNAME/Smart-DNS-Server?style=for-the-badge">

<img src="https://img.shields.io/github/forks/YOUR_USERNAME/Smart-DNS-Server?style=for-the-badge">

<img src="https://img.shields.io/github/issues/YOUR_USERNAME/Smart-DNS-Server?style=for-the-badge">

<img src="https://img.shields.io/github/repo-size/YOUR_USERNAME/Smart-DNS-Server?style=for-the-badge">

</p>

<p align="center">

<img src="https://img.shields.io/badge/Linux-Debian%20%7C%20Armbian-blue?logo=linux">

<img src="https://img.shields.io/badge/Bash-100%25-success?logo=gnubash">

<img src="https://img.shields.io/badge/DNS-Unbound-orange">

<img src="https://img.shields.io/badge/IPv6-Ready-green">

<img src="https://img.shields.io/badge/Privacy-First-red">

</p>

---

# ✨ Why Smart DNS Server?

Unlike traditional DNS forwarders, Smart DNS Server continuously measures multiple upstream DNS providers and automatically chooses the fastest trusted response.

No cloud.

No telemetry.

No heavy software.

Just fast DNS.

---

# 🎯 Features

## 🚀 Performance

- Smart Race Engine
- Automatic Fastest Resolver Selection
- DNS Cache
- IPv4 & IPv6
- Ultra Lightweight
- Optimized for SBCs

---

## 🔒 Security

- DNSSEC Validation
- Malware Blocking
- Phishing Protection
- Tracking Protection
- Privacy First
- Local Resolution

---

## 🚫 Content Filtering

- Ads
- Adult
- Social Networks
- Malware
- Custom Lists

Unlimited Blocklists

---

## 🛠 Management

- Interactive Control Panel
- Block Manager
- Config Manager
- Live DNS Monitor
- Automatic Rearm
- Systemd Integration

---

# 🖥 Dashboard

```
==================================================

          Smart DNS Control Panel

==================================================

1) Live DNS Monitor

2) Block Manager

3) Config Manager

4) Rearm DNS

5) Statistics

6) System Information

7) Update

8) Exit

==================================================
```

---

# 📡 Architecture

```text

                Internet

                     │

     ┌───────────────────────────┐
     │ Upstream DNS Servers      │
     │                           │
     │ Cloudflare                │
     │ Google                    │
     │ Quad9                     │
     │ OpenDNS                   │
     │ AdGuard                   │
     └─────────────┬─────────────┘
                   │

          Smart Race Engine

                   │

             Unbound Cache

                   │

          Blocklist Engine

                   │

      Smart DNS Server (Orange Pi)

                   │

        Home Network Clients

```

---

# 📂 Project Layout

```
Smart-DNS-Server

├── assets/

├── blocklists/

│   ├── ADS

│   ├── ADULTS

│   ├── MALWARE

│   ├── SOCIAL

│   └── CUSTOM

│

├── config/

├── lib/

├── scripts/

├── systemd/

│

├── install.sh

├── update.sh

├── uninstall.sh

├── rearm.sh

├── panel.sh

└── README.md
```

---

# 🚀 Installation

```bash
git clone https://github.com/YOUR_USERNAME/Smart-DNS-Server.git

cd Smart-DNS-Server

sudo bash install.sh
```

---

# 🔄 Update

```bash
sudo bash update.sh
```

---

# ❌ Uninstall

```bash
sudo bash uninstall.sh
```

---

# ⚡ Rearm

```bash
sudo bash rearm.sh
```

---

# 📊 Live DNS Monitor

```
TIME       CLIENT           TYPE   DOMAIN

23:41:10   192.168.1.4      A      google.com

23:41:11   192.168.1.7      AAAA   github.com

23:41:12   192.168.1.3      HTTPS  youtube.com
```

---

# 🚫 Block Categories

✔ Ads

✔ Adult

✔ Malware

✔ Social

✔ Custom

Every category supports unlimited TXT files.

---

# 💡 Designed For

✅ Raspberry Pi

✅ Orange Pi

✅ Thin Clients

✅ Mini PCs

✅ Home Routers

✅ VPS

✅ Embedded Linux

---

# 📈 Performance Goals

| Feature | Smart DNS |
|---------|-----------|
| RAM Usage | ⭐ Very Low |
| CPU Usage | ⭐ Very Low |
| DNSSEC | ✅ |
| IPv6 | ✅ |
| Race Engine | ✅ |
| Automatic Failover | ✅ |
| Live Monitor | ✅ |
| Blocklists | Unlimited |

---

# 🛣 Roadmap

- [x] Interactive Installer

- [x] Live DNS Monitor

- [x] Race Engine

- [x] Block Manager

- [x] Config Manager

- [x] Statistics

- [x] Rearm Service

- [ ] DNS-over-TLS

- [ ] DNS-over-HTTPS

- [ ] DNSCrypt

- [ ] REST API

- [ ] Web Dashboard

- [ ] Docker

- [ ] OpenWRT

- [ ] High Availability

---

# ❤️ Philosophy

Smart DNS Server follows one simple idea:

> **Fast DNS should be simple, private and lightweight.**

No databases.

No JavaScript.

No Docker required.

No telemetry.

Only Bash.

Only Unbound.

Only DNS.

---

# 🤝 Contributing

Contributions are welcome.

Open an Issue

Fork the repository

Submit a Pull Request

---

# ⭐ Support

If you like this project,

please consider giving it a ⭐ on GitHub.

It really helps.

---

# 📜 License

Apache 2 License

---

<p align="center">

Made with ❤️ using Bash with ChatGPT

Powered by Unbound and Race

</p>