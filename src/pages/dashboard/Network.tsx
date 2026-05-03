import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { motion } from "framer-motion";
import { useMemo, useState } from "react";
import { MapPin, Activity, Zap } from "lucide-react";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { aggregateHubs, hubMapCoords } from "@/lib/wasteDeposits";
import { Skeleton } from "@/components/ui/skeleton";
import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { buildSevenDaySupplyTrend } from "@/lib/wasteDeposits";

type HubVm = {
  id: number;
  name: string;
  x: number;
  y: number;
  capacity: number;
  ethanol: number;
  grade: "A" | "B";
  status: "active" | "maintenance";
};

const Network = () => {
  const { rows, loading, error } = useDashboardData();

  const hubs = useMemo<HubVm[]>(() => {
    const agg = aggregateHubs(rows, 24);
    return agg.map((h, i) => {
      const { x, y } = hubMapCoords(h.name);
      return {
        id: i + 1,
        name: h.name,
        x,
        y,
        capacity: Math.max(12, Math.min(98, h.util || 50)),
        ethanol: h.ethanol,
        grade: h.grade,
        status: h.util < 35 ? "maintenance" : "active",
      };
    });
  }, [rows]);

  const [active, setActive] = useState<HubVm | null>(null);

  const miniTrend = useMemo(() => buildSevenDaySupplyTrend(rows), [rows]);

  const selected = useMemo(() => {
    if (!hubs.length) return null;
    if (active && hubs.some((h) => h.id === active.id)) {
      return hubs.find((h) => h.id === active.id)!;
    }
    return hubs[0];
  }, [hubs, active]);

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise · Geospatial"
        title="National Hub Network"
        description="Hub markers and throughput are derived from aggregated waste_deposits."
      />

      {error && (
        <div className="rounded-lg border border-destructive/40 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          {error}
        </div>
      )}

      {loading ? (
        <Skeleton className="h-[480px] w-full rounded-2xl" />
      ) : hubs.length === 0 ? (
        <GlassCard className="py-16 text-center text-muted-foreground">
          No hub locations yet — add rows with hub_name to waste_deposits.
        </GlassCard>
      ) : (
        <div className="grid lg:grid-cols-[1.6fr_1fr] gap-4">
          <GlassCard className="p-0 overflow-hidden relative aspect-[16/10]">
            <div className="absolute inset-0 grid-bg opacity-40" />
            <svg viewBox="0 0 100 100" className="absolute inset-0 w-full h-full" preserveAspectRatio="none">
              <defs>
                <radialGradient id="archGradNet" cx="50%" cy="50%">
                  <stop offset="0%" stopColor="hsl(182 60% 25% / 0.7)" />
                  <stop offset="100%" stopColor="hsl(180 30% 8% / 0)" />
                </radialGradient>
              </defs>
              <ellipse cx="22" cy="36" rx="14" ry="6" fill="url(#archGradNet)" />
              <ellipse cx="48" cy="60" rx="22" ry="5" fill="url(#archGradNet)" />
              <ellipse cx="50" cy="48" rx="14" ry="9" fill="url(#archGradNet)" />
              <ellipse cx="68" cy="58" rx="10" ry="7" fill="url(#archGradNet)" />
              <ellipse cx="78" cy="48" rx="6" ry="5" fill="url(#archGradNet)" />
              <ellipse cx="90" cy="62" rx="9" ry="6" fill="url(#archGradNet)" />
              <ellipse cx="78" cy="78" rx="7" ry="3" fill="url(#archGradNet)" />
              {hubs.map((h, i) =>
                i < hubs.length - 1 ? (
                  <line
                    key={`ln-${h.id}`}
                    x1={h.x}
                    y1={h.y}
                    x2={hubs[i + 1].x}
                    y2={hubs[i + 1].y}
                    stroke="hsl(182 97% 50% / 0.18)"
                    strokeWidth={0.15}
                    strokeDasharray="0.6 0.6"
                  />
                ) : null,
              )}
            </svg>

            {hubs.map((h) => (
              <button
                key={h.id}
                type="button"
                onClick={() => setActive(h)}
                className="absolute -translate-x-1/2 -translate-y-1/2"
                style={{ left: `${h.x}%`, top: `${h.y}%` }}
              >
                <div className="relative">
                  <span
                    className={`absolute inset-0 rounded-full animate-pulse-dot ${
                      h.status === "maintenance" ? "bg-warning/40" : "bg-accent/50"
                    }`}
                    style={{ width: 18, height: 18, marginLeft: -3, marginTop: -3 }}
                  />
                  <span
                    className={`block h-3 w-3 rounded-full ring-2 ring-background relative ${
                      h.status === "maintenance"
                        ? "bg-warning"
                        : selected?.id === h.id
                          ? "bg-accent shadow-[0_0_16px_hsl(75_100%_50%)]"
                          : "bg-primary-glow"
                    }`}
                  />
                </div>
                {selected?.id === h.id && (
                  <div className="absolute left-4 top-2 glass-strong rounded-md px-2 py-0.5 text-[10px] font-mono whitespace-nowrap">
                    {h.name}
                  </div>
                )}
              </button>
            ))}
            <div className="absolute bottom-3 left-3 glass rounded-md px-3 py-2 text-[10px] font-mono text-muted-foreground tracking-wider">
              <div className="flex items-center gap-3">
                <span className="flex items-center gap-1.5">
                  <span className="h-1.5 w-1.5 rounded-full bg-accent" /> ACTIVE
                </span>
                <span className="flex items-center gap-1.5">
                  <span className="h-1.5 w-1.5 rounded-full bg-warning" /> MAINTENANCE
                </span>
              </div>
            </div>
            <div className="absolute top-3 right-3 glass rounded-md px-3 py-1.5 text-[10px] font-mono">
              <span className="text-accent">●</span> FROM DEPOSITS
            </div>
          </GlassCard>

          <motion.div key={selected?.id} initial={{ opacity: 0, x: 12 }} animate={{ opacity: 1, x: 0 }}>
            {selected && (
              <GlassCard strong className="h-full">
                <div className="flex items-start justify-between">
                  <div>
                    <div className="text-[10px] font-mono text-accent tracking-widest">HUB DETAIL</div>
                    <h3 className="text-2xl font-bold mt-1">{selected.name}</h3>
                    <div className="text-xs text-muted-foreground font-mono mt-1">
                      ID · LPR-{String(selected.id).padStart(4, "0")}
                    </div>
                  </div>
                  <span
                    className={`text-[11px] font-mono px-2 py-1 rounded-md ${
                      selected.grade === "A" ? "bg-accent/15 text-accent" : "bg-warning/15 text-warning"
                    }`}
                  >
                    GRADE {selected.grade}
                  </span>
                </div>

                <div className="mt-6 space-y-4">
                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <span className="text-xs text-muted-foreground">Capacity Utilization</span>
                      <span className="text-mono text-sm font-bold">{selected.capacity}%</span>
                    </div>
                    <div className="h-2 rounded-full bg-secondary overflow-hidden">
                      <motion.div
                        initial={{ width: 0 }}
                        animate={{ width: `${selected.capacity}%` }}
                        className="h-full bg-gradient-to-r from-primary to-accent"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div className="glass rounded-xl p-3">
                      <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground tracking-widest">
                        <Zap className="h-3 w-3" /> ETHANOL
                      </div>
                      <div className="text-mono text-xl font-bold mt-1">
                        {selected.ethanol.toLocaleString()}
                        <span className="text-xs text-muted-foreground"> L</span>
                      </div>
                    </div>
                    <div className="glass rounded-xl p-3">
                      <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground tracking-widest">
                        <Activity className="h-3 w-3" /> STATUS
                      </div>
                      <div
                        className={`text-sm font-bold mt-1.5 capitalize ${
                          selected.status === "active" ? "text-success" : "text-warning"
                        }`}
                      >
                        {selected.status}
                      </div>
                    </div>
                  </div>

                  <div className="glass rounded-xl p-3">
                    <div className="text-[10px] font-mono text-muted-foreground tracking-widest mb-2">
                      7-D NETWORK SUPPLY (EC + YIELD)
                    </div>
                    <ResponsiveContainer width="100%" height={120}>
                      <AreaChart data={miniTrend} margin={{ left: 0, right: 0, top: 4, bottom: 0 }}>
                        <defs>
                          <linearGradient id="netMini" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stopColor="hsl(182 97% 45%)" stopOpacity={0.35} />
                            <stop offset="100%" stopColor="hsl(182 97% 45%)" stopOpacity={0} />
                          </linearGradient>
                        </defs>
                        <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
                        <XAxis dataKey="day" hide />
                        <YAxis hide />
                        <Tooltip
                          contentStyle={{
                            background: "hsl(180 25% 8%)",
                            border: "1px solid hsl(180 50% 70% / 0.2)",
                            borderRadius: 8,
                            fontSize: 11,
                          }}
                        />
                        <Area type="monotone" dataKey="value" stroke="hsl(182 97% 55%)" fill="url(#netMini)" strokeWidth={2} />
                      </AreaChart>
                    </ResponsiveContainer>
                  </div>

                  <div className="glass rounded-xl p-3 flex items-center gap-2 text-xs text-muted-foreground">
                    <MapPin className="h-4 w-4 text-accent shrink-0" />
                    Synthetic map placement from hub name hash — wire real coordinates when available.
                  </div>
                </div>
              </GlassCard>
            )}
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default Network;
