import type { WasteDepositRow } from "@/types/waste-deposits";

export function normalizeGrade(row: WasteDepositRow): "A" | "B" | null {
  const g = (row.grade ?? row.assay_grade ?? "").toString().trim().toUpperCase();
  if (g === "A" || g === "GRADE A" || g === "GRADEA") return "A";
  if (g === "B" || g === "GRADE B" || g === "GRADEB") return "B";
  if (g.length === 1 && (g === "A" || g === "B")) return g as "A" | "B";
  return null;
}

export function getEthanolLiters(row: WasteDepositRow): number {
  const v = row.ethanol_yield_liters ?? row.ethanol_yield;
  return typeof v === "number" && !Number.isNaN(v) ? v : 0;
}

export function getBiogasM3(row: WasteDepositRow): number {
  const v = row.biogas_potential_m3 ?? row.biogas_potential;
  return typeof v === "number" && !Number.isNaN(v) ? v : 0;
}

export function getFertilizerTons(row: WasteDepositRow): number {
  const v = row.biofertilizer_tons ?? row.fertilizer_pellets_tons;
  return typeof v === "number" && !Number.isNaN(v) ? v : 0;
}

export function getThroughput(row: WasteDepositRow): number | null {
  const v = row.throughput_t_per_h ?? row.daily_throughput_tph;
  if (typeof v === "number" && !Number.isNaN(v)) return v;
  return null;
}

export function getRecordedAt(row: WasteDepositRow): Date | null {
  const raw = row.created_at ?? row.recorded_at;
  if (!raw) return null;
  const d = new Date(raw);
  return Number.isNaN(d.getTime()) ? null : d;
}

export function getHubLabel(row: WasteDepositRow): string {
  return (row.hub_name ?? row.location_name ?? "Unassigned hub").trim() || "Unassigned hub";
}

export type InventoryTotals = {
  ethanolGradeALiters: number;
  biogasGradeBM3: number;
  fertilizerTons: number;
  avgThroughputTph: number | null;
};

export function computeInventoryTotals(rows: WasteDepositRow[]): InventoryTotals {
  let ethanolGradeALiters = 0;
  let biogasGradeBM3 = 0;
  let fertilizerTons = 0;
  const throughputSamples: number[] = [];

  for (const row of rows) {
    const g = normalizeGrade(row);
    if (g === "A") ethanolGradeALiters += getEthanolLiters(row);
    if (g === "B") biogasGradeBM3 += getBiogasM3(row);
    fertilizerTons += getFertilizerTons(row);
    const tph = getThroughput(row);
    if (tph !== null) throughputSamples.push(tph);
  }

  const avgThroughputTph =
    throughputSamples.length > 0
      ? throughputSamples.reduce((a, b) => a + b, 0) / throughputSamples.length
      : null;

  return { ethanolGradeALiters, biogasGradeBM3, fertilizerTons, avgThroughputTph };
}

/** Last N hours, hourly buckets: Grade A ethanol (liters) per bucket for area chart. */
export function buildGradeAEthanolHourlySeries(
  rows: WasteDepositRow[],
  bucketCount = 24,
): { label: string; v: number }[] {
  const end = Date.now();
  const hourMs = 60 * 60 * 1000;
  const series: { label: string; v: number }[] = [];

  for (let i = bucketCount - 1; i >= 0; i--) {
    const bucketEnd = end - i * hourMs;
    const bucketStart = bucketEnd - hourMs;
    const d = new Date(bucketEnd);
    const label = d.toLocaleTimeString(undefined, { hour: "2-digit", minute: "2-digit", hour12: false });

    let v = 0;
    for (const row of rows) {
      if (normalizeGrade(row) !== "A") continue;
      const t = getRecordedAt(row);
      if (!t) continue;
      const ts = t.getTime();
      if (ts >= bucketStart && ts < bucketEnd) v += getEthanolLiters(row);
    }
    series.push({ label, v });
  }

  return series;
}

/** Last N hours, hourly buckets: Grade B biogas potential (m³) per bucket. */
export function buildGradeBBiogasHourlySeries(
  rows: WasteDepositRow[],
  bucketCount = 24,
): { label: string; v: number }[] {
  const end = Date.now();
  const hourMs = 60 * 60 * 1000;
  const series: { label: string; v: number }[] = [];

  for (let i = bucketCount - 1; i >= 0; i--) {
    const bucketEnd = end - i * hourMs;
    const bucketStart = bucketEnd - hourMs;
    const d = new Date(bucketEnd);
    const label = d.toLocaleTimeString(undefined, { hour: "2-digit", minute: "2-digit", hour12: false });

    let v = 0;
    for (const row of rows) {
      if (normalizeGrade(row) !== "B") continue;
      const t = getRecordedAt(row);
      if (!t) continue;
      const ts = t.getTime();
      if (ts >= bucketStart && ts < bucketEnd) v += getBiogasM3(row);
    }
    series.push({ label, v });
  }

  return series;
}

export function seriesHalfDeltaPct(points: { v: number }[]): number | null {
  if (points.length < 4) return null;
  const mid = Math.floor(points.length / 2);
  const first = points.slice(0, mid).reduce((s, p) => s + p.v, 0);
  const second = points.slice(mid).reduce((s, p) => s + p.v, 0);
  if (first === 0 && second === 0) return null;
  if (first === 0) return second > 0 ? 100 : null;
  return ((second - first) / first) * 100;
}

export type HubAggregateRow = {
  name: string;
  grade: "A" | "B";
  ethanol: number;
  biogas: number;
  util: number;
  trend: number;
};

/** Group rows by hub; grade = dominant by deposit count; util = latest non-null avg. */
export function aggregateHubs(rows: WasteDepositRow[], limit = 6): HubAggregateRow[] {
  type Acc = {
    ethanol: number;
    biogas: number;
    gradeCount: { A: number; B: number };
    utilSum: number;
    utilN: number;
  };
  const map = new Map<string, Acc>();

  for (const row of rows) {
    const name = getHubLabel(row);
    const g = normalizeGrade(row);
    let acc = map.get(name);
    if (!acc) {
      acc = { ethanol: 0, biogas: 0, gradeCount: { A: 0, B: 0 }, utilSum: 0, utilN: 0 };
      map.set(name, acc);
    }
    acc.ethanol += getEthanolLiters(row);
    acc.biogas += getBiogasM3(row);
    if (g === "A") acc.gradeCount.A += 1;
    if (g === "B") acc.gradeCount.B += 1;
    const u = row.utilization_pct;
    if (typeof u === "number" && !Number.isNaN(u)) {
      acc.utilSum += u;
      acc.utilN += 1;
    }
  }

  const list: HubAggregateRow[] = [...map.entries()].map(([name, acc]) => {
    const grade: "A" | "B" = acc.gradeCount.A >= acc.gradeCount.B ? "A" : "B";
    const util = acc.utilN > 0 ? Math.round(acc.utilSum / acc.utilN) : 0;
    return {
      name,
      grade,
      ethanol: Math.round(acc.ethanol),
      biogas: Math.round(acc.biogas),
      util: Math.min(100, util),
      trend: 0,
    };
  });

  list.sort((a, b) => b.ethanol + b.biogas - (a.ethanol + a.biogas));
  return list.slice(0, limit);
}
