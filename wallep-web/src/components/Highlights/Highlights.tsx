"use client";

import { useState } from "react";
import { Lock, Cpu, MonitorPlay, Wand2, CheckCircle2 } from "lucide-react";

const HIGHLIGHTS = [
  {
    id: "lockscreen",
    label: "Lock Screen",
    title: "Native macOS Lock Screen & Screensaver",
    desc: "Wallper hands playback directly to Apple's native pipeline — no daemons, no overlays, and no workarounds. Smooth video loops continue effortlessly when locking your Mac.",
    icon: Lock,
    details: ["Native macOS 14.6+ API", "Fluid wake-from-sleep transition", "Zero background battery drain"],
    previewGradient: "from-blue-600/30 to-indigo-900/40"
  },
  {
    id: "silicon",
    label: "Compatibility",
    title: "Engineered for Apple Silicon & Intel",
    desc: "Runs with hyper-optimized efficiency on Intel and every Apple Silicon family from M1 to M4 Pro/Max. Hardware HEVC/H.264 video decoding bypasses CPU entirely.",
    icon: Cpu,
    details: ["Apple Silicon Video Decoder Engine", "Universal 64-bit Binary", "Low Power Mode Integration"],
    previewGradient: "from-purple-600/30 to-pink-900/40"
  },
  {
    id: "multidisplay",
    label: "Multi-Display",
    title: "Multi-Monitor Synchronization",
    desc: "Coordinate distinct 4K feeds across Studio Displays, Pro Display XDRs, and external 4K/5K monitors without dropping a single frame.",
    icon: MonitorPlay,
    details: ["Independent display assignment", "Panoramic ultra-wide spanning", "Hot-plug auto-discovery"],
    previewGradient: "from-emerald-600/30 to-teal-900/40"
  },
  {
    id: "studio",
    label: "Creator Studio",
    title: "Make & Grade Your Own Live Wallpapers",
    desc: "Bring your own .mp4, .mov, or .webm clips into the built-in Studio. Apply color grading, audio tracks, and export optimized looping packages.",
    icon: Wand2,
    details: ["Real-time saturation & speed control", "Ambient audio sync", "Community gallery export"],
    previewGradient: "from-amber-600/30 to-rose-900/40"
  }
];

export default function Highlights() {
  const [activeTab, setActiveTab] = useState(0);
  const current = HIGHLIGHTS[activeTab];

  return (
    <section className="py-24 px-6 max-w-6xl mx-auto">
      <div className="text-center max-w-3xl mx-auto mb-16">
        <h2 className="text-3xl sm:text-5xl font-bold tracking-tight text-white mb-4">
          Install, scale, <br />
          <span className="text-indigo-400">and command.</span>
        </h2>
        <p className="text-white/60 text-sm sm:text-base">
          Built from the ground up with native AppKit, AVFoundation, and IOKit power awareness.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
        {/* Left: Tab Selectors */}
        <div className="lg:col-span-5 flex flex-col gap-3">
          {HIGHLIGHTS.map((item, idx) => {
            const Icon = item.icon;
            const isActive = idx === activeTab;
            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(idx)}
                className={`text-left p-5 rounded-2xl border transition-all ${
                  isActive
                    ? "bg-white/[0.06] border-indigo-500/50 shadow-xl shadow-indigo-500/10"
                    : "bg-white/[0.02] border-white/[0.06] hover:bg-white/[0.04] opacity-70 hover:opacity-100"
                }`}
              >
                <div className="flex items-center gap-3 mb-2">
                  <div className={`p-2 rounded-lg ${isActive ? "bg-indigo-600 text-white" : "bg-white/10 text-white/70"}`}>
                    <Icon className="w-4 h-4" />
                  </div>
                  <span className="font-semibold text-white text-base">{item.label}</span>
                </div>
                <p className="text-xs text-white/60 line-clamp-2 leading-relaxed">
                  {item.desc}
                </p>
              </button>
            );
          })}
        </div>

        {/* Right: Feature Showcase Stage */}
        <div className="lg:col-span-7">
          <div className={`rounded-2xl p-8 border border-white/10 bg-gradient-to-br ${current.previewGradient} backdrop-blur-xl relative overflow-hidden min-h-[380px] flex flex-col justify-between shadow-2xl transition-all duration-500`}>
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 border border-white/20 text-xs font-semibold text-white mb-6">
                <span>{current.label} Feature</span>
              </div>

              <h3 className="text-2xl sm:text-3xl font-bold text-white mb-4">
                {current.title}
              </h3>

              <p className="text-white/80 text-sm leading-relaxed mb-8 max-w-xl">
                {current.desc}
              </p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 pt-6 border-t border-white/10">
              {current.details.map((detail, dIdx) => (
                <div key={dIdx} className="flex items-center gap-2 text-xs text-white/90 font-medium">
                  <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
                  <span>{detail}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
