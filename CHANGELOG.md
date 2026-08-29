# Changelog

All notable changes to Wallep will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-26
### Added
- Native AppKit desktop window leveling pinned to `kCGDesktopWindowLevel`.
- AVFoundation hardware video decoding (`AVPlayerLooper` / `AVPlayerLayer`) with Apple Silicon acceleration.
- Aggressive power management with `IOKit` AC power state detection and sleep/wake observers.
- Multi-display topology coordination across multiple monitors.
- 4,954 curated, handpicked 4K and 5K Retina live wallpapers across 7 aesthetic categories.
- Auto-Change rotation engine with customizable intervals (1m, 5m, 15m, 30m, 1h, 6h, 24h) and system wake triggers.
- Procedural generative high-resolution preview artwork renderer with `NSCache` memory pooling.
- Drag-and-drop video import engine with metadata extraction (resolution, duration, FPS, codecs).
- Standalone command-line interface (`wallep list`, `wallep set`, `wallep status`, `wallep pause`, `wallep resume`).
- Companion Next.js web application with interactive macOS desktop simulation.
