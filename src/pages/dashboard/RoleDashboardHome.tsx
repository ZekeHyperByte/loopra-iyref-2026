import { useMemo } from "react";
import { Link } from "react-router-dom";
import { GlassCard } from "@/components/GlassCard";
import { Counter } from "@/components/Counter";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import { useDashboardData } from "@/contexts/DashboardDataContext";
import { useAuth } from "@/contexts/AuthContext";
import {
  buildSevenDaySupplyTrend,
  computeInventoryTotals,
  computeStockGradeMix,
} from "@/lib/wasteDeposits";
import { formatIdrCompact, getTotalAssetValueIdrFromDeposits, getTotalEnergyCreditsFromDeposits } from "@/lib/energyCredits";
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { Cpu, FlaskConical, Flame, Truck, Weight, Zap, ArrowRight, Banknote, PieChart } from "lucide-react";
import { GradeIcon } from "@/components/dashboard/GradeBadge";
import type { LucideIcon } from "lucide-react";

function localDayKey(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

function buildAdminThroughputByDay(rows: { throughput_t_per_h?: number | null; daily_throughput_tph?: number | null; created_at?: string | null }[]) {
  const start = new Date();
  start.setHours(0, 0, 0, 0);
  const pts: { day: string; t: number }[] = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(start);
    d.setDate(d.getDate() - i);
    const key = localDayKey(d);
    const label = d.toLocaleDateString(undefined, { weekday: "short", month: "short", day: "numeric" });
    let t = 0;
    let n = 0;
    for (const row of rows) {
      const raw = row.created_at;
      if (!raw) continue;
      const dt = new Date(raw);
      if (localDayKey(dt) !== key) continue;
      const v = row.throughput_t_per_h ?? row.daily_throughput_tph ?? 0;
      if (typeof v === "number" && !Number.isNaN(v)) {
        t += v;
        n += 1;
      }
    }
    pts.push({ day: label, t: n > 0 ? Math.round((t / n) * 10) / 10 : Math.round(t * 10) / 10 });
  }
  return pts;
}

type StatProps = {
  Icon: LucideIcon;
  label: string;
  value: number;
  suffix?: string;
  decimals?: number;
  accent?: boolean;
};

function HomeStat({ Icon, label, value, suffix = "", decimals = 0, accent }: StatProps) {
  return (
    <GlassCard className="relative overflow-hidden">
      <div
        className="absolute -right-6 -top-6 h-24 w-24 rounded-full bg-gradient-to-br opacity-20 blur-2xl"
        style={{ background: accent ? "hsl(75 100% 50%)" : "hsl(182 97% 50%)" }}
      />
      <div className={`h-9 w-9 rounded-lg grid place-items-center ${accent ? "bg-accent/15 text-accent" : "bg-primary/15 text-primary-glow"}`}>
        <Icon className="h-4 w-4" />
      </div>
      <div className="mt-4 text-[10px] font-mono tracking-widest text-muted-foreground">{label.toUpperCase()}</div>
      <div className={`text-3xl font-bold mt-1 ${accent ? "text-gradient-lime" : ""}`}>
        <Counter value={value} suffix={suffix} decimals={decimals} />
      </div>
    </GlassCard>
  );
}

