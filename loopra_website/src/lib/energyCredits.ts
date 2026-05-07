import type { WasteDepositRow } from "@/types/waste-deposits";
import { sumEcEarned } from "@/lib/wasteDeposits";

/**
 * Total Energy Credits for dashboards (web + mobile parity).
 * Same rule as mobile: sum of `ec_earned` on each `waste_deposits` row.
 */
export function getTotalEnergyCreditsFromDeposits(rows: WasteDepositRow[]): number {
  return sumEcEarned(rows);
}

/**
 * IDR mark-to-market per EC for feedstock valuation (keep in sync with mobile pricing config if defined there).
 */
export const ENERGY_CREDIT_IDR_PER_UNIT = 48_750;

export function getTotalAssetValueIdrFromDeposits(rows: WasteDepositRow[]): number {
  return Math.round(getTotalEnergyCreditsFromDeposits(rows) * ENERGY_CREDIT_IDR_PER_UNIT);
}

export function formatIdrCompact(value: number): string {
  return new Intl.NumberFormat("id-ID", {
    style: "currency",
    currency: "IDR",
    maximumFractionDigits: 0,
  }).format(value);
}
