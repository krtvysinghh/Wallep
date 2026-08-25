"use client";

import { useState } from "react";
import { Play, Heart, ChevronLeft, ChevronRight, Search, Battery, Wifi, Sliders, Key, Upload, Settings, Sparkles } from "lucide-react";

interface WallpaperItem {
  id: string;
  title: string;
  category: string;
  res: string;
  size: string;
  duration: string;
  timeAgo: string;
  likes: number;
  videoSrc: string;
  bgGradient: string;
}

const WALLPAPERS: WallpaperItem[] = [
  {
    id: "1",
    title: "Cat in Rain (Lo-Fi)",
    category: "CARTOON",
    res: "2606x1467",
    size: "25MB",
    duration: "1:30s",
    timeAgo: "1 month ago",
    likes: 441,
    videoSrc: "https://assets.mixkit.co/videos/preview/mixkit-cat-looking-out-the-window-in-the-rain-41551-large.mp4",
    bgGradient: "from-blue-900 via-indigo-950 to-black",
  },
  {
    id: "2",
    title: "Orchid in the Rain",
    category: "NATURE",
    res: "3840x2160",
    size: "40MB",
    duration: "2:00s",
    timeAgo: "2 weeks ago",
    likes: 456,
    videoSrc: "https://assets.mixkit.co/videos/preview/mixkit-rain-falling-on-the-leaves-of-a-plant-41552-large.mp4",
    bgGradient: "from-emerald-950 via-teal-950 to-black",
  },
  {
    id: "3",
    title: "Farming Frogs",
    category: "CARTOON",
    res: "1920x1080",
    size: "15MB",
    duration: "0:45s",
    timeAgo: "3 days ago",
    likes: 789,
    videoSrc: "https://assets.mixkit.co/videos/preview/mixkit-futuristic-city-with-flying-cars-and-skyscrapers-41553-large.mp4",
    bgGradient: "from-amber-950 via-orange-950 to-black",
  },
  {
    id: "4",
    title: "BMW M3 Track Edit",
    category: "CARS",
    res: "3840x2160",
    size: "50MB",
    duration: "3:15s",
    timeAgo: "5 days ago",
    likes: 101,
    videoSrc: "https://assets.mixkit.co/videos/preview/mixkit-driving-on-a-highway-at-sunset-41554-large.mp4",
    bgGradient: "from-purple-950 via-slate-950 to-black",
  },
  {
    id: "5",
    title: "Porsche GT3 RS Loop",
    category: "CARS",
    res: "3840x2160",
    size: "30MB",
    duration: "1:15s",
    timeAgo: "1 week ago",
    likes: 112,
    videoSrc: "https://assets.mixkit.co/videos/preview/mixkit-flying-through-a-starfield-in-space-41555-large.mp4",
    bgGradient: "from-rose-950 via-stone-950 to-black",
  }
];

