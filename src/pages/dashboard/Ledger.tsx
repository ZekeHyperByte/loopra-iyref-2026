import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Button } from "@/components/ui/button";
import { Download, ShieldCheck, Hash, Search } from "lucide-react";

const credits = Array.from({ length: 12 }, (_, i) => ({
  id: `LPR-VCC-${(202600 + i).toString(16).toUpperCase()}`,
  hub: ["Lampung", "Sidoarjo", "Makassar", "Banyuwangi"][i % 4],
  amount: (240 + i * 14).toFixed(2),
  date: `2026-04-${String(28 - i).padStart(2, "0")}`,
  verifier: ["Verra", "Gold Standard", "Verra", "ISCC"][i % 4],
  status: i % 5 === 4 ? "Pending" : "Verified",
}));

const Ledger = () => (
  <div className="p-6 space-y-6">
    <PageHeader
      eyebrow="Enterprise Portal · ESG"
      title="Digital Carbon Ledger"
      description="Cryptographically signed verified carbon credits — auditable, immutable, ISO-14064 aligned."
    >
      <div className="flex items-center gap-2 glass rounded-lg px-3 py-1.5 w-64">
        <Search className="h-3.5 w-3.5 text-muted-foreground" />
        <input placeholder="Filter by ID, hub, verifier…" className="bg-transparent text-xs outline-none flex-1" />
      </div>
      <Button size="sm" className="bg-accent text-accent-foreground hover:bg-accent/90">
        <Download className="h-3.5 w-3.5 mr-1.5" /> Export ESG Report
      </Button>
    </PageHeader>

    <div className="grid sm:grid-cols-3 gap-4">
      <GlassCard>
        <div className="text-[10px] font-mono tracking-widest text-muted-foreground">LIFETIME CREDITS</div>
        <div className="text-3xl font-bold mt-1 text-gradient-lime">21,945 <span className="text-base text-muted-foreground">tCO₂e</span></div>
      </GlassCard>
      <GlassCard>
        <div className="text-[10px] font-mono tracking-widest text-muted-foreground">VERIFIED THIS MONTH</div>
        <div className="text-3xl font-bold mt-1">1,284 <span className="text-base text-muted-foreground">tCO₂e</span></div>
      </GlassCard>
      <GlassCard>
        <div className="text-[10px] font-mono tracking-widest text-muted-foreground">ON-CHAIN ANCHOR</div>
        <div className="text-mono text-sm font-bold mt-2 truncate">0xA7F4…29B1c8E2</div>
        <div className="text-[10px] text-success mt-1 font-mono">● ANCHORED · BLOCK 18,294,012</div>
      </GlassCard>
    </div>

    <GlassCard className="p-0">
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead className="text-[10px] font-mono text-muted-foreground tracking-widest border-b border-border/50">
            <tr>
              <th className="text-left p-3 pl-5">CREDIT ID</th>
              <th className="text-left p-3">HUB</th>
              <th className="text-right p-3">tCO₂e</th>
              <th className="text-left p-3">ISSUE DATE</th>
              <th className="text-left p-3">VERIFIER</th>
              <th className="text-left p-3">STATUS</th>
              <th className="text-right p-3 pr-5">CERT</th>
            </tr>
          </thead>
          <tbody>
            {credits.map((c) => (
              <tr key={c.id} className="border-b border-border/40 hover:bg-secondary/30">
                <td className="p-3 pl-5 text-mono text-xs flex items-center gap-2">
                  <Hash className="h-3 w-3 text-accent" /> {c.id}
                </td>
                <td className="p-3">{c.hub}</td>
                <td className="p-3 text-right text-mono">{c.amount}</td>
                <td className="p-3 text-mono text-xs text-muted-foreground">{c.date}</td>
                <td className="p-3">{c.verifier}</td>
                <td className="p-3">
                  <span className={`inline-flex items-center gap-1.5 text-[11px] font-mono px-2 py-0.5 rounded-md ${
                    c.status === "Verified" ? "bg-success/15 text-success" : "bg-warning/15 text-warning"
                  }`}>
                    {c.status === "Verified" && <ShieldCheck className="h-3 w-3" />}
                    {c.status}
                  </span>
                </td>
                <td className="p-3 pr-5 text-right">
                  <Button variant="ghost" size="sm" className="h-7 text-xs"><Download className="h-3 w-3" /></Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </GlassCard>
  </div>
);

export default Ledger;
