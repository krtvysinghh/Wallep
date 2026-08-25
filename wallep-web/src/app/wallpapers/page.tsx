"use client";

import { useState } from "react";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { Search, Heart, Play, Download, Sparkles, Filter } from "lucide-react";

interface Wallpaper {
  id: string;
  title: string;
  category: string;
  res: string;
  fps: string;
  size: string;
  likes: number;
  author: string;
  gradient: string;
  videoSrc?: string;
}

const WALLPAPERS_DATA: Wallpaper[] = [
  {
    id: "1",
    title: "Cat in Rain (Lo-Fi Cozy)",
    category: "Anime",
    res: "3840x2160 (4K)",
    fps: "60 FPS",
    size: "25MB",
    likes: 441,
    author: "Ghibli Vibes",
    gradient: "from-blue-900 via-indigo-950 to-black"
  },
  {
    id: "2",
    title: "Orchid in the Rain",
    category: "Nature",
    res: "3840x2160 (4K UHD)",
    fps: "60 FPS",
    size: "40MB",
    likes: 456,
    author: "Nature Lab",
    gradient: "from-emerald-950 via-teal-950 to-black"
  },
  {
    id: "3",
    title: "Cyberpunk Neo Tokyo",
    category: "Cyberpunk",
    res: "3840x2160 (4K HDR)",
    fps: "60 FPS",
    size: "48MB",
    likes: 1289,
    author: "Neon Dreams",
    gradient: "from-fuchsia-950 via-purple-950 to-black"
  },
  {
    id: "4",
    title: "Porsche GT3 RS High Speed",
    category: "Cars",
    res: "3840x2160 (4K)",
    fps: "60 FPS",
    size: "30MB",
    likes: 890,
    author: "Apex Velocity",
    gradient: "from-red-950 via-stone-950 to-black"
  },
  {
    id: "5",
    title: "Deep Cosmos Nebula Loop",
    category: "Space",
    res: "3840x2160 (4K)",
    fps: "60 FPS",
    size: "62MB",
    likes: 673,
    author: "Interstellar",
    gradient: "from-violet-950 via-slate-950 to-black"
  },
  {
    id: "6",
    title: "Minimalist Aurora Borealis",
    category: "Minimalist",
    res: "3840x2160 (4K)",
    fps: "60 FPS",
    size: "28MB",
    likes: 512,
    author: "Nordic Ambient",
    gradient: "from-cyan-950 via-sky-950 to-black"
  },
  {
    id: "7",
    title: "Sunset Waves on Black Sand",
    category: "Nature",
    res: "3840x2160 (4K UHD)",
    fps: "60 FPS",
    size: "38MB",
    likes: 310,
    author: "Pacific Shore",
    gradient: "from-orange-950 via-amber-950 to-black"
  },
  {
    id: "8",
    title: "Midnight Tokyo Expressway",
    category: "Cars",
    res: "3840x2160 (4K)",
    fps: "60 FPS",
    size: "44MB",
    likes: 742,
    author: "Shuto Expressway",
    gradient: "from-indigo-950 via-neutral-950 to-black"
  }
];

const CATEGORIES = ["All", "Nature", "Anime", "Cyberpunk", "Cars", "Space", "Minimalist"];

