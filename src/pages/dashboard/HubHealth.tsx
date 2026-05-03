import { GlassCard } from "@/components/GlassCard";
import { PageHeader } from "@/components/dashboard/PageHeader";
import { Cog, Cpu, Zap, AlertTriangle, CheckCircle2, Wrench } from "lucide-react";

const units = Array.from({ length: 12 }, (_, i) => {
  const types = [
    { type: "Milling", Icon: Cog },
    { type: "Digester", Icon: Zap },
    { type: "Distiller", Icon: Cpu },
  ];
  const t = types[i % 3];
  const statuses = ["active", "active", "active", "maintenance", "active", "overload"];
  const status = statuses[i % statuses.length];
  return {
    id: `${t.type.slice(0, 2).toUpperCase()}-${String(420 + i).padStart(4, "0")}`,
    type: t.type,
    Icon: t.Icon,
    hub: ["Lampung", "Sidoarjo", "Makassar", "Medan", "Banyuwangi", "Pontianak"][i % 6],
    status,
    temp: 64 + (i % 5) * 8,
    load: 42 + (i % 7) * 9,
    uptime: 96 + (i % 4),
  };
});

const meta: Record<string, any> = {
  active: { Icon: CheckCircle2, color: "text-success bg-success/15 border-success/30", label: "ACTIVE" },
  maintenance: { Icon: Wrench, color: "text-warning bg-warning/15 border-warning/30", label: "MAINTENANCE" },
  overload: { Icon: AlertTriangle, color: "text-destructive bg-destructive/15 border-destructive/30", label: "OVERLOAD" },
};

const HubHealth = () => (
  <div className="p-6 space-y-6">
    <PageHeader
      eyebrow="Operations · Telemetry"
      title="Hub Health Monitor"
      description="Real-time status across milling, digesters, and distillation units in all national hubs."
    />
    <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
      {units.map((u) => {
        const m = meta[u.status];
        return (
          <GlassCard key={u.id} className={`border ${u.status === "overload" ? "border-destructive/40" : "border-border/40"}`}>
            <div className="flex items-start justify-between">
              <div className="flex items-center gap-2.5">
                <div className="h-9 w-9 rounded-lg bg-secondary grid place-items-center">
                  <u.Icon className="h-4 w-4 text-accent" />
                </div>
                <div>
                  <div className="text-mono text-xs font-bold">{u.id}</div>
                  <div className="text-[10px] text-muted-foreground">{u.type} · {u.hub}</div>
                </div>
              </div>
              <span className={`text-[9px] font-mono px-1.5 py-0.5 rounded border ${m.color} inline-flex items-center gap-1`}>
                <m.Icon className="h-2.5 w-2.5" /> {m.label}
              </span>
            </div>
            <div className="grid grid-cols-3 gap-2 mt-4">
              {[
                { k: "TEMP", v: `${u.temp}°C` },
                { k: "LOAD", v: `${u.load}%` },
                { k: "UP", v: `${u.uptime}%` },
              ].map((r) => (
                <div key={r.k} className="text-center">
                  <div className="text-[9px] font-mono text-muted-foreground tracking-widest">{r.k}</div>
                  <div className="text-mono text-sm font-bold mt-0.5">{r.v}</div>
                </div>
              ))}
            </div>
            <div className="mt-3 h-1 rounded-full bg-secondary overflow-hidden">
              <div className={`h-full ${u.status === "overload" ? "bg-destructive" : u.status === "maintenance" ? "bg-warning" : "bg-gradient-to-r from-primary to-accent"}`}
                style={{ width: `${u.load}%` }} />
            </div>
          </GlassCard>
        );
      })}
    </div>
  </div>
);

export default HubHealth;
