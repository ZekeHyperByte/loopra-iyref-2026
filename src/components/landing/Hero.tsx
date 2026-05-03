import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { ArrowRight, Cpu, ShieldCheck, Activity } from "lucide-react";
import { EnergyOrbit } from "./EnergyOrbit";
import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";

export const Hero = () => {
  const { session } = useAuth();
  const commandTarget = session ? "/dashboard" : "/login";

  return (
    <section className="relative pt-36 pb-24 overflow-hidden">
      <div className="absolute inset-0 grid-bg opacity-30 [mask-image:radial-gradient(ellipse_at_center,black_30%,transparent_70%)]" />
      <div className="absolute top-1/3 left-1/2 -translate-x-1/2 h-[500px] w-[800px] rounded-full bg-primary/20 blur-[120px]" />

      <div className="container relative grid lg:grid-cols-[1.1fr_1fr] gap-10 items-center">
        <div>
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="inline-flex items-center gap-2 glass rounded-full px-3 py-1.5 mb-6"
          >
            <span className="h-1.5 w-1.5 rounded-full bg-accent animate-pulse-dot" />
            <span className="text-[11px] font-mono tracking-[0.25em] text-foreground/80">
              SOVEREIGN BIO-ENERGY · INDONESIA · v2.4
            </span>
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="text-4xl md:text-6xl lg:text-7xl font-bold tracking-tight leading-[1.05]"
          >
            Digitalizing Indonesia's{" "}
            <span className="text-gradient-emerald">Bio-Energy Supply Chain</span>.
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
            className="text-lg text-muted-foreground mt-6 max-w-xl"
          >
            Loopra is the operating system for renewable energy logistics orchestrating feedstock
            standardization, multi energy recovery, and verified carbon credits across an archipelagic
            nation.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
            className="flex flex-wrap items-center gap-3 mt-8"
          >
            <Button asChild size="lg" className="bg-accent text-accent-foreground hover:bg-accent/90 font-semibold glow-lime">
              <Link to={commandTarget}>
                Enter Command Center <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
            <Button size="lg" variant="outline" className="border-primary/40 hover:bg-primary/10">
              Read Whitepaper
            </Button>
          </motion.div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5 }}
            className="grid grid-cols-3 gap-4 mt-12 max-w-xl"
          >
            {[
              { Icon: Activity, k: "Hubs Online", v: "142" },
              { Icon: Cpu, k: "AI Assays / day", v: "38.4k" },
              { Icon: ShieldCheck, k: "Audit Coverage", v: "100%" },
            ].map((s) => (
              <div key={s.k} className="glass rounded-xl p-3">
                <s.Icon className="h-4 w-4 text-accent mb-2" />
                <div className="text-mono text-xl font-bold">{s.v}</div>
                <div className="text-[10px] text-muted-foreground tracking-widest font-mono uppercase">{s.k}</div>
              </div>
            ))}
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.2, duration: 0.8 }}
        >
          <EnergyOrbit />
        </motion.div>
      </div>
    </section>
  );
};
