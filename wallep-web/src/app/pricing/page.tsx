"use client";

import { Check, Sparkles, Heart, Apple, Github, Code, ShieldCheck } from "lucide-react";
import Header from "@/components/Header";
import Footer from "@/components/Footer";

export default function FreeManifestoPage() {
  return (
    <div className="min-h-screen bg-[#090a0f] text-white selection:bg-indigo-500 selection:text-white">
      <Header />

      <main className="pt-32 pb-24 px-6 max-w-7xl mx-auto">
        {/* Header Title */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-300 text-xs font-semibold mb-4">
            <Heart className="w-3.5 h-3.5 fill-current" />
            <span>100% Free & Open Source Forever</span>
          </div>
          <h1 className="text-4xl sm:text-6xl font-bold tracking-tight text-white mb-4">
            No Paywalls. <span className="text-emerald-400">Everything Free.</span>
          </h1>
          <p className="text-white/60 text-sm sm:text-base max-w-xl mx-auto leading-relaxed">
            Wallep is completely open-source. All 2,700+ 4K wallpapers, the Studio creator, unlimited custom video imports, multi-display support, and future updates are 100% free for everyone.
          </p>
        </div>

        {/* Free Plan Card */}
        <div className="max-w-3xl mx-auto rounded-3xl p-8 sm:p-12 bg-gradient-to-b from-indigo-950/30 via-white/[0.02] to-black/60 border-2 border-emerald-500/40 shadow-2xl shadow-emerald-500/10 backdrop-blur-xl mb-16">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 pb-8 border-b border-white/10">
            <div>
              <span className="px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-300 text-xs font-bold uppercase tracking-wider">
                Full Community Edition
              </span>
              <h2 className="text-3xl font-extrabold text-white mt-2">Wallep Complete</h2>
              <p className="text-xs text-white/50 mt-1">Unlimited access across all your personal and work Macs.</p>
            </div>

            <div className="text-left sm:text-right">
              <div className="text-5xl font-black text-white">$0.00</div>
              <span className="text-xs text-emerald-400 font-medium">Free Forever (MIT Licensed)</span>
            </div>
          </div>

          {/* Unlocked Features Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8">
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>All 2700+ Curated 4K Wallpapers Unlocked</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Full Studio & Creator Video Exporter</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Unlimited Custom Video Imports (.mp4, .mov)</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Unlimited Displays & Multi-Monitor Sync</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Native macOS Lock Screen Integration</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Zero Background Battery Drain / IOKit Aware</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Lifetime Updates & Open Source Community</span>
            </div>
            <div className="flex items-center gap-3 text-xs text-white/90">
              <Check className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>No Telemetry, No Ads, No Account Required</span>
            </div>
          </div>

          <div className="flex flex-col sm:flex-row items-center gap-4 pt-4">
            <a
              href="https://github.com/alxndlk/wallper-app/releases"
              target="_blank"
              rel="noreferrer"
              className="w-full sm:w-1/2 py-3.5 rounded-xl bg-white text-black font-semibold text-xs hover:bg-white/90 transition-all flex items-center justify-center gap-2 shadow-lg shadow-white/10 active:scale-95"
            >
              <Apple className="w-4 h-4 fill-current" />
              <span>Download Free App</span>
            </a>

            <a
              href="https://github.com/alxndlk/wallper-app"
              target="_blank"
              rel="noreferrer"
              className="w-full sm:w-1/2 py-3.5 rounded-xl bg-white/[0.08] hover:bg-white/[0.12] text-white font-semibold text-xs border border-white/10 transition-all flex items-center justify-center gap-2 active:scale-95"
            >
              <Github className="w-4 h-4" />
              <span>View Source Code on GitHub</span>
            </a>
          </div>
        </div>

        {/* Community & Open Source Values */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
          <div className="p-6 rounded-2xl bg-white/[0.02] border border-white/[0.06]">
            <Code className="w-5 h-5 text-indigo-400 mb-3" />
            <h3 className="text-sm font-bold text-white mb-1">100% Native Swift</h3>
            <p className="text-xs text-white/60 leading-relaxed">
              No heavy Electron layers or WebViews. Clean AppKit windowing and hardware AVFoundation decoders.
            </p>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.02] border border-white/[0.06]">
            <ShieldCheck className="w-5 h-5 text-emerald-400 mb-3" />
            <h3 className="text-sm font-bold text-white mb-1">Privacy Focused</h3>
            <p className="text-xs text-white/60 leading-relaxed">
              Runs locally on your Mac. No accounts, no subscriptions, and zero tracking.
            </p>
          </div>

          <div className="p-6 rounded-2xl bg-white/[0.02] border border-white/[0.06]">
            <Sparkles className="w-5 h-5 text-pink-400 mb-3" />
            <h3 className="text-sm font-bold text-white mb-1">Community Driven</h3>
            <p className="text-xs text-white/60 leading-relaxed">
              Contribute new live wallpapers, submit shaders, and improve the app on GitHub.
            </p>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
