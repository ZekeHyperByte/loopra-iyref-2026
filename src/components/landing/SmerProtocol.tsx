import { motion } from "framer-motion";
import { useState } from "react";
import { Beaker, FlaskConical, Flame, Sprout, ArrowRight } from "lucide-react";
import { GlassCard } from "@/components/GlassCard";

const steps = [
  {
    n: "01",
    title: "Extraction",
    Icon: Beaker,
    desc: "Standardized organic feedstock is mechanically pressed and assayed by AI-vision to grade sucrose, starch, and lignocellulose density.",
    output: "Pulp Slurry · Grade A/B",
  },
  {
    n: "02",
    title: "Fermentation",
    Icon: FlaskConical,
    desc: "Genetically optimized yeast cultures convert sugars into crude bio-ethanol within precision-controlled bioreactors.",
    output: "Crude Ethanol · 92% Purity",
  },
  {
    n: "03",
    title: "Biogas Capture",
    Icon: Flame,
    desc: "Anaerobic digesters process residual biomass, capturing high-purity methane (CH₄) for grid compression.",
    output: "Compressed Bio-CH₄ · 96%",
  },
  {
    n: "04",
    title: "Bio-Fertilizer",
    Icon: Sprout,
    desc: "Nutrient-rich digestate is stabilized into organic fertilizer pellets, returning carbon to Indonesian soil.",
    output: "NPK Pellets · Closed Loop",
  },
];

export const SmerProtocol = () => {
  const [active, setActive] = useState(0);
  const step = steps[active];

  return (
    <section id="protocol" className="container py-24 relative">
      <div className="max-w-3xl mb-12">
        <div className="inline-flex items-center gap-2 mb-3">
          <span className="h-1.5 w-1.5 rounded-full bg-primary-glow" />
          <span className="text-xs font-mono tracking-[0.3em] text-primary-glow">THE SMER PROTOCOL</span>
        </div>
        <h2 className="text-3xl md:text-5xl font-bold tracking-tight">
          Sequential Multi-Energy Recovery.
        </h2>
        <p className="text-muted-foreground mt-4">
          One ton of feedstock. Four streams of value. The SMER protocol orchestrates a deterministic,
          industrial-grade recovery cascade — engineered for sovereign-scale deployment.
        </p>
      </div>

      <div className="grid lg:grid-cols-[1fr_1.2fr] gap-6">
        <div className="space-y-3">
          {steps.map((s, i) => (
            <button
              key={s.n}
              onClick={() => setActive(i)}
              className={`w-full text-left transition-all ${active === i ? "scale-[1.01]" : "opacity-70 hover:opacity-100"}`}
            >
              <GlassCard
                strong={active === i}
                className={`flex items-center gap-4 ${active === i ? "border-accent/40 glow-emerald" : ""}`}
              >
                <span className="text-mono text-2xl text-muted-foreground/50">{s.n}</span>
                <div className={`h-11 w-11 rounded-xl grid place-items-center ${active === i ? "bg-accent text-accent-foreground" : "bg-secondary"}`}>
                  <s.Icon className="h-5 w-5" />
                </div>
                <div className="flex-1">
                  <div className="font-semibold">{s.title}</div>
                  <div className="text-[11px] text-muted-foreground font-mono">{s.output}</div>
                </div>
                <ArrowRight className={`h-4 w-4 transition-transform ${active === i ? "translate-x-1 text-accent" : "text-muted-foreground"}`} />
              </GlassCard>
            </button>
          ))}
        </div>

        <GlassCard strong className="min-h-[420px] relative overflow-hidden">
          <div className="absolute inset-0 grid-bg opacity-40" />
          <div className="absolute inset-x-0 h-[1px] bg-gradient-to-r from-transparent via-accent to-transparent animate-scan" />

          <motion.div
            key={active}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="relative h-full flex flex-col"
          >
            <div className="flex items-start justify-between mb-6">
              <div>
                <div className="text-[11px] font-mono tracking-[0.3em] text-accent">PHASE / {step.n}</div>
                <h3 className="text-3xl font-bold mt-2">{step.title}</h3>
              </div>
              <div className="h-16 w-16 rounded-2xl bg-gradient-to-br from-primary to-primary/30 grid place-items-center glow-emerald">
                <step.Icon className="h-7 w-7 text-primary-foreground" />
              </div>
            </div>

            <p className="text-foreground/80 leading-relaxed">{step.desc}</p>

            <div className="mt-auto pt-8 grid grid-cols-3 gap-3">
              {["Yield Efficiency", "Energy In/Out", "Co₂ Δ"].map((k, i) => (
                <div key={k} className="glass rounded-xl p-3">
                  <div className="text-[10px] text-muted-foreground tracking-widest font-mono">{k}</div>
                  <div className="text-mono text-lg font-bold text-accent mt-1">
                    {[`${88 + active * 2}%`, `1:${4 + active}.2`, `-${12 + active * 3}t`][i]}
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        </GlassCard>
      </div>
    </section>
  );
};
