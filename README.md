# 🌌 Wallep — Native & Open Source 4K Live Wallpapers for macOS

> **Wallep** (formerly Wallper) is an open-source, ultra-low resource 4K live wallpaper application designed natively for macOS (Sonoma, Sequoia & beyond). It turns 4K videos and loops into desktop wallpapers, lock screens, and screensavers without using WebViews, Electron, daemons, or SIP modifications.

---

## ⚡ Key Technical Design Principles

### 1. AppKit Desktop Window Leveling (No WebViews / Electron)
Instead of running heavy web engines or modifying system protected files, Wallep creates a native `NSWindow` pinned right at the Desktop level:
```swift
self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
self.collectionBehavior = [
    .canJoinAllSpaces,      // Stays visible across all Spaces
    .stationary,            // Remains anchored during Mission Control
    .ignoresCycle,          // Ignored by Cmd+Tab & window switching
    .fullScreenAuxiliary
]
self.ignoresMouseEvents = true // Mouse events pass straight to desktop files & icons
```

### 2. Hardware-Accelerated Video Engine (`AVPlayer` + `AVPlayerLayer`)
- Utilizes Apple Silicon hardware video decoding engines (HEVC/H.264/ProRes).
- Achieves **~0% idle CPU utilization** and minimal RAM overhead.
- Supports smooth crossfade transitions between wallpapers.

### 3. Aggressive Power Management (`IOKit` + `NSWorkspace`)
- **Battery Detection:** Monitors `IOPSCopyPowerSourcesInfo` / `IOPSGetPowerSourceDescription` to immediately pause playback or reduce frame rates on battery power.
- **Sleep & Wake Observers:** Subscribes to `NSWorkspace.willSleepNotification` and `NSWorkspace.didWakeNotification` for instant resource teardown.
- **Full-Screen Occlusion:** Automatically suspends rendering when full-screen apps or games are active.
- **Low Power Mode:** Detects `ProcessInfo.processInfo.isLowPowerModeEnabled`.

### 4. Multi-Display Topology
- Subscribes to `NSApplication.didChangeScreenParametersNotification`.
- Spawns independent or synchronized feeds per physical screen (`NSScreen.screens`).

---

## 📁 Repository Structure

```text
wallep/
├── Wallep-macOS/                 # Native Swift macOS Application & CLI
│   ├── Package.swift             # SwiftPM Package definition
│   └── Sources/Wallep/
│       ├── App/
│       │   ├── WallepApp.swift   # Main SwiftUI App entrypoint & MenuBarExtra
│       │   └── AppState.swift    # Global reactive state
│       ├── Core/
│       │   ├── WallpaperWindow.swift # AppKit window pinned to kCGDesktopWindowLevel
│       │   ├── PlayerEngine.swift    # Hardware-accelerated AVPlayerLooper
│       │   ├── WallpaperManager.swift# Multi-display coordinator
│       │   ├── PowerManager.swift    # IOKit battery & sleep monitor
│       │   └── LockScreenSync.swift  # macOS Lock screen frame synchronizer
│       ├── Storage/
│       │   ├── LibraryManager.swift  # 2700+ curated catalog & custom imports
│       │   └── WallpaperItem.swift   # Model & metadata definition
│       ├── Studio/
│       │   └── WallpaperStudio.swift # Live wallpaper editor & color grading
│       ├── UI/
│       │   ├── MenuBar/MenuBarView.swift # Native MenuBar popup controls
│       │   ├── Gallery/GalleryView.swift # Full desktop gallery with 4K cards
│       │   ├── Studio/StudioView.swift   # Live editor & video adjustment UI
│       │   ├── Settings/SettingsView.swift# Power, displays, and preferences
│       │   └── MainAppView.swift     # NavigationSplitView layout
│       └── CLI/
│           └── CLIHandler.swift      # Command line options (`wallep list`, `wallep set`)
│
└── wallep-web/                   # Web Platform, Landing Page & Interactive Simulator
    ├── package.json
    ├── tailwind.config.js
    └── src/
        ├── app/
        │   ├── page.tsx          # Landing page with interactive macOS simulation
        │   ├── pricing/page.tsx  # Full pricing comparison matrix table
        │   ├── wallpapers/page.tsx # Curated 4K wallpapers catalog
        │   └── studio/page.tsx   # Web live wallpaper studio preview
        └── components/
            ├── Header.tsx        # Rotating glowing beam navigation bar
            ├── Hero/             # Hero header & download actions
            ├── MacPreview/       # Simulated macOS Menubar, Dock & App Window
            └── Highlights/       # Interactive feature showcase
```

---

## 🚀 Building & Running

### 1. Build and Run the Native macOS App
```bash
cd Wallep-macOS
swift build

# Run CLI commands:
.build/arm64-apple-macosx/debug/wallep --help
.build/arm64-apple-macosx/debug/wallep list
.build/arm64-apple-macosx/debug/wallep status

# Launch full GUI App:
.build/arm64-apple-macosx/debug/wallep
```

### 2. Run the Web Platform & Interactive Simulator
```bash
cd wallep-web
npm install
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) to view the live website and simulated macOS desktop preview.

---

## 💎 Pricing & Features Matrix

| Feature | Free Trial ($0) | Pro ($14.99) | Pro+ ($24.99) | Enterprise ($59.00+) |
| :--- | :---: | :---: | :---: | :---: |
| **4K Wallpapers** (2700+) | ✅ All | ✅ All | ✅ All | ✅ All |
| **Studio Live Creator** | Trial | ✅ Included | ✅ Included | ✅ Included |
| **Custom Video Uploads** | ✅ Included | ✅ Included | ✅ Included | ✅ Included |
| **Covered Macs** | 1 Mac | 3 Macs | 5 Macs | Per Seat |
| **Lifetime Updates** | — | ✅ Included | ✅ Included | ✅ Included |
| **Cloud Sync** | — | — | ✅ Included | ✅ Included |
| **Creator Analytics** | — | — | ✅ Included | ✅ Included |
| **Featured Submissions** | — | — | ✅ Included | — |
| **Admin Console & MDM** | — | — | — | ✅ Included |
| **SAML / OIDC SSO** | — | — | — | ✅ Included |
| **Centralized Billing** | — | — | — | ✅ Included |
| **Support** | Email | Email | Priority | Contractual SLA |

---

## 📜 License
Licensed under the **MIT License**. Open source for the community.