export default function MacSimulation() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isWindowOpen, setIsWindowOpen] = useState(true);
  const [isMinimized, setIsMinimized] = useState(false);
  const [likedMap, setLikedMap] = useState<Record<string, boolean>>({});

  const current = WALLPAPERS[currentIndex];

  const handlePrev = () => {
    setCurrentIndex((prev) => (prev > 0 ? prev - 1 : WALLPAPERS.length - 1));
  };

  const handleNext = () => {
    setCurrentIndex((prev) => (prev < WALLPAPERS.length - 1 ? prev + 1 : 0));
  };

  const toggleLike = (id: string) => {
    setLikedMap((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div className="w-full max-w-6xl mx-auto my-12 rounded-2xl overflow-hidden border border-white/10 shadow-2xl bg-black relative selection:bg-indigo-500 selection:text-white">
      {/* Simulated Live Desktop Background Layer */}
      <div className={`absolute inset-0 bg-gradient-to-br ${current.bgGradient} transition-colors duration-700`}>
        {/* Ambient video texture */}
        <div className="absolute inset-0 opacity-40 mix-blend-overlay pointer-events-none bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px]" />
      </div>

      {/* 1. macOS Menubar */}
      <div className="relative z-20 h-8 px-4 flex items-center justify-between text-xs text-white/90 bg-black/60 backdrop-blur-xl border-b border-white/10 select-none">
        {/* Left: Apple logo & App Menu */}
        <div className="flex items-center gap-4">
          <svg className="w-3.5 h-3.5 fill-current opacity-90" viewBox="0 0 170 170">
            <path d="M150.37 130.25c-2.45 5.66-5.35 10.87-8.71 15.66-4.58 6.53-8.33 11.05-11.22 13.56-4.48 4.12-9.28 6.23-14.42 6.35-3.69 0-8.14-1.05-13.32-3.18-5.19-2.12-9.97-3.17-14.34-3.17-4.58 0-9.49 1.05-14.75 3.17-5.26 2.13-9.5 3.24-12.74 3.35-4.35.13-9.16-1.9-14.42-6.08-3.69-3.04-7.67-7.81-11.96-14.34-5.39-8.15-9.84-17.72-13.34-28.71-3.5-10.98-5.25-21.72-5.25-32.2 0-14.35 3.69-26.4 11.07-36.17 7.38-9.76 16.63-14.75 27.75-14.99 4.35 0 9.38 1.15 15.09 3.44 5.71 2.3 9.48 3.51 11.33 3.65 1.5.12 5.37-1.15 11.61-3.81 6.24-2.65 11.75-3.86 16.53-3.63 12.39.63 22.42 5.09 30.1 13.39-10.83 6.53-16.14 15.54-15.93 27.02.21 9.02 3.64 16.6 10.3 22.75 6.66 6.14 14.54 9.58 23.63 10.31-2.12 6.53-4.63 12.87-7.53 19.01z" />
          </svg>
          <span className="font-semibold text-white">Wallep</span>
          <span className="hidden sm:inline text-white/70 hover:text-white cursor-default">File</span>
          <span className="hidden sm:inline text-white/70 hover:text-white cursor-default">Edit</span>
          <span className="hidden sm:inline text-white/70 hover:text-white cursor-default">View</span>
          <span className="hidden sm:inline text-white/70 hover:text-white cursor-default">Window</span>
          <span className="hidden sm:inline text-white/70 hover:text-white cursor-default">Help</span>
        </div>

        {/* Center: Simulated Notch / Dynamic Island */}
        <div className="absolute left-1/2 -translate-x-1/2 top-0 h-4 w-28 bg-black rounded-b-xl border-b border-x border-white/20" />

        {/* Right: Status Icons */}
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1 px-2 py-0.5 rounded bg-indigo-500/20 text-indigo-300 text-[10px] font-medium border border-indigo-500/30">
            <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 animate-pulse" />
            <span className="hidden sm:inline">Works in background</span>
          </div>
          <span className="text-[11px] text-white/80">86%</span>
          <Battery className="w-3.5 h-3.5 text-white/80" />
          <Wifi className="w-3.5 h-3.5 text-white/80" />
          <Sliders className="w-3.5 h-3.5 text-white/80" />
          <span className="text-[11px] text-white/90 font-medium">15:30</span>
        </div>
      </div>

      {/* 2. Desktop Canvas Area with Wallep Application Window */}
      <div className="relative z-10 min-h-[540px] p-6 sm:p-10 flex items-center justify-center">
        {isWindowOpen && !isMinimized ? (
          <div className="w-full max-w-3xl rounded-2xl bg-[#12141c]/95 backdrop-blur-2xl border border-white/10 shadow-2xl overflow-hidden transition-all duration-300 transform scale-100 opacity-100">
            {/* Window Titlebar & Controls */}
            <div className="h-10 px-4 bg-white/[0.03] border-b border-white/[0.06] flex items-center justify-between">
              {/* Traffic Light Buttons */}
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setIsWindowOpen(false)}
                  title="Close Window"
                  className="w-3 h-3 rounded-full bg-[#ff5f56] border border-[#e0443e] hover:brightness-90 transition-all flex items-center justify-center text-[8px] text-black/60 font-bold group"
                >
                  <span className="opacity-0 group-hover:opacity-100">×</span>
                </button>
                <button
                  onClick={() => setIsMinimized(true)}
                  title="Minimize"
                  className="w-3 h-3 rounded-full bg-[#ffbd2e] border border-[#dea123] hover:brightness-90 transition-all flex items-center justify-center text-[8px] text-black/60 font-bold group"
                >
                  <span className="opacity-0 group-hover:opacity-100">−</span>
                </button>
                <button
                  title="Full Screen"
                  className="w-3 h-3 rounded-full bg-[#27c93f] border border-[#1aab29] hover:brightness-90 transition-all flex items-center justify-center text-[8px] text-black/60 font-bold group"
                >
                  <span className="opacity-0 group-hover:opacity-100">+</span>
                </button>
              </div>

              {/* Center App Tabs */}
              <div className="flex items-center gap-1 px-2 py-0.5 rounded-lg bg-black/40 border border-white/5 text-xs">
                <span className="px-3 py-1 rounded bg-white/10 text-white font-medium">Home</span>
                <span className="px-3 py-1 rounded text-white/50 hover:text-white cursor-pointer transition-colors">Explore</span>
                <span className="px-3 py-1 rounded text-white/50 hover:text-white cursor-pointer transition-colors">My Media</span>
              </div>

              {/* Right Utility Icons */}
              <div className="flex items-center gap-3 text-white/60">
                <Search className="w-3.5 h-3.5 hover:text-white cursor-pointer" />
                <Key className="w-3.5 h-3.5 hover:text-white cursor-pointer" />
                <Settings className="w-3.5 h-3.5 hover:text-white cursor-pointer" />
              </div>
            </div>

            {/* Window Content: Live Carousel & Meta */}
            <div className="p-6 relative">
              {/* Carousel Navigation Arrows */}
              <button
                onClick={handlePrev}
                className="absolute left-8 top-1/2 -translate-y-1/2 z-20 w-9 h-9 rounded-full bg-black/60 hover:bg-black/90 text-white flex items-center justify-center border border-white/10 backdrop-blur-md transition-all active:scale-95"
              >
                <ChevronLeft className="w-5 h-5" />
              </button>

              <button
                onClick={handleNext}
                className="absolute right-8 top-1/2 -translate-y-1/2 z-20 w-9 h-9 rounded-full bg-black/60 hover:bg-black/90 text-white flex items-center justify-center border border-white/10 backdrop-blur-md transition-all active:scale-95"
              >
                <ChevronRight className="w-5 h-5" />
              </button>

              {/* Main Wallpaper Preview Card */}
              <div className="relative rounded-xl overflow-hidden bg-black aspect-video border border-white/10 shadow-lg group">
                <div className={`w-full h-full bg-gradient-to-tr ${current.bgGradient} flex items-center justify-center relative`}>
                  {/* Category & Title */}
                  <div className="absolute top-4 left-4 z-10 flex items-center gap-2">
                    <span className="px-2.5 py-1 rounded-md bg-white/10 backdrop-blur-md text-[10px] font-black tracking-wider text-white border border-white/15 uppercase">
                      {current.category}
                    </span>
                    <span className="text-sm font-semibold text-white drop-shadow-md">
                      {current.title}
                    </span>
                  </div>

                  <div className="flex flex-col items-center gap-3 text-center z-10">
                    <div className="w-14 h-14 rounded-full bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center text-white shadow-xl group-hover:scale-110 transition-transform">
                      <Play className="w-6 h-6 fill-current translate-x-0.5" />
                    </div>
                    <span className="text-xs text-white/80 font-medium">4K Native 60 FPS Loop</span>
                  </div>

                  {/* Bottom Meta Bar inside Video Preview */}
                  <div className="absolute bottom-4 left-4 right-4 z-10 flex items-center justify-between">
                    <div className="text-[11px] text-white/70 font-mono flex items-center gap-2">
                      <span>{current.res}</span>
                      <span>•</span>
                      <span>{current.timeAgo}</span>
                      <span>•</span>
                      <span>{current.size}</span>
                      <span>•</span>
                      <span>{current.duration}</span>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => toggleLike(current.id)}
                        className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold backdrop-blur-md border transition-all ${
                          likedMap[current.id]
                            ? "bg-red-500/30 border-red-500/50 text-red-300"
                            : "bg-black/50 border-white/20 text-white hover:bg-black/70"
                        }`}
                      >
                        <Heart className={`w-3.5 h-3.5 ${likedMap[current.id] ? "fill-red-400 text-red-400" : ""}`} />
                        <span>{current.likes + (likedMap[current.id] ? 1 : 0)}</span>
                      </button>

                      <button className="px-4 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold shadow-md transition-all active:scale-95">
                        View Wallep
                      </button>
                    </div>
                  </div>
                </div>

                {/* Progress Dots */}
                <div className="absolute bottom-1.5 left-1/2 -translate-x-1/2 flex items-center gap-1.5 z-20">
                  {WALLPAPERS.map((_, idx) => (
                    <button
                      key={idx}
                      onClick={() => setCurrentIndex(idx)}
                      className={`h-1.5 rounded-full transition-all ${
                        idx === currentIndex ? "w-5 bg-white" : "w-1.5 bg-white/30"
                      }`}
                    />
                  ))}
                </div>
              </div>

              {/* Recommended Mini-Row */}
              <div className="mt-4">
                <div className="flex items-center justify-between text-xs text-white/60 mb-2">
                  <span className="font-semibold text-white/80">Recommended For You</span>
                  <span className="hover:text-white cursor-pointer">See all (2700+) →</span>
                </div>

                <div className="grid grid-cols-5 gap-2.5">
                  {WALLPAPERS.map((w, idx) => (
                    <div
                      key={w.id}
                      onClick={() => setCurrentIndex(idx)}
                      className={`h-14 rounded-lg bg-gradient-to-tr ${w.bgGradient} border cursor-pointer transition-all hover:scale-105 flex items-end p-1.5 ${
                        idx === currentIndex ? "border-indigo-500 ring-2 ring-indigo-500/30" : "border-white/10 opacity-70 hover:opacity-100"
                      }`}
                    >
                      <span className="text-[9px] font-bold text-white truncate drop-shadow">{w.title}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="flex flex-col items-center gap-3 p-8 rounded-xl bg-black/40 border border-white/10 backdrop-blur-md text-white/70">
            <p className="text-sm">Window minimized to Dock. Click Wallep icon in Dock to restore.</p>
            <button
              onClick={() => {
                setIsWindowOpen(true);
                setIsMinimized(false);
              }}
              className="px-4 py-2 rounded-lg bg-indigo-600 text-white text-xs font-semibold"
            >
              Restore Wallep Window
            </button>
          </div>
        )}
      </div>

      {/* 3. macOS Interactive Dock */}
      <div className="relative z-20 pb-4 flex justify-center">
        <div className="px-4 py-2.5 rounded-2xl bg-white/[0.08] backdrop-blur-2xl border border-white/15 shadow-2xl flex items-center gap-4">
          <button
            onClick={() => {
              setIsWindowOpen(true);
              setIsMinimized(false);
            }}
            title="Open Wallep"
            className="w-11 h-11 rounded-xl bg-gradient-to-tr from-indigo-600 via-indigo-500 to-purple-600 flex items-center justify-center text-white shadow-lg hover:scale-110 transition-transform active:scale-95 relative group"
          >
            <Sparkles className="w-6 h-6" />
            <span className="absolute -bottom-1.5 w-1 h-1 rounded-full bg-white opacity-90" />
          </button>

          <div className="w-10 h-10 rounded-xl bg-blue-500/30 border border-blue-400/20 flex items-center justify-center text-white/80 hover:scale-105 transition-transform">
            <Search className="w-5 h-5" />
          </div>

          <div className="w-10 h-10 rounded-xl bg-purple-500/30 border border-purple-400/20 flex items-center justify-center text-white/80 hover:scale-105 transition-transform">
            <Upload className="w-5 h-5" />
          </div>

          <div className="w-10 h-10 rounded-xl bg-gray-500/30 border border-gray-400/20 flex items-center justify-center text-white/80 hover:scale-105 transition-transform">
            <Settings className="w-5 h-5" />
          </div>
        </div>
      </div>
    </div>
  );
}

function SparklesIcon(props: React.SVGProps<SVGSVGElement>) {
  return (
    <svg fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24" {...props}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
    </svg>
  );
}
