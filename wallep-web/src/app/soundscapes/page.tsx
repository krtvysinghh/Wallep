import React from "react";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { AmbientPlayer } from "@/components/Soundscapes/AmbientPlayer";

export default function SoundscapesPage() {
  return (
    <div className="min-h-screen bg-[#070709] text-white">
      <Header />
      <main className="max-w-4xl mx-auto px-6 py-20">
        <h1 className="text-4xl font-bold mb-4">Ambient Soundscapes</h1>
        <p className="text-white/60 mb-8">Pair your 4K live wallpapers with atmospheric audio loops.</p>
        <AmbientPlayer />
      </main>
      <Footer />
    </div>
  );
}
