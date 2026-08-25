"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Sparkles, Apple, ExternalLink, Heart } from "lucide-react";

export default function Header() {
  const pathname = usePathname();

  return (
    <header className="fixed top-0 left-0 right-0 z-50 flex justify-center px-4 py-4 backdrop-blur-md bg-[#090a0f]/80 border-b border-white/[0.06]">
      <div className="w-full max-w-7xl flex items-center justify-between">
        {/* Left: Brand Logo */}
        <Link href="/" className="flex items-center gap-2.5 text-white font-semibold text-lg tracking-tight group">
          <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-purple-500 flex items-center justify-center shadow-lg shadow-indigo-500/20 group-hover:scale-105 transition-transform">
            <Sparkles className="w-4 h-4 text-white" />
          </div>
          <span>Wallep</span>
        </Link>

        {/* Center: Nav links */}
        <nav className="hidden md:flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/[0.04] border border-white/[0.08] shadow-inner">
          <Link
            href="/"
            className={`flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-medium transition-colors ${
              pathname === "/" ? "text-white bg-white/[0.08]" : "text-white/70 hover:text-white"
            }`}
          >
            Product
            <div className="beam-container px-2 py-0.5 bg-emerald-500/10 border border-emerald-500/30 rounded-full">
              <span className="text-[10px] font-bold text-emerald-300">100% Free</span>
            </div>
          </Link>

          <Link
            href="/wallpapers"
            className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-colors ${
              pathname === "/wallpapers" ? "text-white bg-white/[0.08]" : "text-white/70 hover:text-white"
            }`}
          >
            Gallery (2700+)
          </Link>

          <Link
            href="/studio"
            className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-colors ${
              pathname === "/studio" ? "text-white bg-white/[0.08]" : "text-white/70 hover:text-white"
            }`}
          >
            Studio
          </Link>

          <Link
            href="/pricing"
            className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-colors ${
              pathname === "/pricing" ? "text-white bg-white/[0.08]" : "text-white/70 hover:text-white"
            }`}
          >
            Free & Open Source
          </Link>
        </nav>

        {/* Right: Actions */}
        <div className="flex items-center gap-3">
          <a
            href="https://github.com/alxndlk/wallper-app"
            target="_blank"
            rel="noreferrer"
            className="hidden sm:flex items-center gap-1.5 text-xs text-white/60 hover:text-white transition-colors px-3 py-2"
          >
            <span>GitHub</span>
            <ExternalLink className="w-3 h-3 opacity-60" />
          </a>

          <a
            href="https://github.com/alxndlk/wallper-app/releases"
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white text-black text-xs font-semibold hover:bg-white/90 transition-all shadow-md shadow-white/10 active:scale-95"
          >
            <Apple className="w-3.5 h-3.5 fill-current" />
            <span>Download Free</span>
          </a>
        </div>
      </div>
    </header>
  );
}
