import Header from "@/components/Header";
import Hero from "@/components/Hero/Hero";
import MacSimulation from "@/components/MacPreview/MacSimulation";
import Highlights from "@/components/Highlights/Highlights";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <div className="min-h-screen bg-[#090a0f] text-white selection:bg-indigo-500 selection:text-white relative overflow-hidden">
      {/* Background ambient lighting glows */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[1000px] h-[600px] bg-gradient-to-b from-indigo-600/15 via-purple-600/5 to-transparent blur-3xl pointer-events-none -z-10" />

      {/* Main Header */}
      <Header />

      {/* Hero Section */}
      <Hero />

      {/* Simulated Interactive macOS Desktop & App Window */}
      <section className="px-4 sm:px-6">
        <MacSimulation />
      </section>

      {/* Feature Deep Dives */}
      <Highlights />

      {/* Footer */}
      <Footer />
    </div>
  );
}
