import { useEffect, useMemo, useState } from "react";
import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { GradeBadge } from "@/components/dashboard/GradeBadge";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { supabase } from "@/lib/supabase";
import {
  formatYieldEstimate,
  getContributorDisplayName,
  getHubLabel,
  getRecordedAt,
  getValidationStatusDisplay,
} from "@/lib/wasteDeposits";
import type { WasteDepositRow } from "@/types/waste-deposits";
import { Check, X, Smartphone, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { format } from "date-fns";
import { cn } from "@/lib/utils";

const isDemoRowId = (id: string) => id.startsWith("demo-");

type DemoStatus = "Verified" | "Rejected";

function statusBadgeClass(status: ReturnType<typeof getValidationStatusDisplay> | DemoStatus) {
  if (status === "Verified") return "bg-emerald-500/15 text-emerald-200 border-emerald-500/30";
  if (status === "Rejected") return "bg-destructive/15 text-destructive border-destructive/30";
  return "bg-amber-500/12 text-amber-100 border-amber-500/25";
}

const DepositReview = () => {
  const { rows, loading, refetch, isDemoData } = useDashboardData();
  const [busyId, setBusyId] = useState<string | null>(null);
  const [demoStatusOverride, setDemoStatusOverride] = useState<Record<string, DemoStatus>>({});

  useEffect(() => {
    if (!isDemoData) setDemoStatusOverride({});
  }, [isDemoData]);

  const displayStatus = (r: WasteDepositRow) => {
    const id = r.id ?? "";
    if (id && demoStatusOverride[id]) return demoStatusOverride[id];
    return getValidationStatusDisplay(r);
  };

  const tableRows = useMemo(() => {
    const sorted = [...rows].sort((a, b) => (getRecordedAt(b)?.getTime() ?? 0) - (getRecordedAt(a)?.getTime() ?? 0));
    return sorted.slice(0, 80);
  }, [rows]);

  const updateStatus = async (id: string, status: "approved" | "rejected") => {
    if (!id) return;
    if (isDemoData && isDemoRowId(id)) {
      setDemoStatusOverride((prev) => ({
        ...prev,
        [id]: status === "approved" ? "Verified" : "Rejected",
      }));
      toast.success(
        status === "approved" ? "Demo: marked verified (not persisted)." : "Demo: marked rejected (not persisted).",
      );
      return;
    }
    setBusyId(id);
    try {
      const { error } = await supabase.from("waste_deposits").update({ validation_status: status }).eq("id", id);
      if (error) {
        toast.error(error.message);
        return;
      }
      toast.success(status === "approved" ? "Deposit approved." : "Deposit rejected.");
      await refetch();
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="p-6 space-y-6 relative min-h-[400px]">
      <PageHeader
        eyebrow="Operations · Mobile"
        title="Deposit validation"
        description="Incoming scans from the mobile app: contributor, asset, AI grade, yield readout, and QC status. Approve or reject to simulate industrial quality control."
      />

      {loading ? (
        <div className="space-y-3">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-28 w-full rounded-2xl" />
          ))}
        </div>
      ) : tableRows.length === 0 ? (
        <GlassCard className="text-center py-14 text-muted-foreground">
          <Smartphone className="h-10 w-10 mx-auto text-accent mb-3 opacity-80" />
          <p className="text-sm">No deposit rows in view. Sync waste_deposits or use demo data when the table is empty.</p>
        </GlassCard>
      ) : (
        <GlassCard className="p-0 overflow-hidden">
          <div className="px-5 py-4 border-b border-border/50 flex flex-wrap items-center justify-between gap-2">
            <div>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">MOBILE SCAN QUEUE</div>
              <h2 className="font-semibold text-sm mt-0.5">Latest {tableRows.length} deposits</h2>
            </div>
            {isDemoData && (
              <span className="text-[10px] font-mono text-warning border border-warning/30 rounded-md px-2 py-1">
                Demo · QC actions are local only
              </span>
            )}
          </div>
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow className="hover:bg-transparent border-border/50">
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground min-w-[140px]">
                    Contributor
                  </TableHead>
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground min-w-[160px]">
                    Asset type
                  </TableHead>
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground">AI grade</TableHead>
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground min-w-[200px]">
                    Yield estimate
                  </TableHead>
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground">Status</TableHead>
                  <TableHead className="text-[10px] font-mono tracking-wider text-muted-foreground text-right min-w-[100px]">
                    Hub · time
                  </TableHead>
                  <TableHead className="text-right text-[10px] font-mono tracking-wider text-muted-foreground w-[200px]">
                    QC
                  </TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {tableRows.map((r) => {
                  const id = r.id ?? "";
                  const t = getRecordedAt(r);
                  const status = displayStatus(r);
                  const pending = status === "Pending";
                  const busy = busyId === id;
                  return (
                    <TableRow key={id || `${getContributorDisplayName(r)}-${t?.toISOString()}`} className="border-border/40">
                      <TableCell className="font-medium text-sm">{getContributorDisplayName(r)}</TableCell>
                      <TableCell>
                        <span className="text-sm text-accent">{r.asset_type ?? "—"}</span>
                      </TableCell>
                      <TableCell>
                        <GradeBadge row={r} />
                      </TableCell>
                      <TableCell className="text-xs font-mono text-muted-foreground whitespace-nowrap">
                        {formatYieldEstimate(r)}
                      </TableCell>
                      <TableCell>
                        <span
                          className={cn(
                            "inline-flex text-[10px] font-mono uppercase tracking-wide px-2 py-0.5 rounded-md border",
                            statusBadgeClass(status),
                          )}
                        >
                          {status}
                        </span>
                      </TableCell>
                      <TableCell className="text-right text-xs text-muted-foreground">
                        <div className="font-medium text-foreground/90">{getHubLabel(r)}</div>
                        {t && <div className="font-mono text-[10px] mt-0.5">{format(t, "yyyy-MM-dd HH:mm")}</div>}
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="inline-flex flex-wrap justify-end gap-2">
                          <Button
                            variant="outline"
                            size="sm"
                            className="h-8 border-destructive/40 text-destructive"
                            disabled={busy || !id || !pending}
                            onClick={() => updateStatus(id, "rejected")}
                          >
                            {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <X className="h-4 w-4" />}
                            Reject
                          </Button>
                          <Button
                            size="sm"
                            className="h-8 bg-accent text-accent-foreground"
                            disabled={busy || !id || !pending}
                            onClick={() => updateStatus(id, "approved")}
                          >
                            {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
                            Approve
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </div>
        </GlassCard>
      )}
    </div>
  );
};

export default DepositReview;
