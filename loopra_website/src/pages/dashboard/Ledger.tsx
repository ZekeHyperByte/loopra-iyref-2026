import { useMemo, useState } from "react";
import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Download, ShieldCheck, Hash, Search } from "lucide-react";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { sumCarbonPrevented } from "@/lib/wasteDeposits";
import { getTotalEnergyCreditsFromDeposits } from "@/lib/energyCredits";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";

const credits = Array.from({ length: 12 }, (_, i) => ({
  id: `LPR-VCC-${(202600 + i).toString(16).toUpperCase()}`,
  hub: ["Lampung", "Sidoarjo", "Makassar", "Banyuwangi"][i % 4],
  amount: (240 + i * 14).toFixed(2),
  date: `2026-04-${String(28 - i).padStart(2, "0")}`,
  verifier: ["Verra", "Gold Standard", "Verra", "ISCC"][i % 4],
  status: i % 5 === 4 ? "Pending" : "Verified",
}));

const Ledger = () => {
  const { rows, loading } = useDashboardData();
  const [filter, setFilter] = useState("");
  const [esgOpen, setEsgOpen] = useState(false);

  const carbonTotal = useMemo(() => sumCarbonPrevented(rows), [rows]);
  const ecTotal = useMemo(() => getTotalEnergyCreditsFromDeposits(rows), [rows]);

  const esgSummary = useMemo(() => {
    const lines = [
      "Loopra — ESG impact summary (from waste_deposits)",
      `Total carbon prevented (reported): ${carbonTotal.toLocaleString(undefined, { maximumFractionDigits: 2 })} tCO₂e`,
      `Total energy credits accrued: ${Math.round(ecTotal).toLocaleString()} EC`,
      `Rows analyzed: ${rows.length}`,
      "",
      "Figures reflect aggregated fields carbon_prevented_tco2e / carbon_prevented and ec_earned.",
    ];
    return lines.join("\n");
  }, [carbonTotal, ecTotal, rows.length]);

  const downloadTextSummary = () => {
    const blob = new Blob([esgSummary], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `loopra-esg-summary-${new Date().toISOString().slice(0, 10)}.txt`;
    a.click();
    URL.revokeObjectURL(url);
    toast.success("Summary file downloaded.");
  };

  const filteredCredits = credits.filter(
    (c) =>
      !filter.trim() ||
      c.id.toLowerCase().includes(filter.toLowerCase()) ||
      c.hub.toLowerCase().includes(filter.toLowerCase()) ||
      c.verifier.toLowerCase().includes(filter.toLowerCase()),
  );

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise · ESG"
        title="Digital Carbon Ledger"
        description="Cryptographically signed credits — with live carbon totals from operational deposits."
      >
        <div className="flex items-center gap-2 glass rounded-lg px-3 py-1.5 w-64">
          <Search className="h-3.5 w-3.5 text-muted-foreground" />
          <input
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            placeholder="Filter by ID, hub, verifier…"
            className="bg-transparent text-xs outline-none flex-1"
          />
        </div>
        <Dialog open={esgOpen} onOpenChange={setEsgOpen}>
          <Button
            size="sm"
            className="bg-accent text-accent-foreground hover:bg-accent/90"
            onClick={() => setEsgOpen(true)}
          >
            <Download className="h-3.5 w-3.5 mr-1.5" /> Download ESG Report
          </Button>
          <DialogContent className="max-w-md border-border/60 bg-card">
            <DialogHeader>
              <DialogTitle>ESG impact summary</DialogTitle>
              <DialogDescription>
                Totals are computed from the <span className="text-mono">waste_deposits</span> table in Supabase.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-3 text-sm">
              <div className="glass rounded-xl p-4 border border-border/50">
                <div className="text-[10px] font-mono text-muted-foreground tracking-widest">CARBON PREVENTED</div>
                <div className="text-2xl font-bold text-gradient-lime mt-1">
                  {carbonTotal.toLocaleString(undefined, { maximumFractionDigits: 2 })}{" "}
                  <span className="text-base text-muted-foreground">tCO₂e</span>
                </div>
              </div>
              <div className="glass rounded-xl p-4 border border-border/50">
                <div className="text-[10px] font-mono text-muted-foreground tracking-widest">ENERGY CREDITS (EC)</div>
                <div className="text-2xl font-bold mt-1 text-mono">{Math.round(ecTotal).toLocaleString()}</div>
              </div>
              <pre className="text-[11px] font-mono text-muted-foreground whitespace-pre-wrap bg-secondary/50 rounded-lg p-3 max-h-40 overflow-auto border border-border/40">
                {esgSummary}
              </pre>
              <div className="flex gap-2 justify-end">
                <Button variant="outline" size="sm" onClick={() => setEsgOpen(false)}>
                  Close
                </Button>
                <Button size="sm" className="bg-primary" onClick={downloadTextSummary}>
                  Save as .txt
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </PageHeader>

      <div className="grid sm:grid-cols-3 gap-4">
        {loading ? (
          <>
            <Skeleton className="h-28 rounded-2xl" />
            <Skeleton className="h-28 rounded-2xl" />
            <Skeleton className="h-28 rounded-2xl" />
          </>
        ) : (
          <>
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">CARBON PREVENTED (DB)</div>
              <div className="text-3xl font-bold mt-1 text-gradient-lime">
                {carbonTotal.toLocaleString(undefined, { maximumFractionDigits: 1 })}{" "}
                <span className="text-base text-muted-foreground">tCO₂e</span>
              </div>
            </GlassCard>
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">ENERGY CREDITS</div>
              <div className="text-3xl font-bold mt-1">{Math.round(ecTotal).toLocaleString()} EC</div>
            </GlassCard>
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">ON-CHAIN ANCHOR</div>
              <div className="text-mono text-sm font-bold mt-2 truncate">0xA7F4…29B1c8E2</div>
              <div className="text-[10px] text-success mt-1 font-mono">● ANCHORED · BLOCK 18,294,012</div>
            </GlassCard>
          </>
        )}
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
              {filteredCredits.map((c) => (
                <tr key={c.id} className="border-b border-border/40 hover:bg-secondary/30">
                  <td className="p-3 pl-5 text-mono text-xs flex items-center gap-2">
                    <Hash className="h-3 w-3 text-accent" /> {c.id}
                  </td>
                  <td className="p-3">{c.hub}</td>
                  <td className="p-3 text-right text-mono">{c.amount}</td>
                  <td className="p-3 text-mono text-xs text-muted-foreground">{c.date}</td>
                  <td className="p-3">{c.verifier}</td>
                  <td className="p-3">
                    <span
                      className={`inline-flex items-center gap-1.5 text-[11px] font-mono px-2 py-0.5 rounded-md ${
                        c.status === "Verified" ? "bg-success/15 text-success" : "bg-warning/15 text-warning"
                      }`}
                    >
                      {c.status === "Verified" && <ShieldCheck className="h-3 w-3" />}
                      {c.status}
                    </span>
                  </td>
                  <td className="p-3 pr-5 text-right">
                    <Button variant="ghost" size="sm" className="h-7 text-xs">
                      <Download className="h-3 w-3" />
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </GlassCard>
    </div>
  );
};

export default Ledger;
