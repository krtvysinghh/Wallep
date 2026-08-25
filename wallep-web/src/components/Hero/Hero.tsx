import { Apple, ArrowRight, Sparkles, Zap, BatteryCharging, Monitor, HeartHandshake } from "lucide-react";
import Link from "next/link";

export default function Hero() {
  return (
    <section className="pt-32 pb-8 px-6 text-center max-w-5xl mx-auto flex flex-col items-center">
      {/* Top Release Pill */}
      <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-xs text-emerald-300 mb-8 backdrop-blur-md hover:bg-emerald-500/15 transition-all cursor-pointer">
        <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
        <span className="font-semibold">100% Free & Open Source — No Subscriptions, Ever</span>
        <ArrowRight className="w-3 h-3 text-emerald-400/70" />
      </div>

      {/* Main Title */}
      <h1 className="text-4xl sm:text-6xl md:text-7xl font-bold tracking-tight text-white max-w-4xl leading-[1.1] mb-6">
        Live wallpapers, <br />
        <span className="bg-gradient-to-r from-indigo-300 via-purple-300 to-pink-300 bg-clip-text text-transparent">
          free & native on Mac.
        </span>
      </h1>

      {/* Subtitle / Intro */}
      <p className="text-base sm:text-lg text-white/70 max-w-2xl leading-relaxed mb-10">
        Wallep is a completely free, open-source live-wallpaper engine for Mac users. Native desktop & Lock Screen playback, aggressive battery management, and an unlocked 2700+ 4K library — with zero paywalls or subscriptions.
      </p>

      {/* CTA Buttons */}
      <div className="flex flex-col sm:flex-row items-center gap-4 mb-8 w-full sm:w-auto">
        <a
          href="https://github.com/alxndlk/wallper-app/releases"
          target="_blank"
          rel="noreferrer"
          className="w-full sm:w-auto flex items-center justify-center gap-2.5 px-7 py-3.5 rounded-xl bg-white text-black font-semibold text-sm hover:bg-white/90 transition-all shadow-xl shadow-white/10 active:scale-95"
        >
          <Apple className="w-4 h-4 fill-current" />
          <span>Download Free for macOS</span>
        </a>

        <Link
          href="/wallpapers"
          className="w-full sm:w-auto flex items-center justify-center gap-2 px-7 py-3.5 rounded-xl bg-white/[0.06] hover:bg-white/[0.1] text-white font-semibold text-sm border border-white/[0.08] backdrop-blur-md transition-all active:scale-95"
        >
          <span>Explore 2700+ Wallpapers</span>
          <ArrowRight className="w-4 h-4 text-white/60" />
        </Link>
      </div>

      {/* Free microcopy */}
      <p className="text-xs text-emerald-400/90 font-medium mb-12 flex items-center gap-1.5">
        <HeartHandshake className="w-4 h-4" />
        <span>Free for personal and commercial use under the MIT Open Source License.</span>
      </p>

      {/* Micro Feature Badges */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 max-w-3xl w-full text-left">
        <div className="p-3.5 rounded-xl bg-white/[0.02] border border-white/[0.06] flex items-center gap-3">
          <div className="p-2 rounded-lg bg-indigo-500/10 text-indigo-400">
            <Zap className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-white">0% Extra CPU</div>
            <div className="text-[11px] text-white/50">Native AVFoundation</div>
          </div>
        </div>

        <div className="p-3.5 rounded-xl bg-white/[0.02] border border-white/[0.06] flex items-center gap-3">
          <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-400">
            <BatteryCharging className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-white">Battery Aware</div>
            <div className="text-[11px] text-white/50">Auto-pause on unplug</div>
          </div>
        </div>

        <div className="p-3.5 rounded-xl bg-white/[0.02] border border-white/[0.06] flex items-center gap-3">
          <div className="p-2 rounded-lg bg-purple-500/10 text-purple-400">
            <Monitor className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-white">Multi-Display</div>
            <div className="text-[11px] text-white/50">Unlimited screens</div>
          </div>
        </div>

        <div className="p-3.5 rounded-xl bg-white/[0.02] border border-white/[0.06] flex items-center gap-3">
          <div className="p-2 rounded-lg bg-pink-500/10 text-pink-400">
            <Sparkles className="w-4 h-4" />
          </div>
          <div>
            <div className="text-xs font-semibold text-white">2700+ Curated</div>
            <div className="text-[11px] text-white/50">All 100% unlocked</div>
          </div>
        </div>
      </div>
    </section>
  );
}
