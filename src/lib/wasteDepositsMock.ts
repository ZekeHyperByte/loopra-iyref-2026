import { getRecordedAt } from "@/lib/wasteDeposits";
import type { AppRole } from "@/lib/roles";
import type { WasteDepositRow } from "@/types/waste-deposits";

const hubs = [
  "Lampung Selatan",
  "Sidoarjo Timur",
  "Medan Belawan",
  "Makassar Hub",
  "Pontianak Barat",
  "Banyuwangi",
  "Manado Utara",
  "Kupang NTT",
];

const contributorsEnterprise = [
  { name: "Ahmad S.", asset: "Mango Peel Deposit" },
  { name: "Rina W.", asset: "Coconut Husk Deposit" },
  { name: "Budi P.", asset: "Press Mud Batch" },
  { name: "Sari L.", asset: "Bagasse Lot" },
  { name: "Joko T.", asset: "Cassava Peel Deposit" },
  { name: "Dewi K.", asset: "POME Sample" },
];

const operatorsAdmin = [
  { name: "Hendra G.", asset: "Volvo FH · fleet dispatch" },
  { name: "Lina M.", asset: "CAT 740 ADT · pit load" },
  { name: "Yudi R.", asset: "Loader scale ticket" },
  { name: "Putri A.", asset: "Weighbridge batch 4" },
  { name: "Agus K.", asset: "Night shift convoy" },
  { name: "Nina S.", asset: "Hub tip floor" },
];

function isoHoursAgo(hours: number): string {
  return new Date(Date.now() - hours * 60 * 60 * 1000).toISOString();
}

function isoDaysAgo(days: number, hour: number, minute: number): string {
  const d = new Date();
  d.setDate(d.getDate() - days);
  d.setHours(hour, minute, 0, 0);
  return d.toISOString();
}

