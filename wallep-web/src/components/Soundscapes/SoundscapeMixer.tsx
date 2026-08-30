"use client";
import React, { useState } from "react";
import { Sliders, CloudRain, Wind, Waves } from "lucide-react";

export const SoundscapeMixer = () => {
  const [rain, setRain] = useState(30);
  const [wind, setWind] = useState(20);

  return (
    <div className="p-6 rounded-2xl bg-white/5 border border-white/10 space-y-4">
      <div className="flex items-center gap-2 text-indigo-400">
        <Sliders className="w-5 h-5" />
        <h3 className="font-semibold text-white">Live Ambient Sound Mixer</h3>
      </div>
      <div className="space-y-3">
        <div>
          <div className="flex justify-between text-xs text-white/70 mb-1">
            <span className="flex items-center gap-1"><CloudRain className="w-3.5 h-3.5" /> Rain Intensity</span>
            <span>{rain}%</span>
          </div>
          <input type="range" min="0" max="100" value={rain} onChange={(e) => setRain(Number(e.target.value))} className="w-full accent-indigo-500" />
        </div>
        <div>
          <div className="flex justify-between text-xs text-white/70 mb-1">
            <span className="flex items-center gap-1"><Wind className="w-3.5 h-3.5" /> Wind Ambience</span>
            <span>{wind}%</span>
          </div>
          <input type="range" min="0" max="100" value={wind} onChange={(e) => setWind(Number(e.target.value))} className="w-full accent-indigo-500" />
        </div>
      </div>
    </div>
  );
};
