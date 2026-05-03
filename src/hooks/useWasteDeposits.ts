import { useCallback, useEffect, useState } from "react";
import { supabase } from "@/lib/supabase";
import { getRecordedAt } from "@/lib/wasteDeposits";
import type { WasteDepositRow } from "@/types/waste-deposits";

export function useWasteDeposits() {
  const [rows, setRows] = useState<WasteDepositRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchRows = useCallback(async (isInitial: boolean) => {
    if (isInitial) setLoading(true);
    setError(null);

    const { data, error: qErr } = await supabase.from("waste_deposits").select("*");

    if (qErr) {
      setError(qErr.message);
      setRows([]);
    } else {
      const raw = (data ?? []) as WasteDepositRow[];
      raw.sort((a, b) => (getRecordedAt(a)?.getTime() ?? 0) - (getRecordedAt(b)?.getTime() ?? 0));
      setRows(raw);
    }
    if (isInitial) setLoading(false);
  }, []);

  useEffect(() => {
    let cancelled = false;

    const run = async () => {
      if (cancelled) return;
      await fetchRows(true);
    };
    void run();

    const channel = supabase
      .channel("waste_deposits_live")
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

  return { rows, loading, error, refetch: () => fetchRows(false) };
}
