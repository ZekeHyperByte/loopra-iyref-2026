import { Navigate } from "react-router-dom";
import { Loader2 } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { defaultDashboardPath, type AppRole } from "@/lib/roles";

export function RoleRoute({ allow, children }: { allow: AppRole[]; children: React.ReactNode }) {
  const { role, roleLoading, session } = useAuth();

  if (!session) {
    return <Navigate to="/" replace />;
  }

  if (roleLoading || role == null) {
    return (
      <div className="min-h-[40vh] flex items-center justify-center">
        <Loader2 className="h-8 w-8 text-primary animate-spin" />
      </div>
    );
  }

  if (!allow.includes(role)) {
    return <Navigate to={defaultDashboardPath(role)} replace />;
  }

  return <>{children}</>;
}