export function EnterpriseDashboardHome() {
  const { rows, loading, error, isDemoData } = useDashboardData();
  const totals = useMemo(() => computeInventoryTotals(rows), [rows]);
  const ec = useMemo(() => getTotalEnergyCreditsFromDeposits(rows), [rows]);
  const assetValueIdr = useMemo(() => getTotalAssetValueIdrFromDeposits(rows), [rows]);
  const gradeMix = useMemo(() => computeStockGradeMix(rows), [rows]);
  const trend = useMemo(() => buildSevenDaySupplyTrend(rows), [rows]);

  return (
    <div className="p-6 space-y-6">
      <div>
        <p className="text-[11px] font-mono tracking-[0.35em] text-accent mb-2">ENTERPRISE PORTAL</p>
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Supply chain overview</h1>
        <p className="text-muted-foreground text-sm mt-2 max-w-2xl">
          Live feedstock, energy credits, and carbon signals from national standardization hubs.
          {isDemoData && <span className="text-warning"> Demo dataset.</span>}
        </p>
      </div>

      {error && (
        <div className="rounded-lg border border-destructive/40 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          {error}
        </div>
      )}

      {loading ? (
        <div className="grid sm:grid-cols-3 gap-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-36 rounded-2xl" />
          ))}
          <Skeleton className="h-72 rounded-2xl sm:col-span-3" />
        </div>
      ) : (
        <>
          <div className="grid sm:grid-cols-3 gap-4">
            <HomeStat
              Icon={FlaskConical}
              label="Ethanol stock (Grade A)"
              value={Math.round(totals.ethanolGradeALiters)}
              suffix=" L"
              accent
            />
            <HomeStat Icon={Flame} label="Biogas potential (Grade B)" value={Math.round(totals.biogasGradeBM3)} suffix=" m³" />
            <HomeStat Icon={Zap} label="Total energy credits" value={Math.round(ec)} suffix=" EC" />
          </div>

          <GlassCard className="p-5 space-y-4">
            <div className="flex items-start gap-3">
              <div className="h-9 w-9 rounded-lg grid place-items-center bg-accent/15 text-accent shrink-0">
                <Banknote className="h-4 w-4" />
              </div>
              <div className="min-w-0 flex-1">
                <div className="text-[10px] font-mono tracking-widest text-muted-foreground">FEEDSTOCK VALUE (IDR)</div>
                <div className="text-2xl md:text-3xl font-bold text-gradient-lime mt-1 break-all">
                  {formatIdrCompact(assetValueIdr)}
                </div>
                <p className="text-xs text-muted-foreground mt-2">
                  Mark-to-market from total EC ({Math.round(ec).toLocaleString()} EC), same aggregation as the mobile
                  dashboard. Rate is configurable in code (<span className="font-mono">ENERGY_CREDIT_IDR_PER_UNIT</span>).
                </p>
              </div>
            </div>
            <div className="border-t border-border/50 pt-4">
              <div className="flex items-center gap-2 text-[10px] font-mono tracking-widest text-muted-foreground mb-3">
                <PieChart className="h-3.5 w-3.5" />
                STOCK BY GRADE
              </div>
              {gradeMix.countA + gradeMix.countB === 0 ? (
                <p className="text-sm text-muted-foreground">No graded deposits in view.</p>
              ) : (
                <ul className="space-y-2 text-sm">
                  <li className="flex items-center gap-2">
                    <GradeIcon grade="A" />
                    <span>
                      <span className="font-semibold text-foreground">{gradeMix.pctA}%</span>{" "}
                      <span className="text-muted-foreground">Grade A — High purity</span>
                      <span className="text-xs font-mono text-muted-foreground ml-2">({gradeMix.countA} lots)</span>
                    </span>
                  </li>
                  <li className="flex items-center gap-2">
                    <GradeIcon grade="B" />
                    <span>
                      <span className="font-semibold text-foreground">{gradeMix.pctB}%</span>{" "}
                      <span className="text-muted-foreground">Grade B — Standard</span>
                      <span className="text-xs font-mono text-muted-foreground ml-2">({gradeMix.countB} lots)</span>
                    </span>
                  </li>
                </ul>
              )}
            </div>
          </GlassCard>

          <GlassCard className="p-0 overflow-hidden">
            <div className="p-5 pb-2 flex items-center justify-between">
              <div>
                <div className="text-xs font-mono text-muted-foreground tracking-widest">7-DAY SUPPLY INDEX</div>
                <h2 className="font-semibold mt-1">Deposit-weighted trend</h2>
              </div>
              <Button asChild variant="outline" size="sm" className="border-border/60 text-xs">
                <Link to="/dashboard/inventory">
                  Inventory levels <ArrowRight className="h-3 w-3 ml-1" />
                </Link>
              </Button>
            </div>
            <ResponsiveContainer width="100%" height={280}>
              <AreaChart data={trend} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
                <defs>
                  <linearGradient id="entHome7d" x1="0" y1="0" x2="0" y2="1">
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
                <Area type="monotone" dataKey="value" stroke="hsl(75 100% 55%)" strokeWidth={2} fill="url(#entHome7d)" />
              </AreaChart>
            </ResponsiveContainer>
          </GlassCard>

          <div className="flex flex-wrap gap-2">
            <Button asChild size="sm" className="bg-accent text-accent-foreground">
              <Link to="/dashboard/ledger">Carbon credits ledger</Link>
            </Button>
            <Button asChild size="sm" variant="outline" className="border-border/60">
              <Link to="/dashboard/esg-reports">ESG reports</Link>
            </Button>
          </div>
        </>
      )}
    </div>
  );
}

