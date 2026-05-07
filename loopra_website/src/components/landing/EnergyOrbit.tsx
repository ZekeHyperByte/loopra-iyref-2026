import { motion } from "framer-motion";
import { Recycle, FlaskConical, Flame, Leaf } from "lucide-react";

const orbits = [
  { Icon: Recycle, label: "Feedstock", color: "hsl(75 100% 50%)", angle: 0 },
  { Icon: FlaskConical, label: "Bio-ethanol", color: "hsl(182 97% 50%)", angle: 90 },
  { Icon: Flame, label: "Biogas", color: "hsl(38 100% 55%)", angle: 180 },
  { Icon: Leaf, label: "Bio-fertilizer", color: "hsl(142 76% 50%)", angle: 270 },
];

export const EnergyOrbit = () => {
  return (
    <div className="relative aspect-square w-full max-w-[520px] mx-auto">
      {/* glow */}
      <div className="absolute inset-1/4 rounded-full bg-primary/30 blur-3xl" />
      <div className="absolute inset-1/3 rounded-full bg-accent/20 blur-3xl" />

      {/* orbit rings */}
      {[1, 0.78, 0.55].map((scale, i) => (
        <motion.div
          key={i}
          className="absolute inset-0 rounded-full border border-primary/20"
          style={{ transform: `scale(${scale})` }}
          animate={{ rotate: i % 2 ? -360 : 360 }}
          transition={{ duration: 30 + i * 10, repeat: Infinity, ease: "linear" }}
        >
          <div
            className="absolute h-2 w-2 rounded-full bg-accent shadow-[0_0_12px_hsl(75_100%_50%)]"
            style={{ top: "-4px", left: "50%" }}
          />
        </motion.div>
      ))}

      {/* center core */}
      <motion.div
        className="absolute inset-[40%] rounded-full glass-strong grid place-items-center border-primary/40"
        animate={{ scale: [1, 1.06, 1] }}
        transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
      >
        <div className="text-center">
          <div className="text-[10px] tracking-[0.3em] text-accent font-mono">SMER</div>
          <div className="text-xs font-bold">CORE</div>
        </div>
        <div className="absolute inset-0 rounded-full ring-2 ring-accent/40 animate-pulse-dot" />
      </motion.div>

      {/* orbiting nodes */}
      <motion.div
        className="absolute inset-0"
        animate={{ rotate: 360 }}
        transition={{ duration: 40, repeat: Infinity, ease: "linear" }}
      >
        {orbits.map(({ Icon, label, color, angle }) => {
          const rad = (angle * Math.PI) / 180;
          const x = Math.cos(rad) * 45;
          const y = Math.sin(rad) * 45;
          return (
            <motion.div
              key={label}
              className="absolute"
              style={{
                top: `calc(50% + ${y}%)`,
                left: `calc(50% + ${x}%)`,
                transform: "translate(-50%, -50%)",
              }}
              animate={{ rotate: -360 }}
              transition={{ duration: 40, repeat: Infinity, ease: "linear" }}
            >
              <div
                className="glass-strong rounded-2xl p-3 flex flex-col items-center gap-1 min-w-[88px]"
                style={{ borderColor: color + "55", boxShadow: `0 0 24px ${color}33` }}
              >
                <Icon className="h-5 w-5" style={{ color }} />
                <div className="text-[10px] font-medium text-foreground/80">{label}</div>
              </div>
            </motion.div>
          );
        })}
      </motion.div>
    </div>
  );
};
