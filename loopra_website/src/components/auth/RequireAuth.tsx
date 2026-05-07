import { Navigate, useLocation } from "react-router-dom";
import { Loader2 } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";

export function RequireAuth({ children }: { children: React.ReactNode }) {
  const { session, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background grid-bg">
        <div className="glass-strong rounded-2xl px-10 py-8 flex flex-col items-center gap-4 border border-border/60">
          <Loader2 className="h-8 w-8 text-primary animate-spin" />
          <p className="text-sm font-mono text-muted-foreground tracking-wide">Verifying session…</p>
        </div>
      </div>
    );
  }

  if (!session) {
    return <Navigate to="/" replace state={{ from: location.pathname, requireAuth: true }} />;
  }

  return <>{children}</>;
}
