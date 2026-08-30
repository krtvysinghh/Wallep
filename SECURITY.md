# Security Policy

Wallep takes application security, privacy, and user safety seriously. As a 100% native macOS application running directly on user hardware, we adhere to strict security best practices.

## Reporting a Vulnerability

If you discover a security vulnerability in Wallep, please **do NOT report it in public GitHub issues**.

Instead, please send an email to:
📧 **security@wallep.app** (or via private GitHub Security Advisory)

Include in your report:
1. Description of the vulnerability and attack vector.
2. Steps to reproduce or proof-of-concept (PoC).
3. Impact assessment (e.g. path traversal, memory corruption, privilege escalation).
4. Affected version(s) and macOS version.

## Security Architecture & Guarantees

* **Zero Network Telemetry:** Wallep does not collect, transmit, or monetize user data. All operations happen 100% locally.
* **Strict Path Jailing:** Custom video imports are sanitized to remove path traversal sequences (`../`, null bytes) and isolated inside `~/Library/Application Support/Wallep/`.
* **MIME & Extension Whitelist:** Strict whitelisting of approved video containers (`.mp4`, `.mov`, `.m4v`, `.webm`). Executables, shell scripts, and dynamic libraries are unconditionally rejected.
* **No Root / SIP Requirements:** Wallep operates completely in user space without requiring root privileges or System Integrity Protection (SIP) modifications.
* **Hardware-Bound Window Leveling:** Desktop canvas is anchored to `kCGDesktopWindowLevel` with mouse event pass-through, preventing click-jacking or UI spoofing.

## Video Integrity & Magic-Byte Validation
Every custom video imported via drag-and-drop or CLI is inspected via `MIMEValidator` for the ISO Base Media File Format box signature (`ftyp`). Files failing signature checks are rejected before reaching `AVFoundation`.
