import { cn } from "@/lib/utils";

type LogoProps = {
  className?: string;
  /** Smaller wordmark + icon for dense headers (e.g. sidebar). */
  compact?: boolean;
};

export const Logo = ({ className, compact }: LogoProps) => {
  return (
    <div className={cn("flex items-center gap-2", className)}>
      <img
        src="/logo-loopra.svg"
        alt="Loopra Logo"
        className={cn(compact ? "h-6 w-auto" : "h-8 w-auto")}
      />
      <span
        className={cn(
          "font-bold tracking-tight text-white",
          compact ? "text-base" : "text-xl",
        )}
      >
        loopra<span className="text-primary">.</span>
      </span>
    </div>
  );
};
