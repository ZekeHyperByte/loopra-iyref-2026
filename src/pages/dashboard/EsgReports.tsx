import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Button } from "@/components/ui/button";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { sumCarbonPrevented } from "@/lib/wasteDeposits";
import { getTotalEnergyCreditsFromDeposits } from "@/lib/energyCredits";
import { useMemo, useState } from "react";
import { Download } from "lucide-react";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";

const EsgReports = () => {
  const { rows, loading } = useDashboardData();
  const [open, setOpen] = useState(false);

  const carbon = useMemo(() => sumCarbonPrevented(rows), [rows]);
  const ec = useMemo(() => getTotalEnergyCreditsFromDeposits(rows), [rows]);

  const summary = useMemo(() => {
    const lines = [
      "Loopra — ESG summary",
      `Carbon prevented (reported): ${carbon.toLocaleString(undefined, { maximumFractionDigits: 2 })} tCO₂e`,
      `Energy credits: ${Math.round(ec).toLocaleString()} EC`,
      `Deposits in view: ${rows.length}`,
    ];
    return lines.join("\n");
  }, [carbon, ec, rows.length]);

  const downloadTxt = () => {
    const blob = new Blob([summary], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `loopra-esg-${new Date().toISOString().slice(0, 10)}.txt`;
    a.click();
    URL.revokeObjectURL(url);
    toast.success("Report downloaded.");
  };

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise · ESG"
        title="ESG reports"
        description="Executive-ready totals from operational deposits. Export a text summary for auditors."
      >
        <Button size="sm" className="bg-accent text-accent-foreground" onClick={() => setOpen(true)}>
          <Download className="h-3.5 w-3.5 mr-1.5" /> Generate summary
        </Button>
      </PageHeader>

      {loading ? (
        <div className="grid sm:grid-cols-2 gap-4">
          <Skeleton className="h-32 rounded-2xl" />
          <Skeleton className="h-32 rounded-2xl" />
        </div>
      ) : (
        <div className="grid sm:grid-cols-2 gap-4">
          <GlassCard>
            <div className="text-[10px] font-mono tracking-widest text-muted-foreground">CARBON PREVENTED</div>
            <div className="text-3xl font-bold text-gradient-lime mt-1">
              {carbon.toLocaleString(undefined, { maximumFractionDigits: 1 })}{" "}
              <span className="text-base text-muted-foreground">tCO₂e</span>
            </div>
          </GlassCard>
          <GlassCard>
            <div className="text-[10px] font-mono tracking-widest text-muted-foreground">ENERGY CREDITS</div>
            <div className="text-3xl font-bold mt-1 text-mono">{Math.round(ec).toLocaleString()} EC</div>
          </GlassCard>
        </div>
      )}

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>ESG summary</DialogTitle>
            <DialogDescription>Figures from connected waste deposit telemetry.</DialogDescription>
          </DialogHeader>
          <pre className="text-xs font-mono bg-secondary/50 rounded-lg p-4 whitespace-pre-wrap border border-border/40">
            {summary}
          </pre>
          <div className="flex justify-end gap-2">
            <Button variant="outline" size="sm" onClick={() => setOpen(false)}>
              Close
            </Button>
            <Button size="sm" onClick={downloadTxt}>
              Save .txt
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default EsgReports;