function buildEnterpriseMock(): WasteDepositRow[] {
  const rows: WasteDepositRow[] = [];
  let id = 1;
  const add = (partial: WasteDepositRow) => {
    rows.push({
      id: `demo-${String(id++).padStart(4, "0")}`,
      validation_status: "approved",
      ...partial,
    });
  };

  const hourlyPattern: { h: number; grade: "A" | "B"; hub: number; op: number }[] = [
    { h: 1, grade: "A", hub: 0, op: 0 },
    { h: 2, grade: "A", hub: 1, op: 1 },
    { h: 3, grade: "B", hub: 2, op: 2 },
    { h: 5, grade: "A", hub: 3, op: 3 },
    { h: 7, grade: "B", hub: 4, op: 4 },
    { h: 9, grade: "A", hub: 5, op: 5 },
    { h: 11, grade: "A", hub: 0, op: 1 },
    { h: 13, grade: "B", hub: 6, op: 0 },
    { h: 15, grade: "A", hub: 7, op: 2 },
    { h: 17, grade: "B", hub: 1, op: 3 },
    { h: 19, grade: "A", hub: 2, op: 4 },
    { h: 21, grade: "A", hub: 3, op: 5 },
    { h: 22, grade: "B", hub: 4, op: 0 },
    { h: 23, grade: "A", hub: 5, op: 1 },
  ];

  for (const { h, grade, hub, op } of hourlyPattern) {
    const o = contributorsEnterprise[op];
    const ethanol = grade === "A" ? 4200 + (hub * 180) % 2100 : 800 + (op * 100) % 400;
    const biogas = grade === "B" ? 2800 + (hub * 220) % 1600 : 400 + (op * 50) % 200;
    add({
      grade,
      ai_detected_grade: grade,
      hub_name: hubs[hub],
      ethanol_yield: grade === "A" ? ethanol : ethanol * 0.15,
      biogas_potential: grade === "B" ? biogas : biogas * 0.2,
      ec_earned: grade === "A" ? 120 + (ethanol / 80) : 85 + (biogas / 100),
      carbon_prevented_tco2e: grade === "A" ? 2.1 + ethanol / 90000 : 1.4 + biogas / 12000,
      user_name: o.name,
      contributor_name: o.name,
      asset_type: o.asset,
      biofertilizer_tons: 0.8 + (hub % 5) * 0.35,
      utilization_pct: 52 + (hub * 7) % 40,
      throughput_t_per_h: 38 + (op * 3) % 12,
      created_at: isoHoursAgo(h),
    });
  }

  const daySeeds: { day: number; hour: number; grade: "A" | "B"; hub: number; op: number }[] = [
    { day: 6, hour: 9, grade: "A", hub: 0, op: 0 },
    { day: 6, hour: 14, grade: "B", hub: 2, op: 2 },
    { day: 5, hour: 10, grade: "A", hub: 1, op: 1 },
    { day: 5, hour: 15, grade: "A", hub: 3, op: 3 },
    { day: 4, hour: 8, grade: "B", hub: 4, op: 4 },
    { day: 4, hour: 16, grade: "A", hub: 5, op: 5 },
    { day: 3, hour: 11, grade: "A", hub: 6, op: 0 },
    { day: 3, hour: 13, grade: "B", hub: 7, op: 1 },
    { day: 2, hour: 9, grade: "A", hub: 0, op: 2 },
    { day: 2, hour: 17, grade: "A", hub: 2, op: 3 },
    { day: 1, hour: 10, grade: "B", hub: 1, op: 4 },
    { day: 1, hour: 14, grade: "A", hub: 4, op: 5 },
    { day: 0, hour: 8, grade: "A", hub: 3, op: 0 },
    { day: 0, hour: 12, grade: "B", hub: 5, op: 2 },
    { day: 0, hour: 18, grade: "A", hub: 6, op: 4 },
  ];

  for (const { day, hour, grade, hub, op } of daySeeds) {
    const o = contributorsEnterprise[op];
    const ethanol = grade === "A" ? 15000 + (day * 400 + hub * 200) % 8000 : 2000;
    const biogas = grade === "B" ? 9200 + (day * 300) % 5000 : 1100;
    add({
      grade,
      ai_detected_grade: grade,
      hub_name: hubs[hub],
      ethanol_yield: grade === "A" ? ethanol : 900,
      biogas_potential: grade === "B" ? biogas : 700,
      ec_earned: grade === "A" ? 410 + day * 12 : 260 + day * 8,
      carbon_prevented_tco2e: grade === "A" ? 8.2 + day * 0.35 : 5.1 + day * 0.2,
      user_name: o.name,
      contributor_name: o.name,
      asset_type: o.asset,
      biofertilizer_tons: 2.2 + (day % 4) * 0.5,
      utilization_pct: 60 + (day + hub * 3) % 28,
      throughput_t_per_h: 42 + (op + day) % 15,
      created_at: isoDaysAgo(day, hour, 20),
    });
  }

  rows.push(
    {
      id: "demo-pending-001",
      grade: "A",
      ai_detected_grade: "A",
      hub_name: "Lampung Selatan",
      ethanol_yield: 19200,
      biogas_potential: 800,
      ec_earned: 512,
      carbon_prevented_tco2e: 9.4,
      user_name: "Eko H.",
      contributor_name: "Eko H.",
      asset_type: "Jackfruit Peel Deposit",
      validation_status: "pending",
      utilization_pct: 78,
      created_at: isoHoursAgo(4),
    },
    {
      id: "demo-pending-002",
      grade: "B",
      ai_detected_grade: "B",
      hub_name: "Medan Belawan",
      ethanol_yield: 1200,
      biogas_potential: 8400,
      ec_earned: 288,
      carbon_prevented_tco2e: 4.8,
      user_name: "Mira P.",
      contributor_name: "Mira P.",
      asset_type: "Digester Overflow Sample",
      validation_status: "submitted",
      utilization_pct: 44,
      created_at: isoHoursAgo(8),
    },
  );

  rows.sort((a, b) => (getRecordedAt(a)?.getTime() ?? 0) - (getRecordedAt(b)?.getTime() ?? 0));
  return rows;
}

/** Logistics / ops–heavy demo: higher tonnage & utilization, fleet asset labels. */
function buildAdminMock(): WasteDepositRow[] {
  const base = buildEnterpriseMock();
  return base.map((r, i) => {
    const op = operatorsAdmin[i % operatorsAdmin.length];
    const isPending = r.id?.startsWith("demo-pending");
    return {
      ...r,
      user_name: isPending ? r.user_name : op.name,
      contributor_name: isPending ? r.contributor_name ?? r.user_name : op.name,
      asset_type: isPending ? r.asset_type : op.asset,
      biofertilizer_tons: ((r.biofertilizer_tons ?? 0) + 0.4) * 4.5,
      ethanol_yield: (r.ethanol_yield ?? 0) * 0.42,
      biogas_potential: (r.biogas_potential ?? 0) * 0.62,
      ec_earned: (r.ec_earned ?? 0) * 0.55,
      utilization_pct: isPending ? r.utilization_pct : Math.min(99, 71 + (i * 13) % 28),
      throughput_t_per_h: ((r.throughput_t_per_h ?? 0) + 2) * 1.75,
    };
  });
}

export function getMockWasteDeposits(role: AppRole): WasteDepositRow[] {
  return role === "ADMIN" ? buildAdminMock() : buildEnterpriseMock();
}
