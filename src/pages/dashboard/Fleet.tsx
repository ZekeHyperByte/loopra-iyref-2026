import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Truck, Navigation, Clock, CheckCircle2, AlertTriangle } from "lucide-react";
import { motion } from "framer-motion";

const trucks = [
  { id: "LPR-T142", route: "Lampung → Cilacap Refinery", cargo: "Crude Ethanol · 24,000 L", eta: "02:12", progress: 78, status: "on-route" },
  { id: "LPR-T087", route: "Sidoarjo → Surabaya Port", cargo: "Bio-CH₄ · 12,400 m³", eta: "00:48", progress: 92, status: "on-route" },
  { id: "LPR-T203", route: "Makassar → Pare-Pare", cargo: "Bio-fertilizer · 18 t", eta: "04:30", progress: 24, status: "on-route" },
  { id: "LPR-T056", route: "Medan → Belawan Port", cargo: "Crude Ethanol · 16,800 L", eta: "—", progress: 100, status: "delivered" },
  { id: "LPR-T119", route: "Pontianak → West KAL Hub", cargo: "Feedstock · 32 t", eta: "06:18", progress: 12, status: "rerouted" },
  { id: "LPR-T078", route: "Banyuwangi → Surabaya", cargo: "Crude Ethanol · 21,000 L", eta: "01:54", progress: 64, status: "on-route" },
];

const statusMeta: Record<string, { color: string; Icon: any; label: string }> = {
  "on-route": { color: "text-accent bg-accent/15", Icon: Navigation, label: "EN ROUTE" },
  delivered: { color: "text-success bg-success/15", Icon: CheckCircle2, label: "DELIVERED" },
  rerouted: { color: "text-warning bg-warning/15", Icon: AlertTriangle, label: "RE-ROUTED" },
};

const Fleet = () => (
  <div className="p-6 space-y-6">
    <PageHeader
      eyebrow="Operations · Logistics"
      title="Fleet Control"
      description="Real-time route optimization across the renewable energy logistics network."
    />
    <div className="grid sm:grid-cols-4 gap-4">
      {[
        { k: "Active Vehicles", v: "284", c: "text-accent" },
        { k: "Routes Optimized", v: "98.4%", c: "text-success" },
        { k: "Fuel Efficiency", v: "+14.2%", c: "text-gradient-lime" },
        { k: "Avg ETA Variance", v: "±03:24", c: "" },
      ].map((s) => (
        <GlassCard key={s.k}>
          <div className="text-[10px] font-mono tracking-widest text-muted-foreground">{s.k.toUpperCase()}</div>
          <div className={`text-2xl font-bold mt-1 text-mono ${s.c}`}>{s.v}</div>
        </GlassCard>
      ))}
    </div>

    <div className="space-y-3">
      {trucks.map((t, i) => {
        const m = statusMeta[t.status];
        return (
          <motion.div
            key={t.id}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: i * 0.05 }}
          >
            <GlassCard className="grid md:grid-cols-[auto_1fr_auto] gap-4 items-center">
              <div className="h-12 w-12 rounded-xl bg-secondary grid place-items-center">
                <Truck className="h-5 w-5 text-accent" />
              </div>
              <div>
                <div className="flex items-center gap-3">
                  <span className="text-mono text-sm font-bold">{t.id}</span>
                  <span className={`text-[10px] font-mono px-2 py-0.5 rounded-md inline-flex items-center gap-1 ${m.color}`}>
                    <m.Icon className="h-3 w-3" /> {m.label}
                  </span>
                </div>
                <div className="text-sm mt-0.5">{t.route}</div>
                <div className="text-xs text-muted-foreground mt-0.5">{t.cargo}</div>
                <div className="mt-2.5 h-1.5 rounded-full bg-secondary overflow-hidden max-w-md">
                  <motion.div
                    initial={{ width: 0 }}
                    animate={{ width: `${t.progress}%` }}
                    transition={{ duration: 1.2 }}
                    className={`h-full ${t.status === "rerouted" ? "bg-warning" : t.status === "delivered" ? "bg-success" : "bg-gradient-to-r from-primary to-accent"}`}
                  />
                </div>
              </div>
              <div className="text-right">
                <div className="text-[10px] font-mono text-muted-foreground tracking-widest flex items-center justify-end gap-1">
                  <Clock className="h-3 w-3" /> ETA
                </div>
                <div className="text-mono text-xl font-bold mt-1">{t.eta}</div>
              </div>
            </GlassCard>
          </motion.div>
        );
      })}
    </div>
  </div>
);

export default Fleet;
