import Link from "next/link";
import { Sparkles, Heart } from "lucide-react";

export default function Footer() {
  return (
    <footer className="border-t border-white/[0.06] bg-[#07080c] py-14 px-6">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
        <div className="flex flex-col items-center md:items-start gap-2">
          <div className="flex items-center gap-2.5">
            <div className="w-6 h-6 rounded-lg bg-indigo-600 flex items-center justify-center">
              <Sparkles className="w-3.5 h-3.5 text-white" />
            </div>
            <span className="text-white font-semibold tracking-tight">Wallep</span>
          </div>
          <p className="text-xs text-white/50 max-w-sm text-center md:text-left">
            Native 4K Live Wallpapers for macOS — zero daemons, aggressive battery management, 2700+ curated animations.
          </p>
        </div>

        <div className="flex flex-wrap items-center justify-center gap-6 text-xs text-white/60">
          <Link href="/wallpapers" className="hover:text-white transition-colors">4K Gallery</Link>
          <Link href="/studio" className="hover:text-white transition-colors">Studio</Link>
          <Link href="/pricing" className="hover:text-white transition-colors">Pricing</Link>
          <a href="https://github.com/alxndlk/wallper-app" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Open Source GitHub</a>
          <a href="https://discord.com" target="_blank" rel="noreferrer" className="hover:text-white transition-colors">Discord Community</a>
        </div>

        <div className="flex items-center gap-1.5 text-xs text-white/40">
          <span>Crafted with</span>
          <Heart className="w-3 h-3 text-red-500 fill-red-500" />
          <span>for macOS Sonoma, Sequoia & beyond</span>
        </div>
      </div>
    </footer>
  );
}
