import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Button } from "@/components/ui/button";
import { Check, Flag, Camera, Cpu } from "lucide-react";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";

const initial = [
  { id: "ASY-2401", hub: "Lampung Selatan", op: "Ahmad S.", weight: 184.2, ai: 96, suggested: "A", notes: "Sucrose density nominal, low moisture." },
  { id: "ASY-2402", hub: "Sidoarjo Timur", op: "Rina W.", weight: 96.8, ai: 71, suggested: "B", notes: "Mixed feedstock detected — partial lignocellulose excess." },
  { id: "ASY-2403", hub: "Makassar Hub", op: "Budi P.", weight: 220.4, ai: 94, suggested: "A", notes: "Optimal sugar content. Recommend fast-track." },
  { id: "ASY-2404", hub: "Medan Belawan", op: "Sari L.", weight: 142.0, ai: 58, suggested: "B", notes: "AI confidence below threshold — manual review advised." },
  { id: "ASY-2405", hub: "Banyuwangi", op: "Joko T.", weight: 178.9, ai: 91, suggested: "A", notes: "Standardization within tolerance." },
];

const AssayValidation = () => {
  const [items, setItems] = useState(initial);
  const remove = (id: string, action: "flag" | "approve") => {
    setItems((x) => x.filter((i) => i.id !== id));
    toast.success(action === "approve" ? "Assay approved." : "Assay flagged for review.");
  };

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Operations · Quality"
        title="Assay Validation Queue"
        description="Approve or flag mobile-AI feedstock assays to enforce industrial standardization."
      />
      <div className="grid sm:grid-cols-3 gap-4">
        {[
          { k: "Pending Review", v: items.length, c: "text-accent" },
          { k: "Approved Today", v: 348, c: "text-success" },
          { k: "Flagged Today", v: 12, c: "text-destructive" },
        ].map((s) => (
          <GlassCard key={s.k}>
            <div className="text-[10px] font-mono tracking-widest text-muted-foreground">{s.k.toUpperCase()}</div>
            <div className={`text-3xl font-bold text-mono mt-1 ${s.c}`}>{s.v}</div>
          </GlassCard>
        ))}
      </div>

      <div className="space-y-3">
        <AnimatePresence>
          {items.map((a) => (
            <motion.div
              key={a.id}
              layout
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, x: -40 }}
            >
              <GlassCard className="grid md:grid-cols-[auto_1fr_auto_auto] gap-4 items-center">
                <div className="h-14 w-14 rounded-xl bg-secondary grid place-items-center relative overflow-hidden">
                  <Camera className="h-5 w-5 text-accent" />
                  <span className="absolute bottom-0 inset-x-0 h-1 bg-accent animate-scan" />
                </div>
                <div>
                  <div className="flex items-center flex-wrap gap-2">
                    <span className="text-mono text-sm font-bold">{a.id}</span>
                    <span className="text-xs text-muted-foreground">{a.hub} · {a.op}</span>
                    <span className={`text-[10px] font-mono px-2 py-0.5 rounded-md ${
                      a.suggested === "A" ? "bg-accent/15 text-accent" : "bg-warning/15 text-warning"
                    }`}>SUGGESTED · GRADE {a.suggested}</span>
                  </div>
                  <div className="text-xs text-muted-foreground mt-1">{a.notes}</div>
                  <div className="flex items-center gap-4 mt-2 text-xs text-mono">
                    <span><span className="text-muted-foreground">Weight</span> · {a.weight} kg</span>
                    <span className="flex items-center gap-1.5">
                      <Cpu className="h-3 w-3 text-accent" />
                      <span className="text-muted-foreground">AI Confidence</span>
                      <span className={a.ai >= 80 ? "text-success" : "text-warning"}>{a.ai}%</span>
                    </span>
                  </div>
                </div>
                <Button onClick={() => remove(a.id, "flag")} size="sm" variant="outline" className="border-warning/40 text-warning hover:bg-warning/10">
                  <Flag className="h-3.5 w-3.5 mr-1" /> Flag
                </Button>
                <Button onClick={() => remove(a.id, "approve")} size="sm" className="bg-accent text-accent-foreground hover:bg-accent/90">
                  <Check className="h-3.5 w-3.5 mr-1" /> Approve
                </Button>
              </GlassCard>
            </motion.div>
          ))}
        </AnimatePresence>
        {items.length === 0 && (
          <GlassCard className="text-center py-12 text-muted-foreground">
            <Check className="h-8 w-8 mx-auto text-success mb-2" />
            Queue cleared — all assays validated.
          </GlassCard>
        )}
      </div>
    </div>
  );
};

export default AssayValidation;
