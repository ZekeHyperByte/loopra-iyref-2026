import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";
import type { Session, User } from "@supabase/supabase-js";
import { supabase } from "@/lib/supabase";
import {
  fetchRoleNameFromUserRoles,
  normalizeRole,
  resolveAppRoleFromProfilesAndMeta,
  type AppRole,
} from "@/lib/roles";

type AuthContextValue = {
  session: Session | null;
  user: User | null;
  role: AppRole | null;
  /** Raw `role_name` from `user_roles` when present. */
  roleName: string | null;
  loading: boolean;
  roleLoading: boolean;
  signOut: () => Promise<void>;
  refreshRole: () => Promise<void>;
};

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [role, setRole] = useState<AppRole | null>(null);
  const [roleName, setRoleName] = useState<string | null>(null);
  const [roleLoading, setRoleLoading] = useState(false);

  const loadRole = useCallback(async (user: User | null) => {
    if (!user) {
      setRole(null);
      setRoleName(null);
      return;
    }
    setRoleLoading(true);
    try {
      const nameFromTable = await fetchRoleNameFromUserRoles(user.id);
      setRoleName(nameFromTable);
      const fromUserRoles = normalizeRole(nameFromTable);
      if (fromUserRoles) {
        setRole(fromUserRoles);
      } else {
        setRole(await resolveAppRoleFromProfilesAndMeta(user.id, user));
      }
    } finally {
      setRoleLoading(false);
    }
  }, []);

  useEffect(() => {
    let cancelled = false;

    supabase.auth.getSession().then(({ data: { session: next } }) => {
      if (!cancelled) {
        setSession(next);
        setLoading(false);
        void loadRole(next?.user ?? null);
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, next) => {
      setSession(next);
      void loadRole(next?.user ?? null);
    });

    return () => {
      cancelled = true;
      subscription.unsubscribe();
    };
  }, [loadRole]);

  const refreshRole = useCallback(async () => {
    const u = session?.user ?? null;
    await loadRole(u);
  }, [session?.user, loadRole]);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
    setRole(null);
    setRoleName(null);
  }, []);

  const value = useMemo(
    () => ({
      session,
      user: session?.user ?? null,
      role,
      roleName,
      loading,
      roleLoading,
      signOut,
      refreshRole,
    }),
    [session, role, roleName, loading, roleLoading, signOut, refreshRole],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
