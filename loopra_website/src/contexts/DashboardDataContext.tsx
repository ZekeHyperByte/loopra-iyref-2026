import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";
import { supabase } from "@/lib/supabase";
import { useAuth } from "@/contexts/AuthContext";
import { buildRecentActivity, getRecordedAt } from "@/lib/wasteDeposits";
import { getMockWasteDeposits } from "@/lib/wasteDepositsMock";
import type { WasteDepositRow } from "@/types/waste-deposits";
import type { AppRole } from "@/lib/roles";

type DashboardDataContextValue = {
  rows: WasteDepositRow[];
  isDemoData: boolean;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
  activitySearch: string;
  setActivitySearch: (q: string) => void;
  recentActivity: WasteDepositRow[];
};

const DashboardDataContext = createContext<DashboardDataContextValue | undefined>(undefined);

export function DashboardDataProvider({ children }: { children: ReactNode }) {
  const { role, roleLoading } = useAuth();
  const [rows, setRows] = useState<WasteDepositRow[]>([]);
  const [isDemoData, setIsDemoData] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activitySearch, setActivitySearch] = useState("");

  const applyEmptyOrLive = useCallback((raw: WasteDepositRow[], effectiveRole: AppRole) => {
    if (raw.length === 0) {
      setRows(getMockWasteDeposits(effectiveRole));
      setIsDemoData(true);
    } else {
      const sorted = [...raw].sort(
        (a, b) => (getRecordedAt(a)?.getTime() ?? 0) - (getRecordedAt(b)?.getTime() ?? 0),
      );
      setRows(sorted);
      setIsDemoData(false);
    }
  }, []);

  const fetchRows = useCallback(
    async (isInitial: boolean) => {
      if (isInitial) setLoading(true);
      setError(null);

      const effectiveRole = role ?? "ENTERPRISE";

      const { data, error: qErr } = await supabase.from("waste_deposits").select("*");

      if (qErr) {
        setError(qErr.message);
        setRows([]);
        setIsDemoData(false);
      } else {
        const raw = (data ?? []) as WasteDepositRow[];
        applyEmptyOrLive(raw, effectiveRole);
      }
      if (isInitial) setLoading(false);
    },
    [role, applyEmptyOrLive],
  );

  useEffect(() => {
    if (roleLoading) return;
    if (!isDemoData || !role) return;
    setRows(getMockWasteDeposits(role));
  }, [role, roleLoading, isDemoData]);

  useEffect(() => {
    let cancelled = false;

    void (async () => {
      if (cancelled) return;
      await fetchRows(true);
    })();

    const channel = supabase
      .channel("dashboard_waste_deposits")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "waste_deposits" },
        () => {
          if (!cancelled) void fetchRows(false);
        },
      )
      .subscribe();

    return () => {
      cancelled = true;
      void supabase.removeChannel(channel);
    };
  }, [fetchRows]);

  const recentActivity = useMemo(
    () => buildRecentActivity(rows, activitySearch, 24),
    [rows, activitySearch],
  );

  const value = useMemo(
    () => ({
      rows,
      isDemoData,
      loading,
      error,
      refetch: () => fetchRows(false),
      activitySearch,
      setActivitySearch,
      recentActivity,
    }),
    [rows, isDemoData, loading, error, fetchRows, activitySearch, recentActivity],
  );

  return <DashboardDataContext.Provider value={value}>{children}</DashboardDataContext.Provider>;
}

export function useDashboardData() {
  const ctx = useContext(DashboardDataContext);
  if (!ctx) throw new Error("useDashboardData must be used within DashboardDataProvider");
  return ctx;
}
