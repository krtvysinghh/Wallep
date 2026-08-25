"use client";

import { useState } from "react";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { Wand2, UploadCloud, Sliders, Play, Film, Download, CheckCircle2 } from "lucide-react";

export default function StudioWebPage() {
  const [brightness, setBrightness] = useState(0);
  const [contrast, setContrast] = useState(1);
  const [saturation, setSaturation] = useState(1);
  const [speed, setSpeed] = useState(1);
  const [title, setTitle] = useState("My Ambient Live Wallpaper");

  return (
    <div className="min-h-screen bg-[#090a0f] text-white selection:bg-indigo-500 selection:text-white">
      <Header />

      <main className="pt-32 pb-24 px-6 max-w-7xl mx-auto">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-purple-500/10 border border-purple-500/30 text-purple-300 text-xs font-semibold mb-4">
            <Wand2 className="w-3.5 h-3.5" />
            <span>Wallep Studio Engine</span>
          </div>
          <h1 className="text-4xl sm:text-6xl font-bold tracking-tight text-white mb-4">
            Create Your Own Live Wallpapers
          </h1>
          <p className="text-white/60 text-sm sm:text-base leading-relaxed">
            Turn custom video files into hardware-accelerated 4K loops with color grading and seamless Mac integration.
          </p>
        </div>

        {/* Interactive Studio Workspace */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 max-w-6xl mx-auto rounded-2xl bg-white/[0.02] border border-white/[0.08] p-6 lg:p-8 backdrop-blur-xl shadow-2xl">
          {/* Left Canvas Preview */}
          <div className="lg:col-span-8 flex flex-col gap-4">
            <div className="relative aspect-video rounded-xl bg-black overflow-hidden border border-white/10 flex items-center justify-center group shadow-2xl">
              <div
                className="w-full h-full bg-gradient-to-tr from-indigo-950 via-purple-950 to-pink-950 flex flex-col items-center justify-center transition-all duration-300 relative"
                style={{
                  filter: `brightness(${1 + brightness}) contrast(${contrast}) saturate(${saturation})`
                }}
              >
                <div className="w-16 h-16 rounded-full bg-white/10 backdrop-blur-md border border-white/20 flex items-center justify-center text-white mb-3 group-hover:scale-110 transition-transform">
                  <Play className="w-7 h-7 fill-current translate-x-0.5" />
                </div>
                <h3 className="text-lg font-bold text-white mb-1">{title}</h3>
                <span className="text-xs text-white/60 font-mono">4K UHD • {speed}x Playback</span>
              </div>
            </div>

            <div className="p-4 rounded-xl bg-white/[0.02] border border-white/[0.06] flex items-center justify-between text-xs text-white/60">
              <div className="flex items-center gap-2">
                <Film className="w-4 h-4 text-indigo-400" />
                <span>Format: Native .mp4 / .mov / .webm</span>
              </div>
              <div className="flex items-center gap-2 text-emerald-400">
                <CheckCircle2 className="w-3.5 h-3.5" />
                <span>Hardware Acceleration Ready</span>
              </div>
            </div>
          </div>

          {/* Right Inspector & Controls */}
          <div className="lg:col-span-4 flex flex-col justify-between gap-6">
            <div className="space-y-6">
              <div>
                <label className="block text-xs font-bold text-white/70 uppercase tracking-wider mb-2">
                  Wallpaper Title
                </label>
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded-xl bg-white/[0.04] border border-white/[0.08] text-xs text-white focus:outline-none focus:border-indigo-500 transition-colors"
                />
              </div>

              {/* Adjustments */}
              <div className="space-y-4 pt-4 border-t border-white/[0.08]">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-white/70 uppercase tracking-wider">Color & Speed</span>
                  <Sliders className="w-3.5 h-3.5 text-white/40" />
                </div>

                <div>
                  <div className="flex justify-between text-xs text-white/60 mb-1.5">
                    <span>Brightness</span>
                    <span>{brightness.toFixed(2)}</span>
                  </div>
                  <input
                    type="range"
                    min="-0.5"
                    max="0.5"
                    step="0.05"
                    value={brightness}
                    onChange={(e) => setBrightness(parseFloat(e.target.value))}
                    className="w-full accent-indigo-500 h-1 bg-white/10 rounded-lg cursor-pointer"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs text-white/60 mb-1.5">
                    <span>Contrast</span>
                    <span>{contrast.toFixed(2)}</span>
                  </div>
                  <input
                    type="range"
                    min="0.5"
                    max="1.8"
                    step="0.05"
                    value={contrast}
                    onChange={(e) => setContrast(parseFloat(e.target.value))}
                    className="w-full accent-indigo-500 h-1 bg-white/10 rounded-lg cursor-pointer"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs text-white/60 mb-1.5">
                    <span>Saturation</span>
                    <span>{saturation.toFixed(2)}</span>
                  </div>
                  <input
                    type="range"
                    min="0.2"
                    max="2.0"
                    step="0.05"
                    value={saturation}
                    onChange={(e) => setSaturation(parseFloat(e.target.value))}
                    className="w-full accent-indigo-500 h-1 bg-white/10 rounded-lg cursor-pointer"
                  />
                </div>

                <div>
                  <div className="flex justify-between text-xs text-white/60 mb-1.5">
                    <span>Speed</span>
                    <span>{speed.toFixed(2)}x</span>
                  </div>
                  <input
                    type="range"
                    min="0.5"
                    max="2.0"
                    step="0.25"
                    value={speed}
                    onChange={(e) => setSpeed(parseFloat(e.target.value))}
                    className="w-full accent-indigo-500 h-1 bg-white/10 rounded-lg cursor-pointer"
                  />
                </div>
              </div>
            </div>

            <div>
              <a
                href="https://github.com/alxndlk/wallper-app/releases"
                className="w-full py-3.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold flex items-center justify-center gap-2 shadow-lg shadow-indigo-600/30 transition-all active:scale-95"
              >
                <Download className="w-4 h-4" />
                <span>Open Studio in Native macOS App</span>
              </a>
              <span className="block text-center text-[10px] text-white/40 mt-2">
                Available in Wallep Pro & Free Trial
              </span>
            </div>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
