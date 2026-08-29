"use client";
import React, { useEffect, useState } from "react";
import { ShieldCheck, Cpu } from "lucide-react";

export const SystemCheck = () => {
  const [platform, setPlatform] = useState("");

  useEffect(() => {
    setPlatform(navigator.userAgent.includes("Mac") ? "macOS Detected" : "Browser Environment");
  }, []);

  return (
    <div className="p-6 rounded-2xl bg-indigo-950/40 border border-indigo-500/20 flex items-center gap-4">
      <ShieldCheck className="w-8 h-8 text-emerald-400" />
      <div>
        <h4 className="text-sm font-semibold text-white">System Compatibility Check</h4>
        <p className="text-xs text-white/60">{platform} • Compatible with Wallep Native Engine</p>
      </div>
    </div>
  );
};
