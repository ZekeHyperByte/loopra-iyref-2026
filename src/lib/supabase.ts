import { createClient } from "@supabase/supabase-js";

/** Supabase client expects the project base URL (e.g. https://xxx.supabase.co), not the REST API path. */
function normalizeSupabaseUrl(raw: string): string {
  return raw.replace(/\/rest\/v1\/?$/i, "").replace(/\/$/, "");
}

const url = normalizeSupabaseUrl(import.meta.env.VITE_SUPABASE_URL ?? "");
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY ?? "";

export const supabase = createClient(url, anonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
});

/** @deprecated Use AppRole from @/lib/roles */
export type PortalRole = "enterprise_partner" | "admin";
