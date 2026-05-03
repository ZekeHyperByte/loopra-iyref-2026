import { useMemo } from "react";
import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Sparkles } from "lucide-react";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { buildSevenDaySupplyTrend, seriesHalfDeltaPct } from "@/lib/wasteDeposits";
import { Skeleton } from "@/components/ui/skeleton";

const Forecast = () => {
  const { rows, loading, error } = useDashboardData();

  const trend = useMemo(() => buildSevenDaySupplyTrend(rows), [rows]);
  const delta = seriesHalfDeltaPct(trend.map((t) => ({ v: t.value })));

  const totalWeek = useMemo(() => trend.reduce((s, p) => s + p.value, 0), [trend]);
  const peakDay = useMemo(() => {
    if (!trend.length) return "—";
    return trend.reduce((best, p) => (p.value > best.value ? p : best), trend[0]).day;
  }, [trend]);

  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise · Forecast"
        title="7-Day supply trend"
        description="Daily signal from waste_deposits: sum of ec_earned, or ethanol + biogas when credits are absent."
      />

      {error && (
        <div className="rounded-lg border border-destructive/40 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          {error}
        </div>
      )}

      {loading ? (
        <Skeleton className="h-[400px] w-full rounded-2xl" />
      ) : (
        <>
          <GlassCard strong className="p-0 overflow-hidden">
            <div className="flex items-center justify-between p-5">
              <div>
                <div className="flex items-center gap-2 text-xs font-mono text-accent tracking-widest">
                  <Sparkles className="h-3 w-3" /> 7-DAY WINDOW · CREATED_AT
                </div>
                <h3 className="font-semibold mt-1">Deposit-weighted supply index</h3>
              </div>
              {delta != null && (
                <div className={`text-mono text-xl font-bold ${delta >= 0 ? "text-accent" : "text-destructive"}`}>
                  {delta >= 0 ? "+" : ""}
                  {delta.toFixed(1)}% half-week
                </div>
              )}
            </div>
            <ResponsiveContainer width="100%" height={360}>
              <AreaChart data={trend} margin={{ top: 8, right: 24, left: 0, bottom: 12 }}>
                <defs>
                  <linearGradient id="forecast7dFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(75 100% 50%)" stopOpacity={0.45} />
                    <stop offset="100%" stopColor="hsl(75 100% 50%)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
                <XAxis dataKey="day" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
                <Tooltip
                  contentStyle={{
                    background: "hsl(180 25% 8%)",
                    border: "1px solid hsl(180 50% 70% / 0.2)",
                    borderRadius: 8,
                    fontSize: 12,
                  }}
                />
                <Area
                  type="monotone"
                  dataKey="value"
                  stroke="hsl(75 100% 55%)"
                  strokeWidth={2.5}
                  fill="url(#forecast7dFill)"
                />
              </AreaChart>
            </ResponsiveContainer>
          </GlassCard>

          <div className="grid md:grid-cols-3 gap-4">
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">7-DAY TOTAL INDEX</div>
              <div className="text-3xl font-bold text-gradient-emerald mt-1 text-mono">
                {Math.round(totalWeek).toLocaleString()}
              </div>
              <div className="text-xs text-muted-foreground mt-2">Sum of daily values from waste_deposits</div>
            </GlassCard>
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">DAYS WITH DATA</div>
              <div className="text-3xl font-bold mt-1 text-mono">
                {trend.filter((d) => d.value > 0).length}
              </div>
              <div className="text-xs text-muted-foreground mt-2">Non-zero buckets in the window</div>
            </GlassCard>
            <GlassCard>
              <div className="text-[10px] font-mono tracking-widest text-muted-foreground">PEAK DAY</div>
              <div className="text-xl font-bold mt-1 truncate">{peakDay}</div>
              <div className="text-xs text-muted-foreground mt-2">Highest index in range</div>
            </GlassCard>
          </div>
        </>
      )}
    </div>
  );
};

export default Forecast;
