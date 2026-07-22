<div align="center">

# 🚀 Smart DNS Server

### ⚡ A Lightweight, Fast and Intelligent DNS Server
### powered by **Unbound + Smart Race Engine**

![Linux](https://img.shields.io/badge/Linux-Debian%20%7C%20Armbian-blue?logo=linux)
![Bash](https://img.shields.io/badge/Bash-100%25-green?logo=gnubash)
![DNS](https://img.shields.io/badge/DNS-Unbound-orange)
![License](https://img.shields.io/badge/License-MIT-red)
![Version](https://img.shields.io/badge/version-1.0.0--beta1-blueviolet)

Fast • Secure • Lightweight • Privacy First

</div>

---

# ✨ Features

- ⚡ Intelligent DNS Race Engine
- 🚀 Automatic Fastest Resolver Selection
- 🔒 DNSSEC Validation
- 🛡 Malware Blocking
- 🚫 Ads Blocking
- 🔞 Adult Content Blocking
- 📱 Social Network Blocking
- 🎯 Custom Blocklists
- 📊 Live DNS Monitor
- 📈 Statistics Dashboard
- 🔄 Automatic Rearm Timer
- ⚙️ Interactive Control Panel
- 🪶 Optimized for Low-RAM Devices
- 💾 Only Bash + Unbound
- ❤️ Zero Cloud Dependency

---

# 📸 Screenshots

> Coming Soon

---

# 🖥 Control Panel

```
==================================================
           Smart DNS Control Panel
==================================================

1) Live DNS Monitor

2) Block Manager

3) Config Manager

4) Rearm DNS

5) Statistics

6) Update

7) Uninstall

8) Exit
```

---

# 📂 Project Structure

```
Smart-DNS-Server
│
├── blocklists/
│   ├── ADS
│   ├── ADULTS
│   ├── MALWARE
│   ├── SOCIAL
│   └── CUSTOM
│
├── config/
│
├── lib/
│
├── scripts/install.d/
│
├── systemd/
│
├── panel.sh
├── install.sh
├── update.sh
├── uninstall.sh
└── rearm.sh
```

---

# 🚀 Installation

```bash
git clone https://github.com/AmirShams-ir/Smart-DNS-Server.git

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

# 🔧 Rearm DNS

```bash
sudo bash rearm.sh
```

or

```
Control Panel
↓

Rearm DNS
```

---

# 📊 Live DNS Monitor

Monitor every DNS query in real-time.

Example

```
TIME       CLIENT          TYPE    DOMAIN

21:14:07   192.168.1.4     A       google.com

21:14:08   192.168.1.7     AAAA    youtube.com

21:14:09   192.168.1.3     A       github.com
```

---

# 🚫 Block Categories

✔ Ads

✔ Malware

✔ Adult

✔ Social

✔ Custom

Each category can contain unlimited blocklists.

---

# ⚡ Smart Race Engine

Instead of forwarding every request to a single DNS server...

Smart DNS Server races multiple upstream resolvers simultaneously and automatically returns the fastest trusted response.

Benefits:

- Lower latency
- Better reliability
- Automatic failover
- Better browsing experience

---

# 💻 Suitable OS

- Debian 12 or 13
- Ubuntu 24 or 26
- Armbian (Orange Pi or Raspberry Pi)

---

# 🎯 Designed For

- Home Networks
- Raspberry Pi
- Orange Pi
- Thin Clients
- PCs, Mini PCs
- VPS, Dedicated Server
- Embedded Linux Devices

---

# ❤️ Philosophy

Smart DNS Server is designed around four principles:

- Privacy First
- Lightweight
- Stability
- Simplicity

No telemetry.

No cloud.

No tracking.

Only DNS.

---

# 🛣 Roadmap

- [x] Interactive Installer
- [x] Race Engine
- [x] Live DNS Monitor
- [x] Block Manager
- [x] Config Manager
- [x] Automatic Rearm
- [ ] DNS-over-TLS
- [ ] DNS-over-HTTPS
- [ ] REST API
- [ ] Web Dashboard
- [ ] Multi-language
- [ ] Docker Support
- [ ] OpenWRT Support

---

# 🤝 Contributions

Pull requests are welcome.

If you find bugs or have ideas,
feel free to open an Issue.

---

# 📜 License

Apache 2.0 License

---

<div align="center">

Made with ❤️ with ChatGPT using Bash & Unbound & Smart Race Engine.

⭐ If you like this project, don't forget to Star it!

</div>