export default function WallpapersGalleryPage() {
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [search, setSearch] = useState("");
  const [likedMap, setLikedMap] = useState<Record<string, boolean>>({});

  const filtered = WALLPAPERS_DATA.filter((item) => {
    const matchCat = selectedCategory === "All" || item.category === selectedCategory;
    const matchSearch =
      search === "" ||
      item.title.toLowerCase().includes(search.toLowerCase()) ||
      item.author.toLowerCase().includes(search.toLowerCase());
    return matchCat && matchSearch;
  });

  const toggleLike = (id: string) => {
    setLikedMap((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div className="min-h-screen bg-[#090a0f] text-white selection:bg-indigo-500 selection:text-white">
      <Header />

      <main className="pt-32 pb-24 px-6 max-w-7xl mx-auto">
        {/* Gallery Header */}
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-6 mb-12">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/30 text-indigo-300 text-xs font-semibold mb-3">
              <Sparkles className="w-3.5 h-3.5" />
              <span>Curated 4K HDR Catalog</span>
            </div>
            <h1 className="text-3xl sm:text-5xl font-bold tracking-tight text-white mb-2">
              Browse 2700+ Live Wallpapers
            </h1>
            <p className="text-xs sm:text-sm text-white/50">
              Native resolution, color-graded, zero-stutter 60 FPS video loops for your Mac.
            </p>
          </div>

          {/* Search bar */}
          <div className="w-full md:w-80 flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white/[0.04] border border-white/[0.08] text-xs">
            <Search className="w-4 h-4 text-white/40" />
            <input
              type="text"
              placeholder="Search anime, cars, nature..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="bg-transparent text-white placeholder-white/40 focus:outline-none w-full"
            />
          </div>
        </div>

        {/* Category Selector Pills */}
        <div className="flex items-center gap-2 overflow-x-auto pb-4 mb-8 scrollbar-none">
          {CATEGORIES.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all shrink-0 ${
                selectedCategory === cat
                  ? "bg-indigo-600 text-white shadow-lg shadow-indigo-600/30"
                  : "bg-white/[0.03] text-white/60 hover:text-white border border-white/[0.06]"
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        {/* Wallpaper Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {filtered.map((item) => (
            <div
              key={item.id}
              className="group rounded-2xl bg-white/[0.02] border border-white/[0.08] overflow-hidden hover:border-indigo-500/50 transition-all hover:-translate-y-1 shadow-xl hover:shadow-indigo-500/10 flex flex-col justify-between"
            >
              <div className="relative aspect-video bg-black overflow-hidden">
                <div className={`w-full h-full bg-gradient-to-tr ${item.gradient} flex items-center justify-center relative`}>
                  {/* Play Button on Hover */}
                  <div className="w-12 h-12 rounded-full bg-black/40 backdrop-blur-md border border-white/20 flex items-center justify-center text-white group-hover:scale-110 transition-transform shadow-lg">
                    <Play className="w-5 h-5 fill-current translate-x-0.5" />
                  </div>

                  {/* Resolution badge */}
                  <span className="absolute top-3 left-3 px-2 py-0.5 rounded bg-black/60 backdrop-blur-md text-[9px] font-black tracking-wider text-white border border-white/10">
                    4K 60FPS
                  </span>

                  {/* Like Button */}
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      toggleLike(item.id);
                    }}
                    className={`absolute top-3 right-3 p-1.5 rounded-full backdrop-blur-md border transition-all ${
                      likedMap[item.id]
                        ? "bg-red-500/30 border-red-500 text-red-400"
                        : "bg-black/40 border-white/10 text-white/80 hover:text-white"
                    }`}
                  >
                    <Heart className={`w-3.5 h-3.5 ${likedMap[item.id] ? "fill-red-400" : ""}`} />
                  </button>
                </div>
              </div>

              <div className="p-4 flex flex-col gap-3">
                <div>
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-[10px] font-bold text-indigo-400 uppercase tracking-wide">
                      {item.category}
                    </span>
                    <span className="text-[10px] text-white/40">{item.size}</span>
                  </div>
                  <h3 className="text-sm font-semibold text-white truncate">{item.title}</h3>
                  <p className="text-[11px] text-white/40">{item.author}</p>
                </div>

                <div className="flex items-center justify-between pt-2 border-t border-white/[0.06]">
                  <span className="text-[11px] text-white/60">
                    {item.likes + (likedMap[item.id] ? 1 : 0)} likes
                  </span>

                  <a
                    href="https://github.com/alxndlk/wallper-app/releases"
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-white/10 hover:bg-white text-white hover:text-black text-xs font-semibold transition-all"
                  >
                    <Download className="w-3.5 h-3.5" />
                    <span>Apply in App</span>
                  </a>
                </div>
              </div>
            </div>
          ))}
        </div>
      </main>

      <Footer />
    </div>
  );
}
