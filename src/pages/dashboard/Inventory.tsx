import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Counter } from "@/components/Counter";
import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis, CartesianGrid, BarChart, Bar } from "recharts";
import { ArrowDownToLine, FlaskConical, Flame, Package, TrendingUp, TrendingDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { motion } from "framer-motion";

const ethanolData = Array.from({ length: 24 }, (_, i) => ({
  h: `${i}h`,
  v: 800 + Math.sin(i / 3) * 200 + Math.random() * 120,
}));
const biogasData = Array.from({ length: 24 }, (_, i) => ({
  h: `${i}h`,
  v: 600 + Math.cos(i / 4) * 180 + Math.random() * 100,
}));

const hubs = [
  { name: "Lampung Selatan", grade: "A", ethanol: 184500, biogas: 92400, util: 87, trend: 4.2 },
  { name: "Sidoarjo Timur", grade: "A", ethanol: 162300, biogas: 81200, util: 82, trend: 2.1 },
  { name: "Medan Belawan", grade: "B", ethanol: 98400, biogas: 54300, util: 64, trend: -1.4 },
  { name: "Makassar Hub", grade: "A", ethanol: 142800, biogas: 71600, util: 78, trend: 6.8 },
  { name: "Pontianak Barat", grade: "B", ethanol: 76200, biogas: 38400, util: 51, trend: -3.2 },
  { name: "Banyuwangi", grade: "A", ethanol: 128400, biogas: 62100, util: 74, trend: 3.5 },
];

const StatCard = ({ Icon, label, value, suffix, delta, accent }: any) => (
  <GlassCard className="relative overflow-hidden">
    <div className="absolute -right-6 -top-6 h-24 w-24 rounded-full bg-gradient-to-br opacity-20 blur-2xl"
      style={{ background: accent ? "hsl(75 100% 50%)" : "hsl(182 97% 50%)" }} />
    <div className="flex items-center justify-between relative">
      <div className={`h-9 w-9 rounded-lg grid place-items-center ${accent ? "bg-accent/15 text-accent" : "bg-primary/15 text-primary-glow"}`}>
        <Icon className="h-4 w-4" />
      </div>
      <span className={`text-[11px] font-mono inline-flex items-center gap-1 ${delta >= 0 ? "text-success" : "text-destructive"}`}>
        {delta >= 0 ? <TrendingUp className="h-3 w-3" /> : <TrendingDown className="h-3 w-3" />}
        {Math.abs(delta)}%
      </span>
    </div>
    <div className="mt-5">
      <div className="text-[10px] font-mono tracking-widest text-muted-foreground">{label.toUpperCase()}</div>
      <div className={`text-3xl font-bold mt-1 ${accent ? "text-gradient-lime" : ""}`}>
        <Counter value={value} suffix={suffix} />
      </div>
    </div>
  </GlassCard>
);

const Inventory = () => {
  return (
    <div className="p-6 space-y-6">
      <PageHeader
        eyebrow="Enterprise Portal · Inventory"
        title="National Inventory Visibility"
        description="Live crude ethanol and compressed bio-methane stock across 142 standardization hubs nationwide."
      >
        <Button variant="outline" size="sm" className="border-border/60">
          <ArrowDownToLine className="h-3.5 w-3.5 mr-2" /> Export Snapshot
        </Button>
        <Button size="sm" className="bg-accent text-accent-foreground hover:bg-accent/90">Sync Live</Button>
      </PageHeader>

      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard Icon={FlaskConical} label="Crude Ethanol Stock" value={1284500} suffix=" L" delta={4.2} accent />
        <StatCard Icon={Flame} label="Compressed Biogas" value={684200} suffix=" m³" delta={2.8} />
        <StatCard Icon={Package} label="Bio-fertilizer Pellets" value={94320} suffix=" t" delta={-1.1} />
        <StatCard Icon={TrendingUp} label="Daily Throughput" value={48.6} suffix=" t/h" delta={6.4} accent />
      </div>

      <div className="grid lg:grid-cols-2 gap-4">
        <GlassCard className="p-0 overflow-hidden">
          <div className="flex items-center justify-between p-5 pb-2">
            <div>
              <div className="text-xs font-mono text-accent tracking-widest">CRUDE ETHANOL · 24H</div>
              <h3 className="font-semibold mt-1">Production Throughput</h3>
            </div>
            <span className="text-mono text-2xl font-bold text-gradient-lime">+12.4%</span>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={ethanolData} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
              <defs>
                <linearGradient id="g1" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="hsl(75 100% 50%)" stopOpacity={0.5} />
                  <stop offset="100%" stopColor="hsl(75 100% 50%)" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
              <XAxis dataKey="h" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
              <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
              <Tooltip contentStyle={{ background: "hsl(180 25% 8%)", border: "1px solid hsl(180 50% 70% / 0.2)", borderRadius: 8, fontSize: 12 }} />
              <Area type="monotone" dataKey="v" stroke="hsl(75 100% 50%)" strokeWidth={2} fill="url(#g1)" />
            </AreaChart>
          </ResponsiveContainer>
        </GlassCard>

        <GlassCard className="p-0 overflow-hidden">
          <div className="flex items-center justify-between p-5 pb-2">
            <div>
              <div className="text-xs font-mono text-primary-glow tracking-widest">BIO-METHANE · 24H</div>
              <h3 className="font-semibold mt-1">Capture Volume</h3>
            </div>
            <span className="text-mono text-2xl font-bold text-primary-glow">+8.1%</span>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={biogasData} margin={{ left: 0, right: 12, top: 8, bottom: 8 }}>
              <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
              <XAxis dataKey="h" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
              <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
              <Tooltip cursor={{ fill: "hsl(180 20% 14% / 0.5)" }} contentStyle={{ background: "hsl(180 25% 8%)", border: "1px solid hsl(180 50% 70% / 0.2)", borderRadius: 8, fontSize: 12 }} />
              <Bar dataKey="v" fill="hsl(182 97% 45%)" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </GlassCard>
      </div>

      <GlassCard className="p-0">
        <div className="flex items-center justify-between p-5">
          <div>
            <div className="text-xs font-mono text-muted-foreground tracking-widest">HUB INVENTORY MATRIX</div>
            <h3 className="font-semibold mt-1">Top 6 Active Hubs</h3>
          </div>
          <Button variant="ghost" size="sm" className="text-xs">View all 142 →</Button>
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
              {hubs.map((h, i) => (
                <motion.tr
                  key={h.name}
                  initial={{ opacity: 0, y: 6 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.04 }}
                  className="border-b border-border/40 hover:bg-secondary/30"
                >
                  <td className="p-3 pl-5 font-medium">{h.name}</td>
                  <td className="p-3">
                    <span className={`inline-flex items-center gap-1.5 text-[11px] font-mono px-2 py-0.5 rounded-md ${
                      h.grade === "A" ? "bg-accent/15 text-accent" : "bg-warning/15 text-warning"
                    }`}>
                      <span className="h-1.5 w-1.5 rounded-full bg-current" />
                      Grade {h.grade}
                    </span>
                  </td>
                  <td className="p-3 text-right text-mono">{h.ethanol.toLocaleString()}</td>
                  <td className="p-3 text-right text-mono">{h.biogas.toLocaleString()}</td>
                  <td className="p-3">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 h-1.5 rounded-full bg-secondary overflow-hidden">
                        <div className="h-full bg-gradient-to-r from-primary to-accent" style={{ width: `${h.util}%` }} />
                      </div>
                      <span className="text-mono text-xs w-10">{h.util}%</span>
                    </div>
                  </td>
                  <td className={`p-3 pr-5 text-right text-mono ${h.trend >= 0 ? "text-success" : "text-destructive"}`}>
                    {h.trend >= 0 ? "+" : ""}{h.trend}%
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
      </GlassCard>
    </div>
  );
};

export default Inventory;
