import { Outlet, useNavigate } from "react-router-dom";
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AppSidebar } from "./AppSidebar";
import { Bell, LogOut, Search, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/contexts/AuthContext";
import { DashboardDataProvider, useDashboardData } from "@/contexts/DashboardDataContext";
import { getContributorDisplayName, getHubLabel, getRecordedAt } from "@/lib/wasteDeposits";
import { toast } from "sonner";
import { formatDistanceToNow } from "date-fns";

function DashboardShell() {
  const { signOut, user, role, roleLoading } = useAuth();
  const navigate = useNavigate();
  const { activitySearch, setActivitySearch, recentActivity, isDemoData } = useDashboardData();

  const portalTitle =
    roleLoading || !role ? "COMMAND CENTER" : role === "ADMIN" ? "ADMIN COMMAND CENTER" : "ENTERPRISE PORTAL";

  const onSignOut = async () => {
    await signOut();
    toast.success("You have been signed out.");
    navigate("/", { replace: true });
  };

  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-background">
        <AppSidebar />
        <div className="flex-1 flex flex-col min-w-0">
          <header className="h-14 flex items-center gap-3 px-4 border-b border-border/60 glass-strong sticky top-0 z-30">
            <SidebarTrigger className="text-muted-foreground" />
            <div className="hidden lg:flex shrink-0 items-center px-2 py-1 rounded-md border border-accent/25 bg-accent/5">
              <span className="text-[10px] font-mono font-bold tracking-[0.2em] text-accent">{portalTitle}</span>
            </div>
            <div className="hidden md:flex items-center gap-2 glass rounded-lg px-3 py-1.5 flex-1 max-w-md">
              <Search className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
              <input
                value={activitySearch}
                onChange={(e) => setActivitySearch(e.target.value)}
                placeholder="Filter by contributor or asset type…"
                className="bg-transparent text-sm outline-none flex-1 placeholder:text-muted-foreground/60 min-w-0"
                aria-label="Filter recent activity"
              />
            </div>
            <div className="flex-1 md:hidden" />
            <div className="hidden sm:flex items-center gap-2 text-xs font-mono text-muted-foreground">
              <span
                className={`h-1.5 w-1.5 rounded-full animate-pulse ${isDemoData ? "bg-warning" : "bg-success"}`}
              />
              <span>{isDemoData ? "DEMO · SAMPLE DATA" : "LIVE · WASTE DEPOSITS"}</span>
            </div>
            <Button variant="ghost" size="icon" className="h-8 w-8">
              <Bell className="h-4 w-4" />
            </Button>
            <Button
              variant="ghost"
              size="sm"
              className="h-8 gap-1.5 text-muted-foreground hover:text-foreground"
              onClick={onSignOut}
            >
              <LogOut className="h-3.5 w-3.5" />
              <span className="hidden sm:inline text-xs">Logout</span>
            </Button>
            <button type="button" className="flex items-center gap-2 glass rounded-lg pl-1 pr-2 py-1 max-w-[200px]">
              <div className="h-7 w-7 shrink-0 rounded-md bg-gradient-to-br from-accent to-primary grid place-items-center text-[10px] font-bold text-background">
                {(user?.email?.[0] ?? "?").toUpperCase()}
              </div>
              <div className="text-left hidden sm:block min-w-0">
                <div className="text-xs font-semibold leading-tight truncate">
                  {user?.email ?? "Signed in"}
                </div>
                <div className="text-[10px] text-muted-foreground leading-tight">Session active</div>
              </div>
              <ChevronDown className="h-3 w-3 text-muted-foreground shrink-0" />
            </button>
          </header>

          {isDemoData && (
            <div className="bg-warning/10 border-b border-warning/25 px-4 py-2 text-center text-[11px] font-mono text-warning leading-snug">
              Database returned no rows — showing realistic demo fixtures. Insert into{" "}
              <span className="text-foreground/90">waste_deposits</span> to switch to live telemetry.
            </div>
          )}

          <div className="border-b border-border/40 bg-secondary/20 px-4 py-2 shrink-0">
            <div className="text-[10px] font-mono tracking-widest text-muted-foreground mb-1.5">RECENT ACTIVITY</div>
            <div className="flex gap-2 overflow-x-auto pb-1">
              {recentActivity.length === 0 ? (
                <span className="text-xs text-muted-foreground py-1">No deposit events match this filter.</span>
              ) : (
                recentActivity.map((row) => {
                  const t = getRecordedAt(row);
                  const when = t ? formatDistanceToNow(t, { addSuffix: true }) : "—";
                  const hub = getHubLabel(row);
                  const who = getContributorDisplayName(row);
                  const asset = (row.asset_type ?? "Deposit").trim() || "Deposit";
                  return (
                    <div
                      key={`${row.id ?? hub}-${when}-${who}`}
                      className="shrink-0 glass rounded-lg px-3 py-2 min-w-[220px] border border-border/50"
                    >
                      <div className="text-[11px] font-medium truncate">
                        {who} — <span className="text-accent">{asset}</span>
                      </div>
                      <div className="text-[10px] text-muted-foreground truncate">{hub}</div>
                      <div className="text-[9px] font-mono text-muted-foreground/80 mt-0.5">{when}</div>
                    </div>
                  );
                })
              )}
            </div>
          </div>

          <main className="flex-1 overflow-auto">
            <Outlet />
          </main>
        </div>
      </div>
    </SidebarProvider>
  );
}

export const DashboardLayout = () => (
  <DashboardDataProvider>
    <DashboardShell />
  </DashboardDataProvider>
);
