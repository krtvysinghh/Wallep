# Contributing to Wallep

Thank you for your interest in contributing to Wallep! Wallep is a 100% Free & Open Source native macOS 4K live-wallpaper engine built with Swift, AppKit, and AVFoundation.

## Development Setup

### Prerequisites
- macOS 14.6 (Sonoma) or macOS 15.0+ (Sequoia)
- Xcode 15+ or Swift 6.0+ Command Line Tools
- Node.js 20+ (for companion web platform)

### Building the Native macOS Client
```bash
cd Wallep-macOS
swift build -c release
```

### Running Test Suite
```bash
cd Wallep-macOS
swift run wallep-tests
```

### Building Web Simulator
```bash
cd wallep-web
npm install
npm run build
```

## Pull Request Guidelines
1. Create a feature branch (`git checkout -b feat/your-feature`).
2. Follow Swift API design guidelines.
3. Ensure all tests pass before submitting (`swift run wallep-tests`).
4. Keep commits atomic with conventional commit messages (`feat:`, `fix:`, `perf:`, `security:`, `docs:`).
5. Open a Pull Request with a clear description and testing notes.

## Code Style
- Use standard Swift formatting (2-space / 4-space indentation).
- Mark non-subclassable types as `final`.
- Always verify memory lifecycle (`[weak self]` in closures, invalidate Timers).
