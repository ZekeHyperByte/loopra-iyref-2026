/**
 * Expected `waste_deposits` columns (map your table to these names in Supabase, or extend parsers in wasteDeposits.ts).
 * - grade / assay_grade: "A" | "B"
 * - ethanol_yield_liters (or ethanol_yield): summed for Grade A inventory + area series
 * - biogas_potential_m3 (or biogas_potential): summed for Grade B inventory
 * - biofertilizer_tons / fertilizer_pellets_tons: optional, stat card 3
 * - throughput_t_per_h / daily_throughput_tph: optional, stat card 4 (mean)
 * - hub_name / location_name: hub matrix
 * - utilization_pct: optional hub table
 * - ec_earned: energy credits (summed for “Total Energy Credits”)
 * - carbon_prevented_tco2e: optional tCO₂e for ESG reporting
 * - user_name, asset_type: activity / search filters
 * - validation_status: pending | approved | rejected (mobile deposit review)
 * - created_at / recorded_at: time bucketing for charts
 */
export type WasteDepositRow = {
  id?: string;
  grade?: string | null;
  assay_grade?: string | null;
  ec_earned?: number | null;
  ethanol_yield_liters?: number | null;
  ethanol_yield?: number | null;
  biogas_potential_m3?: number | null;
  biogas_potential?: number | null;
  carbon_prevented_tco2e?: number | null;
  carbon_prevented?: number | null;
  user_name?: string | null;
  /** Display name for mobile contributor (falls back to user_name). */
  contributor_name?: string | null;
  asset_type?: string | null;
  /** Optional AI-only grade; if absent, `grade` / `assay_grade` is used. */
  ai_detected_grade?: string | null;
  validation_status?: string | null;
  biofertilizer_tons?: number | null;
  fertilizer_pellets_tons?: number | null;
  throughput_t_per_h?: number | null;
  daily_throughput_tph?: number | null;
  utilization_pct?: number | null;
  hub_name?: string | null;
  location_name?: string | null;
  created_at?: string | null;
  recorded_at?: string | null;
};
