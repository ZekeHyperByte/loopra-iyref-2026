import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { motion } from "framer-motion";
import { useState } from "react";
import { MapPin, Activity, Zap } from "lucide-react";

// approximate normalized coordinates over Indonesian archipelago (0-100)
const hubs = [
  { id: 1, name: "Medan Belawan", x: 14, y: 32, capacity: 64, ethanol: 98400, grade: "B", status: "active" },
  { id: 2, name: "Lampung Selatan", x: 30, y: 56, capacity: 87, ethanol: 184500, grade: "A", status: "active" },
  { id: 3, name: "Sidoarjo Timur", x: 50, y: 68, capacity: 82, ethanol: 162300, grade: "A", status: "active" },
  { id: 4, name: "Banyuwangi", x: 56, y: 72, capacity: 74, ethanol: 128400, grade: "A", status: "active" },
  { id: 5, name: "Pontianak Barat", x: 48, y: 48, capacity: 51, ethanol: 76200, grade: "B", status: "maintenance" },
  { id: 6, name: "Makassar Hub", x: 66, y: 62, capacity: 78, ethanol: 142800, grade: "A", status: "active" },
  { id: 7, name: "Manado Utara", x: 76, y: 44, capacity: 69, ethanol: 84600, grade: "A", status: "active" },
  { id: 8, name: "Jayapura", x: 92, y: 60, capacity: 42, ethanol: 38200, grade: "B", status: "active" },
  { id: 9, name: "Kupang NTT", x: 76, y: 80, capacity: 58, ethanol: 64800, grade: "A", status: "active" },
];

