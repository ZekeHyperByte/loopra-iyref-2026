import { Logo } from "@/components/Logo";

export const LandingFooter = () => (
  <footer className="border-t border-border/50 mt-20">
    <div className="container py-10 grid md:grid-cols-4 gap-8">
      <div className="md:col-span-2">
        <Logo />
        <p className="text-sm text-muted-foreground mt-4 max-w-sm">
          The sovereign protocol for bio-energy logistics across the Indonesian archipelago.
        </p>
      </div>
      {[
        { title: "Protocol", items: ["SMER Whitepaper", "Carbon Methodology", "API Reference"] },
        { title: "Network", items: ["Pertamina Portal", "Hub Operators", "ESG Auditors"] },
      ].map((c) => (
        <div key={c.title}>
          <div className="text-xs font-mono tracking-widest text-accent mb-3">{c.title.toUpperCase()}</div>
          <ul className="space-y-2">
            {c.items.map((i) => (
              <li key={i} className="text-sm text-muted-foreground hover:text-foreground cursor-pointer">{i}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
    <div className="container py-6 border-t border-border/50 text-xs text-muted-foreground flex justify-between font-mono">
      <span>© 2026 LOOPRA PROTOCOL · ID</span>
      <span className="text-accent">SYS · OPERATIONAL</span>
    </div>
  </footer>
);
