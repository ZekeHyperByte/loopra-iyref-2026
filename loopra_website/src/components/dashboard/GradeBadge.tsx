import { cn } from "@/lib/utils";
import { normalizeGrade } from "@/lib/wasteDeposits";
import type { WasteDepositRow } from "@/types/waste-deposits";

/** Shared Grade A / B visuals (match mobile: emerald ring vs slate ring). */
export function GradeIcon({ grade, className }: { grade: "A" | "B"; className?: string }) {
  if (grade === "A") {
    return (
      <span
        className={cn(
          "inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full border border-emerald-400/60 bg-emerald-500/15 text-[10px] font-bold text-emerald-200",
          className,
        )}
        aria-hidden
      >
        A
      </span>
    );
  }
  return (
    <span
      className={cn(
        "inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full border border-slate-500/50 bg-slate-500/15 text-[10px] font-bold text-slate-200",
        className,
      )}
      aria-hidden
    >
      B
    </span>
  );
}

export function GradeBadge({ row, className }: { row: WasteDepositRow; className?: string }) {
  const g = normalizeGrade(row);
  if (!g) {
    return <span className={cn("text-xs text-muted-foreground", className)}>—</span>;
  }
  return (
    <span className={cn("inline-flex items-center gap-2", className)}>
      <GradeIcon grade={g} />
      <span className="text-xs font-medium text-foreground">Grade {g}</span>
    </span>
  );
}

/** Hub matrix / charts where only A|B is known (same ring icons as mobile). */
export function GradeBadgeLetter({ grade, className }: { grade: "A" | "B"; className?: string }) {
  return (
    <span className={cn("inline-flex items-center gap-2", className)}>
      <GradeIcon grade={grade} />
      <span className="text-xs font-medium text-foreground">Grade {grade}</span>
    </span>
  );
}
