import { Outlet, useNavigate } from "react-router-dom";
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AppSidebar } from "./AppSidebar";
import { Bell, LogOut, Search, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/contexts/AuthContext";

export const DashboardLayout = () => {
  const { signOut, user } = useAuth();
  const navigate = useNavigate();

  const onSignOut = async () => {
    await signOut();
    navigate("/login", { replace: true });
  };

  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-background">
        <AppSidebar />
        <div className="flex-1 flex flex-col min-w-0">
          <header className="h-14 flex items-center gap-3 px-4 border-b border-border/60 glass-strong sticky top-0 z-30">
            <SidebarTrigger className="text-muted-foreground" />
            <div className="hidden md:flex items-center gap-2 glass rounded-lg px-3 py-1.5 w-72">
              <Search className="h-3.5 w-3.5 text-muted-foreground" />
              <input
                placeholder="Search hubs, assays, credits…"
                className="bg-transparent text-sm outline-none flex-1 placeholder:text-muted-foreground/60"
              />
              <kbd className="text-[10px] font-mono text-muted-foreground border border-border/60 rounded px-1.5">⌘K</kbd>
            </div>
            <div className="flex-1" />
            <div className="hidden sm:flex items-center gap-2 text-xs font-mono text-muted-foreground">
              <span className="h-1.5 w-1.5 rounded-full bg-success animate-pulse" />
              <span>SYS · OPERATIONAL · 142 HUBS</span>
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
              <span className="hidden sm:inline text-xs">Sign out</span>
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
          <main className="flex-1 overflow-auto">
            <Outlet />
          </main>
        </div>
      </div>
    </SidebarProvider>
  );
};
