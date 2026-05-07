import { useMemo } from "react";
import type { LucideIcon } from "lucide-react";
import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Counter } from "@/components/Counter";
import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis, CartesianGrid, BarChart, Bar } from "recharts";
import {
  ArrowDownToLine,
  FlaskConical,
  Flame,
  Package,
  TrendingUp,
  TrendingDown,
  Zap,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { motion } from "framer-motion";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import {
  aggregateHubs,
  buildGradeAEthanolHourlySeries,
  buildGradeBBiogasHourlySeries,
  computeInventoryTotals,
  seriesHalfDeltaPct,
} from "@/lib/wasteDeposits";
import { getTotalEnergyCreditsFromDeposits } from "@/lib/energyCredits";
import { GradeBadgeLetter } from "@/components/dashboard/GradeBadge";
import { cn } from "@/lib/utils";

type StatCardProps = {
  Icon: LucideIcon;
  label: string;
  value: number;
  suffix?: string;
  decimals?: number;
  delta?: number | null;
  accent?: boolean;
};

const StatCard = ({ Icon, label, value, suffix, decimals = 0, delta, accent }: StatCardProps) => (
  <GlassCard className={cn("relative overflow-hidden", delta === undefined && "min-h-[132px]")}>
    <div
      className="absolute -right-6 -top-6 h-24 w-24 rounded-full bg-gradient-to-br opacity-20 blur-2xl"
      style={{ background: accent ? "hsl(75 100% 50%)" : "hsl(182 97% 50%)" }}
    />
    <div className="flex items-center justify-between relative">
      <div
        className={`h-9 w-9 rounded-lg grid place-items-center ${
          accent ? "bg-accent/15 text-accent" : "bg-primary/15 text-primary-glow"
        }`}
      >
        <Icon className="h-4 w-4" />
      </div>
      {delta != null && (
        <span
          className={`text-[11px] font-mono inline-flex items-center gap-1 ${delta >= 0 ? "text-success" : "text-destructive"}`}
        >
          {delta >= 0 ? <TrendingUp className="h-3 w-3" /> : <TrendingDown className="h-3 w-3" />}
          {Math.abs(delta).toFixed(1)}%
        </span>
      )}
    </div>
    <div className="mt-5">
      <div className="text-[10px] font-mono tracking-widest text-muted-foreground">{label.toUpperCase()}</div>
      <div className={`text-3xl font-bold mt-1 ${accent ? "text-gradient-lime" : ""}`}>
        <Counter value={value} suffix={suffix} decimals={decimals} />
      </div>
    </div>
  </GlassCard>
);

function InventorySkeleton() {
  return (
    <div className="space-y-6 animate-pulse">
      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {[1, 2, 3, 4].map((i) => (
          <Skeleton key={i} className="h-[132px] rounded-2xl" />
        ))}
      </div>
      <div className="grid lg:grid-cols-2 gap-4">
        <Skeleton className="h-[280px] rounded-2xl" />
        <Skeleton className="h-[280px] rounded-2xl" />
      </div>
      <Skeleton className="h-[320px] rounded-2xl w-full" />
    </div>
  );
}

const Inventory = () => {
  const { rows, loading, error, refetch } = useDashboardData();

  const totals = useMemo(() => computeInventoryTotals(rows), [rows]);
  const ethanolSeries = useMemo(() => buildGradeAEthanolHourlySeries(rows), [rows]);
  const biogasSeries = useMemo(() => buildGradeBBiogasHourlySeries(rows), [rows]);
  const hubs = useMemo(() => aggregateHubs(rows), [rows]);
  const totalEc = useMemo(() => getTotalEnergyCreditsFromDeposits(rows), [rows]);

  const ethanolDelta = seriesHalfDeltaPct(ethanolSeries);
  const biogasDelta = seriesHalfDeltaPct(biogasSeries);

  return (
    <div className="p-6 space-y-6 relative min-h-[480px]">
      <PageHeader
        eyebrow="Enterprise · Inventory levels"
        title="National Inventory Visibility"
        description="Energy credits, ethanol (Grade A), and biogas potential (Grade B) from waste_deposits — live."
      >
        <Button variant="outline" size="sm" className="border-border/60" disabled={loading}>
          <ArrowDownToLine className="h-3.5 w-3.5 mr-2" /> Export Snapshot
        </Button>
        <Button
          size="sm"
          className="bg-accent text-accent-foreground hover:bg-accent/90"
          onClick={() => refetch()}
          disabled={loading}
        >
          Sync Live
        </Button>
      </PageHeader>

      {error && (
        <div className="rounded-lg border border-destructive/40 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          Could not load waste_deposits: {error}. Check RLS policies and column names.
        </div>
      )}

      {loading ? (
        <InventorySkeleton />
      ) : (
        <div className="space-y-6">
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <StatCard
              Icon={Zap}
              label="Total Energy Credits"
              value={Math.round(totalEc)}
              suffix=" EC"
              accent
            />
            <StatCard
              Icon={FlaskConical}
              label="Ethanol inventory (Grade A)"
              value={Math.round(totals.ethanolGradeALiters)}
              suffix=" L"
              delta={ethanolDelta}
            />
            <StatCard
              Icon={Flame}
              label="Biogas potential (Grade B)"
              value={Math.round(totals.biogasGradeBM3)}
              suffix=" m³"
              delta={biogasDelta}
            />
            <StatCard
              Icon={Package}
              label="Bio-fertilizer Pellets"
              value={Math.round(totals.fertilizerTons * 10) / 10}
              suffix=" t"
              decimals={1}
            />
          </div>

          <div className="grid lg:grid-cols-2 gap-4">
            <GlassCard className="p-0 overflow-hidden">
              <div className="flex items-center justify-between p-5 pb-2">
                <div>
                  <div className="text-xs font-mono text-accent tracking-widest">GRADE A ETHANOL · 24H</div>
                  <h3 className="font-semibold mt-1">Hourly yield (liters)</h3>
                </div>
                {ethanolDelta != null && (
                  <span
                    className={`text-mono text-2xl font-bold ${ethanolDelta >= 0 ? "text-gradient-lime" : "text-destructive"}`}
                  >
                    {ethanolDelta >= 0 ? "+" : ""}
                    {ethanolDelta.toFixed(1)}%
                  </span>
                )}
              </div>
              <ResponsiveContainer width="100%" height={220}>
                <AreaChart data={ethanolSeries} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
                  <defs>
                    <linearGradient id="gEthanolLive" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="hsl(75 100% 50%)" stopOpacity={0.5} />
                      <stop offset="100%" stopColor="hsl(75 100% 50%)" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
                  <XAxis dataKey="label" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                  <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                  <Tooltip
                    contentStyle={{
                      background: "hsl(180 25% 8%)",
                      border: "1px solid hsl(180 50% 70% / 0.2)",
                      borderRadius: 8,
                      fontSize: 12,
                    }}
                    formatter={(v: number) => [`${v.toLocaleString()} L`, "Ethanol"]}
                  />
                  <Area
                    type="monotone"
                    dataKey="v"
                    stroke="hsl(75 100% 50%)"
                    strokeWidth={2}
                    fill="url(#gEthanolLive)"
                  />
                </AreaChart>
              </ResponsiveContainer>
            </GlassCard>

            <GlassCard className="p-0 overflow-hidden">
              <div className="flex items-center justify-between p-5 pb-2">
                <div>
                  <div className="text-xs font-mono text-primary-glow tracking-widest">GRADE B BIOGAS · 24H</div>
                  <h3 className="font-semibold mt-1">Hourly potential (m³)</h3>
                </div>
                {biogasDelta != null && (
                  <span
                    className={`text-mono text-2xl font-bold ${biogasDelta >= 0 ? "text-primary-glow" : "text-destructive"}`}
                  >
                    {biogasDelta >= 0 ? "+" : ""}
                    {biogasDelta.toFixed(1)}%
                  </span>
                )}
              </div>
              <ResponsiveContainer width="100%" height={220}>
                <BarChart data={biogasSeries} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
                  <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
                  <XAxis dataKey="label" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                  <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                  <Tooltip
                    cursor={{ fill: "hsl(180 20% 14% / 0.5)" }}
                    contentStyle={{
                      background: "hsl(180 25% 8%)",
                      border: "1px solid hsl(180 50% 70% / 0.2)",
                      borderRadius: 8,
                      fontSize: 12,
                    }}
                    formatter={(v: number) => [`${v.toLocaleString()} m³`, "Biogas"]}
                  />
                  <Bar dataKey="v" fill="hsl(182 97% 45%)" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </GlassCard>
          </div>

          <GlassCard className="p-0">
            <div className="flex items-center justify-between p-5">
              <div>
                <div className="text-xs font-mono text-muted-foreground tracking-widest">HUB INVENTORY MATRIX</div>
                <h3 className="font-semibold mt-1">Top hubs by volume</h3>
              </div>
              <Button variant="ghost" size="sm" className="text-xs">
                Live from deposits →
              </Button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="text-[10px] font-mono text-muted-foreground tracking-widest border-y border-border/50">
                  <tr>
                    <th className="text-left p-3 pl-5">HUB · LOCATION</th>
                    <th className="text-left p-3">ASSAY GRADE</th>
                    <th className="text-right p-3">ETHANOL (L)</th>
                    <th className="text-right p-3">BIOGAS (m³)</th>
                    <th className="text-left p-3 w-48">UTILIZATION</th>
                    <th className="text-right p-3 pr-5">24H Δ</th>
                  </tr>
                </thead>
                <tbody>
                  {hubs.length === 0 ? (
                    <tr>
                      <td colSpan={6} className="p-8 text-center text-muted-foreground text-sm">
                        No waste deposit rows yet. Insert into <span className="text-mono">waste_deposits</span> to populate
                        this matrix.
                      </td>
                    </tr>
                  ) : (
                    hubs.map((h, i) => (
                      <motion.tr
                        key={h.name}
                        initial={{ opacity: 0, y: 6 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: i * 0.04 }}
                        className="border-b border-border/40 hover:bg-secondary/30"
                      >
                        <td className="p-3 pl-5 font-medium">{h.name}</td>
                        <td className="p-3">
                          <GradeBadgeLetter grade={h.grade} />
                        </td>
                        <td className="p-3 text-right text-mono">{h.ethanol.toLocaleString()}</td>
                        <td className="p-3 text-right text-mono">{h.biogas.toLocaleString()}</td>
                        <td className="p-3">
                          <div className="flex items-center gap-2">
                            <div className="flex-1 h-1.5 rounded-full bg-secondary overflow-hidden">
                              <div
                                className="h-full bg-gradient-to-r from-primary to-accent"
                                style={{ width: `${h.util}%` }}
                              />
                            </div>
                            <span className="text-mono text-xs w-10">{h.util}%</span>
                          </div>
                        </td>
                        <td
                          className={`p-3 pr-5 text-right text-mono ${h.trend >= 0 ? "text-success" : "text-destructive"}`}
                        >
                          {h.trend >= 0 ? "+" : ""}
                          {h.trend}%
                        </td>
                      </motion.tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </GlassCard>
        </div>
      )}
    </div>
  );
};

export default Inventory;
