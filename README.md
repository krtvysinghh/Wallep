# Wallep

An ultra-efficient, native macOS live-wallpaper engine and 4K animated background manager built in Swift, AppKit, and AVFoundation. Wallep renders hardware-accelerated video loops directly behind the desktop icon plane with zero reliance on WebViews, Electron wrappers, persistent root daemons, or SIP modifications.

[![macOS 14.6+](https://img.shields.io/badge/macOS-14.6%2B-black?logo=apple&style=flat-square)](https://apple.com)
[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white&style=flat-square)](https://swift.org)
[![Apple Silicon Native](https://img.shields.io/badge/Architecture-ARM64%20%7C%20x86__64-blue?style=flat-square)](https://apple.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-emerald?style=flat-square)](LICENSE)

---

## Technical Overview

### 1. Window Level Layering & Spaces Behavior
Traditional live-wallpaper implementations on macOS suffer from window-order conflicts, space-switching glitches, or high CPU consumption. Wallep bypasses these limitations by instantiating an unadorned, borderless `NSWindow` pinned strictly beneath the desktop icon layer:

```swift
// Core window level assignment
self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))

// Persistence across Mission Control & virtual spaces
self.collectionBehavior = [
    .canJoinAllSpaces,      // Persistent across all virtual desktops
    .stationary,            // Unaffected by Mission Control / Exposé gestures
    .ignoresCycle,          // Excluded from Cmd+Tab and window cycling
    .fullScreenAuxiliary    // Retains background rendering alongside split/fullscreen apps
]

self.ignoresMouseEvents = true // Direct click-through to desktop files and Finder items
```

### 2. Hardware-Accelerated Playback Engine
Playback is powered by `AVFoundation` (`AVQueuePlayer` and `AVPlayerLooper`), binding output frames to an `AVPlayerLayer` configured with `.resizeAspectFill`. 

* **Hardware Decoding:** Offloads H.264, HEVC (H.265), and ProRes decoding directly to Apple Silicon Video Decoder engines and Intel QuickSync pipelines.
* **CPU Footprint:** ~0% idle CPU utilization during active desktop rendering.
* **Transition Pipeline:** Seamless CATransaction-driven crossfades during wallpaper swaps.

### 3. Aggressive Power Management
Wallep actively monitors system power rails to prevent battery drain:

* **Battery Detection:** Hooks into `IOKit.ps` via `IOPSNotificationCreateRunLoopSource` to detect AC adapter disconnect events in real-time. Automatically suspends rendering when operating on battery power (configurable).
* **Thermal & Low-Power State:** Listens to `NSNotification.Name.NSProcessInfoPowerStateDidChange` to adapt rendering targets when macOS enters Low Power Mode.
* **Sleep / Wake Lifecycle:** Binds to `NSWorkspace.willSleepNotification` and `NSWorkspace.didWakeNotification` for instant resource teardown and frame-accurate playback resumption.
* **Fullscreen Occlusion:** Detects frontmost full-screen application windows via `CGWindowListCopyWindowInfo` to pause wallpaper rendering when occluded by games or productivity software.

### 4. Multi-Display Topology
* Listens to `NSApplication.didChangeScreenParametersNotification`.
* Dynamically provisions and binds dedicated `WallpaperWindow` and `PlayerEngine` instances per connected display (`NSScreen.screens`).
* Supports independent multi-screen feeds and synchronized panoramic setups without frame drops.

---

## Codebase Architecture

```text
wallep/
├── Wallep.app/                       # Pre-built macOS App Bundle
├── Wallep.dmg                        # Drag-and-drop installer image
├── AppIcon.icns                      # High-resolution Apple squircle icon
│
├── Wallep-macOS/                     # Native Swift Package (Engine, GUI, CLI)
│   ├── Package.swift                 # SwiftPM Package definition
│   └── Sources/Wallep/
│       ├── App/
│       │   ├── WallepApp.swift       # Application entrypoint & MenuBarExtra controller
│       │   └── AppState.swift        # Central reactive state coordination
│       ├── Core/
│       │   ├── WallpaperWindow.swift # Desktop-pinned AppKit window layer
│       │   ├── PlayerEngine.swift    # AVFoundation decoding & looper controller
│       │   ├── WallpaperManager.swift# Display feed synchronization & management
│       │   ├── PowerManager.swift    # IOKit battery & sleep-state observer
│       │   └── LockScreenSync.swift  # Lock screen snapshot & sync service
│       ├── Storage/
│       │   ├── LibraryManager.swift  # Local media library & import management
│       │   └── WallpaperItem.swift   # Wallpaper model definitions
│       ├── Studio/
│       │   └── WallpaperStudio.swift # Ingest, color-grading & loop exporter
│       ├── UI/
│       │   ├── MenuBar/MenuBarView.swift # Status bar quick-control popup
│       │   ├── Gallery/GalleryView.swift # Native 4K catalog browser
│       │   ├── Studio/StudioView.swift   # Creator workspace & filter adjustments
│       │   ├── Settings/SettingsView.swift # Preferences & power configurations
│       │   └── MainAppView.swift     # SplitView desktop interface
│       └── CLI/
│           └── CLIHandler.swift      # Command-line interface logic
│
└── wallep-web/                       # Companion Web Platform & Simulator
    ├── src/
    │   ├── app/
    │   │   ├── page.tsx              # Landing page with interactive macOS simulation
    │   │   ├── wallpapers/page.tsx   # Curated online 4K gallery
    │   │   └── studio/page.tsx       # Web live wallpaper studio preview
    │   └── components/
    │       ├── Header.tsx            # Navigation bar with dynamic beam styling
    │       ├── Hero/                 # Hero section & download CTA
    │       ├── MacPreview/           # Interactive macOS desktop simulator
    │       └── Highlights/           # Technical feature showcase
    └── package.json
```

---

## Installation & Usage

### Method 1: Disk Image (.dmg)
1. Download `Wallep.dmg` from the repository or releases.
2. Open `Wallep.dmg` and drag `Wallep.app` into your `/Applications` directory.
3. Launch **Wallep**. The app runs quietly in your MenuBar.

### Method 2: Building from Source
Requirements: macOS 14.6+, Xcode 15+ or Swift 6.0+ Command Line Tools.

```bash
# Clone the repository
git clone https://github.com/krtvysinghh/wallep.git
cd wallep/Wallep-macOS

# Build for release
swift build -c release

# Run the compiled binary
.build/release/wallep
```

### Method 3: Automated Bundle Packaging
To compile the universal/arm64 release binary, generate the signed `.app` bundle, and package the `.dmg` installer in one step:

```bash
chmod +x create_app_and_dmg.sh
./create_app_and_dmg.sh
```

---

## CLI Interface

Wallep includes a lightweight command-line interface for terminal workflows and automation scripts:

```bash
# Show usage and options
wallep --help

# List available live wallpapers in local library
wallep list

# Set wallpaper by ID or file path
wallep set sample_01
wallep set /path/to/custom_video.mp4

# Control playback state
wallep pause
wallep resume

# Inspect active displays and battery management status
wallep status
```

---

## Security & Storage Model

* **Sandboxed Path Validation:** Custom video imports are strictly checked against an approved format whitelist (`mp4`, `mov`, `m4v`, `webm`). Filenames are normalized with UUID prefixes to prevent directory traversal (`../`).
* **Local Storage:** Downloaded catalog assets and custom imports are stored exclusively in `~/Library/Application Support/Wallep/`.
* **Zero Telemetry:** Wallep operates 100% locally on your machine. No accounts, analytics trackers, or external telemetry pings.

---

## Web Platform

The repository includes a companion web platform built with Next.js 14 and Tailwind CSS, featuring an interactive desktop simulator:

```bash
cd wallep-web
npm install
npm run dev
```

Visit `http://localhost:3000` to preview the curated library, online studio simulator, and responsive interactive macOS environment.

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
