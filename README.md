<div align="center">

# 🚀 Smart DNS Server

### ⚡ A Lightweight, Fast and Intelligent DNS Server
### powered by **Unbound + Smart Race Engine**

![Linux](https://img.shields.io/badge/Linux-Debian%20%7C%20Armbian-blue?logo=linux)
![Bash](https://img.shields.io/badge/Bash-100%25-green?logo=gnubash)
![DNS](https://img.shields.io/badge/DNS-Unbound-orange)
![License](https://img.shields.io/badge/License-Apache-red)
![Version](https://img.shields.io/badge/version-1.0.0--beta1-blueviolet)

Fast • Secure • Lightweight • Privacy First

</div>

---

# ⭐ Highlights

- ⚡ Intelligent DNS Race Engine
- 🔐 DNSSEC + DNS over TLS
- 🛡 Access Control & Rate Limiting
- 🚫 Multi-category DNS Blocking
- 📊 Live DNS Traffic Monitor
- 📈 Real-time Statistics
- 🪶 Extremely Lightweight
- ❤️ Privacy First
- 🚀 Optimized for Raspberry Pi & Orange Pi

---

# ✨ Features

- ⚡ Intelligent DNS Race Engine
- 🚀 Automatic Fastest Resolver Selection
- 🔒 DNSSEC Validation
- 🔐 DNS over TLS (DoT)
- 🌐 IPv4 And IPv6 Compatible
- 🛡 Access Control Lists (ACL)
- 🚦 DNS Rate Limiting
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

# 📸 Web-UI Panel

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
- IPv4 And IPv6 Resolver
- Better browsing experience

---

---

# 🔒 Security Features

Smart DNS Server includes multiple layers of protection beyond simple DNS forwarding.

### ✅ DNSSEC

Validates DNS responses cryptographically to prevent DNS spoofing and cache poisoning attacks.

---

### 🔐 DNS over TLS (DoT)

Encrypts communication between Smart DNS Server and upstream resolvers, protecting DNS traffic from eavesdropping and manipulation.

---

### 🛡 Access Control Lists (ACL)

Restricts which clients are allowed to use the DNS server.

Perfect for:

- Home Networks
- Office Networks
- Guest Isolation
- Private LANs

---

### 🚦 DNS Rate Limiting

Automatically limits excessive DNS requests from clients to mitigate:

- DNS Flooding
- Reflection Attacks
- Misconfigured Devices
- Malware Generated Queries

while maintaining normal browsing performance.

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
- [x] DNSSEC
- [x] DNS-over-TLS (DoT)
- [x] Access Control (ACL)
- [x] DNS Rate Limiting
- [ ] Web Dashboard
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

Made with ❤️ by Codex using Bash & Unbound & Smart Race Engine.

⭐ If you like this project, don't forget to Star it!

</div>