const Network = () => {
  const [active, setActive] = useState(hubs[1]);
  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise Portal · Geospatial"
        title="National Hub Network"
        description="Live topology of the Loopra renewable energy logistics network across the Indonesian archipelago."
      />
      <div className="grid lg:grid-cols-[1.6fr_1fr] gap-4">
        <GlassCard className="p-0 overflow-hidden relative aspect-[16/10]">
          <div className="absolute inset-0 grid-bg opacity-40" />
          {/* faux archipelago shapes */}
          <svg viewBox="0 0 100 100" className="absolute inset-0 w-full h-full" preserveAspectRatio="none">
            <defs>
              <radialGradient id="archGrad" cx="50%" cy="50%">
                <stop offset="0%" stopColor="hsl(182 60% 25% / 0.7)" />
                <stop offset="100%" stopColor="hsl(180 30% 8% / 0)" />
              </radialGradient>
            </defs>
            <ellipse cx="22" cy="36" rx="14" ry="6" fill="url(#archGrad)" />
            <ellipse cx="48" cy="60" rx="22" ry="5" fill="url(#archGrad)" />
            <ellipse cx="50" cy="48" rx="14" ry="9" fill="url(#archGrad)" />
            <ellipse cx="68" cy="58" rx="10" ry="7" fill="url(#archGrad)" />
            <ellipse cx="78" cy="48" rx="6" ry="5" fill="url(#archGrad)" />
            <ellipse cx="90" cy="62" rx="9" ry="6" fill="url(#archGrad)" />
            <ellipse cx="78" cy="78" rx="7" ry="3" fill="url(#archGrad)" />
            {/* connection lines */}
            {hubs.map((h, i) =>
              i < hubs.length - 1 ? (
                <line key={i} x1={h.x} y1={h.y} x2={hubs[i + 1].x} y2={hubs[i + 1].y}
                  stroke="hsl(182 97% 50% / 0.18)" strokeWidth={0.15} strokeDasharray="0.6 0.6" />
              ) : null
            )}
          </svg>

          {hubs.map((h) => (
            <button
              key={h.id}
              onClick={() => setActive(h)}
              className="absolute -translate-x-1/2 -translate-y-1/2"
              style={{ left: `${h.x}%`, top: `${h.y}%` }}
            >
              <div className="relative">
                <span className={`absolute inset-0 rounded-full animate-pulse-dot ${
                  h.status === "maintenance" ? "bg-warning/40" : "bg-accent/50"
                }`} style={{ width: 18, height: 18, marginLeft: -3, marginTop: -3 }} />
                <span className={`block h-3 w-3 rounded-full ring-2 ring-background relative ${
                  h.status === "maintenance" ? "bg-warning" : active.id === h.id ? "bg-accent shadow-[0_0_16px_hsl(75_100%_50%)]" : "bg-primary-glow"
                }`} />
              </div>
              {active.id === h.id && (
                <div className="absolute left-4 top-2 glass-strong rounded-md px-2 py-0.5 text-[10px] font-mono whitespace-nowrap">
                  {h.name}
                </div>
              )}
            </button>
          ))}
          <div className="absolute bottom-3 left-3 glass rounded-md px-3 py-2 text-[10px] font-mono text-muted-foreground tracking-wider">
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1.5"><span className="h-1.5 w-1.5 rounded-full bg-accent" /> ACTIVE</span>
              <span className="flex items-center gap-1.5"><span className="h-1.5 w-1.5 rounded-full bg-warning" /> MAINTENANCE</span>
            </div>
          </div>
          <div className="absolute top-3 right-3 glass rounded-md px-3 py-1.5 text-[10px] font-mono">
            <span className="text-accent">●</span> LAT/LON · LIVE
          </div>
        </GlassCard>

        <motion.div key={active.id} initial={{ opacity: 0, x: 12 }} animate={{ opacity: 1, x: 0 }}>
          <GlassCard strong className="h-full">
            <div className="flex items-start justify-between">
              <div>
                <div className="text-[10px] font-mono text-accent tracking-widest">HUB DETAIL</div>
                <h3 className="text-2xl font-bold mt-1">{active.name}</h3>
                <div className="text-xs text-muted-foreground font-mono mt-1">ID · LPR-{String(active.id).padStart(4, "0")}</div>
              </div>
              <span className={`text-[11px] font-mono px-2 py-1 rounded-md ${
                active.grade === "A" ? "bg-accent/15 text-accent" : "bg-warning/15 text-warning"
              }`}>GRADE {active.grade}</span>
            </div>

            <div className="mt-6 space-y-4">
              <div>
                <div className="flex items-center justify-between mb-1.5">
                  <span className="text-xs text-muted-foreground">Capacity Utilization</span>
                  <span className="text-mono text-sm font-bold">{active.capacity}%</span>
                </div>
                <div className="h-2 rounded-full bg-secondary overflow-hidden">
                  <motion.div initial={{ width: 0 }} animate={{ width: `${active.capacity}%` }}
                    className="h-full bg-gradient-to-r from-primary to-accent" />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="glass rounded-xl p-3">
                  <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground tracking-widest">
                    <Zap className="h-3 w-3" /> ETHANOL
                  </div>
                  <div className="text-mono text-xl font-bold mt-1">{active.ethanol.toLocaleString()}<span className="text-xs text-muted-foreground"> L</span></div>
                </div>
                <div className="glass rounded-xl p-3">
                  <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground tracking-widest">
                    <Activity className="h-3 w-3" /> STATUS
                  </div>
                  <div className={`text-sm font-bold mt-1.5 capitalize ${active.status === "active" ? "text-success" : "text-warning"}`}>
                    {active.status}
                  </div>
                </div>
              </div>

              <div className="glass rounded-xl p-3">
                <div className="text-[10px] font-mono text-muted-foreground tracking-widest mb-2">TECHNICAL ASSAY</div>
                <div className="space-y-2">
                  {[
                    { k: "Sucrose Density", v: "18.4 °Bx" },
                    { k: "Moisture Content", v: "12.1 %" },
                    { k: "Lignocellulose", v: active.grade === "A" ? "Optimal" : "Marginal" },
                    { k: "Last Audit", v: "2h ago" },
                  ].map((r) => (
                    <div key={r.k} className="flex justify-between text-xs">
                      <span className="text-muted-foreground">{r.k}</span>
                      <span className="text-mono">{r.v}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </GlassCard>
        </motion.div>
      </div>
    </div>
  );
};

export default Network;
