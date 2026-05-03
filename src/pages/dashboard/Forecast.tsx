import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis, Legend } from "recharts";
import { Sparkles } from "lucide-react";

const data = Array.from({ length: 30 }, (_, i) => {
  const day = i + 1;
  const seasonal = Math.sin((day / 30) * Math.PI * 2) * 200;
  return {
    day: `D${day}`,
    actual: i < 12 ? 1200 + seasonal + Math.random() * 80 : null,
    forecast: 1200 + seasonal + Math.cos(day / 5) * 60,
    upper: 1380 + seasonal + Math.cos(day / 5) * 60,
    lower: 1020 + seasonal + Math.cos(day / 5) * 60,
  };
});

const Forecast = () => (
  <div className="p-6 space-y-6">
    <PageHeader
      eyebrow="Enterprise Portal · AI"
      title="Feedstock Supply Forecast"
      description="30-day predictive model trained on harvest telemetry from 38,400 mobile assays daily."
    />
    <GlassCard strong className="p-0 overflow-hidden">
      <div className="flex items-center justify-between p-5">
        <div>
          <div className="flex items-center gap-2 text-xs font-mono text-accent tracking-widest">
            <Sparkles className="h-3 w-3" /> NEURAL SUPPLY MODEL · v3.2
          </div>
          <h3 className="font-semibold mt-1">Projected Crude Ethanol Throughput</h3>
        </div>
        <div className="flex items-center gap-4 text-xs">
          <div className="flex items-center gap-1.5"><span className="h-2 w-2 rounded-sm bg-accent" /> Forecast</div>
          <div className="flex items-center gap-1.5"><span className="h-2 w-2 rounded-sm bg-primary" /> Actual</div>
          <div className="flex items-center gap-1.5"><span className="h-2 w-2 rounded-sm bg-primary/30" /> Confidence</div>
        </div>
      </div>
      <ResponsiveContainer width="100%" height={360}>
        <AreaChart data={data} margin={{ top: 8, right: 24, left: 0, bottom: 12 }}>
          <defs>
            <linearGradient id="bandGrad" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="hsl(182 97% 45%)" stopOpacity={0.25} />
              <stop offset="100%" stopColor="hsl(182 97% 45%)" stopOpacity={0.02} />
            </linearGradient>
            <linearGradient id="actGrad" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="hsl(75 100% 50%)" stopOpacity={0.4} />
              <stop offset="100%" stopColor="hsl(75 100% 50%)" stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid stroke="hsl(180 20% 14%)" vertical={false} />
          <XAxis dataKey="day" stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
          <YAxis stroke="hsl(150 8% 50%)" fontSize={10} tickLine={false} axisLine={false} />
          <Tooltip contentStyle={{ background: "hsl(180 25% 8%)", border: "1px solid hsl(180 50% 70% / 0.2)", borderRadius: 8, fontSize: 12 }} />
          <Area dataKey="upper" stroke="none" fill="url(#bandGrad)" />
          <Area dataKey="lower" stroke="none" fill="hsl(180 25% 5%)" />
          <Area dataKey="forecast" stroke="hsl(182 97% 60%)" strokeWidth={2} fill="none" strokeDasharray="4 4" />
          <Area dataKey="actual" stroke="hsl(75 100% 55%)" strokeWidth={2.5} fill="url(#actGrad)" />
        </AreaChart>
      </ResponsiveContainer>
    </GlassCard>

    <div className="grid md:grid-cols-3 gap-4">
      {[
        { k: "30-Day Volume", v: "38,420 t", d: "Predicted feedstock arrivals" },
        { k: "Confidence Interval", v: "94.6%", d: "Model precision (RMSE-adj)" },
        { k: "Seasonal Lift", v: "+18.2%", d: "vs. prior quarter baseline" },
      ].map((r) => (
        <GlassCard key={r.k}>
          <div className="text-[10px] font-mono tracking-widest text-muted-foreground">{r.k.toUpperCase()}</div>
          <div className="text-3xl font-bold text-gradient-emerald mt-1">{r.v}</div>
          <div className="text-xs text-muted-foreground mt-2">{r.d}</div>
        </GlassCard>
      ))}
    </div>
  </div>
);

export default Forecast;
