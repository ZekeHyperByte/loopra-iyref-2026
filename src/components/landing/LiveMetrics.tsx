import { motion } from "framer-motion";
import { GlassCard } from "@/components/GlassCard";
import { Counter } from "@/components/Counter";
import { Recycle, Droplets, Wind, Award } from "lucide-react";

const metrics = [
  { Icon: Recycle, label: "Metric Tons of Organic Feedstock Processed", value: 482610, suffix: " t", accent: false },
  { Icon: Droplets, label: "Liters of Bio-ethanol Ready for Distribution", value: 1284500, suffix: " L", accent: true },
  { Icon: Wind, label: "Kilograms of Methane Prevented", value: 38420, suffix: " kg", accent: false },
  { Icon: Award, label: "Verified Carbon Credits Generated", value: 21945, suffix: " VCC", accent: true },
];

export const LiveMetrics = () => {
  return (
    <section id="metrics" className="container py-24 relative">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        className="max-w-2xl mb-12"
      >
        <div className="inline-flex items-center gap-2 mb-3">
          <span className="h-1.5 w-1.5 rounded-full bg-accent animate-pulse-dot" />
          <span className="text-xs font-mono tracking-[0.3em] text-accent">LIVE ECOSYSTEM TELEMETRY</span>
        </div>
        <h2 className="text-3xl md:text-5xl font-bold tracking-tight">
          The pulse of <span className="text-gradient-emerald">a regenerative</span> economy.
        </h2>
        <p className="text-muted-foreground mt-4">
          Every kilogram of feedstock standardized, every liter of renewable fuel produced — measured,
          tokenized, and auditable across the Loopra protocol.
        </p>
      </motion.div>

      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {metrics.map((m, i) => (
          <motion.div
            key={m.label}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.08 }}
          >
            <GlassCard className="h-full group hover:border-accent/40">
              <div className="flex items-center justify-between mb-6">
                <div className={`h-10 w-10 rounded-lg grid place-items-center ${m.accent ? "bg-accent/15" : "bg-primary/15"}`}>
                  <m.Icon className={`h-5 w-5 ${m.accent ? "text-accent" : "text-primary-glow"}`} />
                </div>
                <span className="text-[10px] font-mono text-muted-foreground tracking-widest">LIVE</span>
              </div>
              <div className={`text-3xl md:text-4xl font-bold tracking-tight ${m.accent ? "text-gradient-lime" : "text-foreground"}`}>
                <Counter value={m.value} suffix={m.suffix} />
              </div>
              <p className="text-xs text-muted-foreground mt-3 leading-relaxed">{m.label}</p>
              <div className="mt-4 h-1 rounded-full bg-secondary overflow-hidden">
                <motion.div
                  initial={{ width: 0 }}
                  whileInView={{ width: `${60 + i * 8}%` }}
                  viewport={{ once: true }}
                  transition={{ duration: 1.5, delay: 0.4 }}
                  className={`h-full ${m.accent ? "bg-accent" : "bg-primary"}`}
                />
              </div>
            </GlassCard>
          </motion.div>
        ))}
      </div>
    </section>
  );
};
