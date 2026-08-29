import React from "react";

export const KeyboardReference = () => {
  const shortcuts = [
    { key: "⌥ ⌘ N", action: "Next Wallpaper (Auto-Change trigger)" },
    { key: "⌥ ⌘ Space", action: "Play / Pause live wallpaper rendering" },
    { key: "⌥ ⌘ M", action: "Mute / Unmute audio soundscape" },
  ];

  return (
    <div className="grid sm:grid-cols-3 gap-4">
      {shortcuts.map((s, i) => (
        <div key={i} className="p-4 rounded-xl bg-white/5 border border-white/10">
          <kbd className="px-2.5 py-1 rounded bg-white/10 font-mono text-xs text-indigo-300 font-bold">{s.key}</kbd>
          <p className="mt-2 text-xs text-white/70">{s.action}</p>
        </div>
      ))}
    </div>
  );
};
