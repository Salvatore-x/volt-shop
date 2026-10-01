import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "VOLT — Tech essentials",
  description: "Thoughtfully selected audio, workspace, and tech accessories. Find your everyday upgrade at VOLT.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
