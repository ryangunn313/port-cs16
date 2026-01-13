# Counter-Strike 1.6 – ARM64 Port (R36S/K36)

**Counter-Strike 1.6 port package for ARM64 handhelds (R36S / K36 and similar)**,  
designed for use with **PortMaster**.

This package includes the launcher script(s), configuration, and packaging layout needed to run Counter-Strike 1.6 on ARM64 handhelds.  
You must provide your own legally-owned **`cstrike`** game data — this port always requires it.

For reduced SD card usage, the port can **optionally reuse the `valve` base folder** from the existing **Half-Life (Xash3D)** port.  
If the Half-Life port is not installed, you can instead include your own `valve` folder inside this package.  
**Counter-Strike does *not* depend on the Half-Life port being installed.**

> **Note:** This project does **not** include any commercial game assets.  
> You must supply your own legally-owned Counter-Strike 1.6 files.

---

## Features

- ✅ **ARM64 build support** — developed and tested on R36S/K36-class handhelds  
- ✅ **Flexible `valve` data support:**  
  - Can **optionally share** the `valve` folder from the Half-Life (Xash3D) port  
  - Or users may **provide their own `valve` folder** directly inside this package  
- ✅ **PortMaster-compatible structure** (`Counter-Strike.sh` + game directory)  
- ✅ **Requires only your own `cstrike` and `valve` folders** (no assets included)  
- ✅ **Bot support (YaPB):** functional and playable 
- 🚧 **Planned:** light quality-of-life configs (sensitivity, HUD scale, defaults)  

---

## Architecture & Scope

- ✅ **In development:** `arm64` (AArch64) – developed and tested on R36S/K36  
- 🚫 **Not provided:** `armhf` builds are not included and not planned at this time  
- ❌ **Not supported:** x86 / x86_64 – use desktop ports instead

The K36/R36S hardware *can* run armhf binaries, but this project currently ships
**ARM64-only** builds due to limited testing hardware and scope. Community
contributions are welcome if armhf support becomes desirable in the future.

---

## Legal

Counter-Strike 1.6 and Half-Life are © Valve Corporation.

This project:

- Does **not** distribute any proprietary game data  
- Only contains open-source code, scripts, configs, and build/packaging glue  
- Requires you to provide your own legally-obtained game files

If Valve (or any relevant rights holder) requests changes or removal, they will be respected.

---

## Credits

- **Valve** – for Half-Life and Counter-Strike  
- **Xash3D FWGS** – for the engine that makes these ports possible  
- **regamedll_cs** maintainers – for their great work on the CS game DLL  
- **PortMaster / handheld community** – for the tooling and inspiration  
- And everyone who tests, reports bugs, or contributes improvements ❤️
