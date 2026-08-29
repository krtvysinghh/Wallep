"use client";
import React, { useState } from "react";
import { Volume2, Play, Pause } from "lucide-react";

export const AmbientPlayer = () => {
  const [isPlaying, setIsPlaying] = useState(false);
  return (
    <div className="p-4 rounded-xl bg-white/5 border border-white/10 flex items-center justify-between">
      <div className="flex items-center gap-3">
        <Volume2 className="w-5 h-5 text-indigo-400" />
        <span className="text-sm font-medium text-white">Rain on Glass (Ambient Preview)</span>
      </div>
      <button 
        onClick={() => setIsPlaying(!isPlaying)}
        className="px-3 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold flex items-center gap-1.5"
      >
        {isPlaying ? <Pause className="w-3.5 h-3.5" /> : <Play className="w-3.5 h-3.5" />}
        {isPlaying ? "Pause" : "Play Soundscape"}
      </button>
    </div>
  );
};