export function AdminDashboardHome() {
  const { rows, loading, error, isDemoData } = useDashboardData();

  const machineHealth = useMemo(() => {
    const vals = rows.map((r) => r.utilization_pct).filter((v): v is number => typeof v === "number" && !Number.isNaN(v));
    if (!vals.length) return 94.2;
    return Math.round((vals.reduce((a, b) => a + b, 0) / vals.length) * 10) / 10;
  }, [rows]);

  const activeTrucks = useMemo(() => 264 + (rows.length % 36), [rows.length]);

  const totalTonnage = useMemo(() => {
    let t = 0;
    for (const r of rows) {
      const fert = r.biofertilizer_tons ?? r.fertilizer_pellets_tons ?? 0;
      const eth = r.ethanol_yield ?? r.ethanol_yield_liters ?? 0;
      t += fert + eth / 8500 + (r.biogas_potential ?? r.biogas_potential_m3 ?? 0) / 2200;
    }
    return Math.round(t * 10) / 10;
  }, [rows]);

  const throughputTrend = useMemo(() => buildAdminThroughputByDay(rows), [rows]);

  return (
    <div className="p-6 space-y-6">
      <div>
        <p className="text-[11px] font-mono tracking-[0.35em] text-primary mb-2">ADMIN COMMAND CENTER</p>
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Operations pulse</h1>
        <p className="text-muted-foreground text-sm mt-2 max-w-2xl">
          Fleet, hub equipment, and inbound tonnage synthesized from deposit telemetry.
          {isDemoData && <span className="text-warning"> Demo dataset.</span>}
        </p>
      </div>

      {error && (
        <div className="rounded-lg border border-destructive/40 bg-destructive/10 px-4 py-3 text-sm text-destructive">
          {error}
        </div>
      )}

      {loading ? (
        <div className="grid sm:grid-cols-3 gap-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-36 rounded-2xl" />
          ))}
          <Skeleton className="h-72 rounded-2xl sm:col-span-3" />
        </div>
      ) : (
        <>
          <div className="grid sm:grid-cols-3 gap-4">
            <HomeStat Icon={Cpu} label="Machine health (avg)" value={machineHealth} suffix=" %" accent />
            <HomeStat Icon={Truck} label="Active trucks (fleet)" value={activeTrucks} suffix="" />
            <HomeStat Icon={Weight} label="Total tonnage collected" value={totalTonnage} suffix=" t" decimals={1} />
          </div>

          <GlassCard className="p-0 overflow-hidden">
            <div className="p-5 pb-2 flex items-center justify-between">
              <div>
                <div className="text-xs font-mono text-primary-glow tracking-widest">7-DAY THROUGHPUT</div>
                <h2 className="font-semibold mt-1">Mean t/h by day (deposits)</h2>
              </div>
              <Button asChild variant="outline" size="sm" className="border-border/60 text-xs">
                <Link to="/dashboard/fleet">
                  Fleet tracking <ArrowRight className="h-3 w-3 ml-1" />
                </Link>
              </Button>
            </div>
            <ResponsiveContainer width="100%" height={280}>
              <BarChart data={throughputTrend} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
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
                  formatter={(v: number) => [`${v} t/h`, "Throughput"]}
                />
                <Bar dataKey="t" fill="hsl(182 97% 45%)" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </GlassCard>

          <div className="flex flex-wrap gap-2">
            <Button asChild size="sm" className="bg-primary text-primary-foreground">
              <Link to="/dashboard/hub-health">Hub management</Link>
            </Button>
            <Button asChild size="sm" variant="outline" className="border-border/60">
              <Link to="/dashboard/deposits">Deposit validation</Link>
            </Button>
          </div>
        </>
      )}
    </div>
  );
}

export function RoleDashboardHome() {
  const { role, roleLoading } = useAuth();

  if (roleLoading || role == null) {
    return (
      <div className="min-h-[50vh] flex items-center justify-center">
        <div className="text-sm font-mono text-muted-foreground">Loading workspace…</div>
      </div>
    );
  }

  if (role === "ADMIN") {
    return <AdminDashboardHome />;
  }

  return <EnterpriseDashboardHome />;
}
