import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Wallep — 4K Live Wallpapers for Mac (Open Source & Native)",
  description: "Turn any 4K video into a live wallpaper for your Mac — desktop, lock screen & screensaver. 90,000+ users. From $14.99 one-time, no subscription, 7-day free trial.",
  keywords: ["live wallpapers", "mac live wallpaper", "dynamic wallpapers", "4k mac wallpaper", "wallep", "open source mac app"],
  icons: {
    icon: "/favicon.ico",
  },
  openGraph: {
    title: "Wallep — Live Wallpapers for Mac",
    description: "4K live wallpapers for macOS desktop, lock screen, and screensaver. 90,000+ users, battery-aware, music sync, multi-display.",
    url: "https://wallep.app",
    siteName: "Wallep",
    type: "website",
  }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <body className="bg-[#090a0f] text-[#ededed] antialiased min-h-screen">
        {children}
      </body>
    </html>
  );
}
