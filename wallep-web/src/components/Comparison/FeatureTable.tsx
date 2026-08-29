import React from "react";
import { Check, X } from "lucide-react";

export const FeatureTable = () => {
  const features = [
    { name: "100% Free & Open Source", wallep: true, others: false },
    { name: "Zero WebViews / Pure Native AppKit", wallep: true, others: false },
    { name: "Hardware AVFoundation Decoding", wallep: true, others: true },
    { name: "5,000+ Curated 4K Wallpapers", wallep: true, others: false },
    { name: "Auto-Change Rotation Engine", wallep: true, others: true },
    { name: "Zero Telemetry / 100% Offline", wallep: true, others: false },
  ];

  return (
    <div className="w-full overflow-x-auto">
      <table className="w-full text-left text-sm text-white/80 border border-white/10 rounded-xl">
        <thead className="bg-white/5 text-white text-xs uppercase">
          <tr>
            <th className="p-4">Feature</th>
            <th className="p-4 text-indigo-400">Wallep</th>
            <th className="p-4 text-white/40">Other Apps</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-white/5">
          {features.map((f, i) => (
            <tr key={i} className="hover:bg-white/5">
              <td className="p-4 font-medium">{f.name}</td>
              <td className="p-4"><Check className="w-5 h-5 text-emerald-400" /></td>
              <td className="p-4">{f.others ? <Check className="w-5 h-5 text-white/40" /> : <X className="w-5 h-5 text-rose-400" />}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
