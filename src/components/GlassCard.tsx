import { cn } from "@/lib/utils";
import { HTMLAttributes, forwardRef } from "react";

interface GlassCardProps extends HTMLAttributes<HTMLDivElement> {
  glow?: boolean;
  strong?: boolean;
}

export const GlassCard = forwardRef<HTMLDivElement, GlassCardProps>(
  ({ className, glow, strong, ...props }, ref) => (
    <div
      ref={ref}
      className={cn(
        strong ? "glass-strong" : "glass",
        "rounded-2xl p-5 relative overflow-hidden transition-all",
        glow && "hover:glow-emerald",
        className
      )}
      {...props}
    />
  )
);
GlassCard.displayName = "GlassCard";
