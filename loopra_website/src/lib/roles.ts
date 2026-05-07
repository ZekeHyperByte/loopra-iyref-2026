import type { User } from "@supabase/supabase-js";
import { supabase } from "@/lib/supabase";

export type AppRole = "ENTERPRISE" | "ADMIN";

/** Primary source: `user_roles.role_name` for the signed-in user. */
export async function fetchRoleNameFromUserRoles(userId: string): Promise<string | null> {
  const { data, error } = await supabase.from("user_roles").select("role_name").eq("user_id", userId).maybeSingle();

  if (error || !data) return null;
  const row = data as { role_name?: string | null };
  return row.role_name ?? null;
}

/** Fallback when `user_roles` has no row: `profiles` → auth metadata. */
export async function resolveAppRoleFromProfilesAndMeta(userId: string, user: User): Promise<AppRole> {
  const { data: profile } = await supabase.from("profiles").select("role").eq("id", userId).maybeSingle();

  if (profile?.role != null) {
    const normalized = normalizeRole(profile.role);
    if (normalized) return normalized;
  }

  const fromMeta =
    user.user_metadata?.role ??
    user.user_metadata?.portal ??
    user.app_metadata?.role ??
    user.app_metadata?.portal;

  return normalizeRole(fromMeta) ?? "ENTERPRISE";
}

export function normalizeRole(raw: unknown): AppRole | null {
  if (raw == null) return null;
  const s = String(raw).toUpperCase().replace(/-/g, "_").trim();
  if (s === "ADMIN") return "ADMIN";
  if (s === "ENTERPRISE") return "ENTERPRISE";
  if (s === "ENTERPRISE_PARTNER" || s === "PARTNER" || raw === "enterprise_partner") return "ENTERPRISE";
  if (raw === "admin") return "ADMIN";
  return null;
}

export const USER_ROLE_METADATA_KEY = "role";

export function defaultDashboardPath(_role: AppRole): string {
  return "/dashboard";
}
