# Apple Silicon Power Efficiency Whitepaper

Wallep is engineered for near-zero battery drain on macOS Sonoma & Sequoia:
1. **VideoToolbox Hardware Decoders:** Video frames are decoded directly in the Apple Silicon Media Engine without CPU wakeup cycles.
2. **CAMetalLayer Zero-Copy:** Decoded CVPixelBuffers are directly textured onto the desktop plane without RAM copy overhead.
3. **IOKit Battery State Hook:** Automatically scales rendering framerate or halts decoding when running on battery power.
