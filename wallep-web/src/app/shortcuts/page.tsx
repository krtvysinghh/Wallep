import React from "react";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { KeyboardReference } from "@/components/Shortcuts/KeyboardReference";

export default function ShortcutsPage() {
  return (
    <div className="min-h-screen bg-[#070709] text-white">
      <Header />
      <main className="max-w-4xl mx-auto px-6 py-20">
        <h1 className="text-4xl font-bold mb-4">Keyboard Shortcuts & CLI</h1>
        <p className="text-white/60 mb-8">Control Wallep globally from anywhere on macOS.</p>
        <KeyboardReference />
      </main>
      <Footer />
    </div>
  );
}
