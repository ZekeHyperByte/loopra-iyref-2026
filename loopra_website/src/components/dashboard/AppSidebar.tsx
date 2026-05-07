import { NavLink, useLocation } from "react-router-dom";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarFooter,
  SidebarHeader,
} from "@/components/ui/sidebar";
import { LayoutDashboard, FileText, Coins, Truck, Building2, ShieldCheck, ArrowLeft } from "lucide-react";
import { Logo } from "@/components/Logo";
import { Skeleton } from "@/components/ui/skeleton";
import { useAuth } from "@/contexts/AuthContext";
import type { AppRole } from "@/lib/roles";

const enterpriseGroups = [
  {
    label: "Enterprise supply",
    items: [
      { title: "Inventory Levels", url: "/dashboard/inventory", icon: LayoutDashboard, end: true },
      { title: "Carbon Credits", url: "/dashboard/ledger", icon: Coins },
      { title: "ESG Reports", url: "/dashboard/esg-reports", icon: FileText },
    ],
  },
];

const adminGroups = [
  {
    label: "Operations",
    items: [
      { title: "Fleet Tracking", url: "/dashboard/fleet", icon: Truck, end: true },
      { title: "Hub Management", url: "/dashboard/hub-health", icon: Building2 },
      { title: "Deposit Validation", url: "/dashboard/deposits", icon: ShieldCheck },
    ],
  },
];

export const AppSidebar = () => {
  const { pathname } = useLocation();
  const { role, roleLoading } = useAuth();

  const isActive = (url: string, end?: boolean) => (end ? pathname === url : pathname.startsWith(url));

  const groupsForRole = (r: AppRole | null) => {
    if (roleLoading || r == null) return [];
    return r === "ENTERPRISE" ? enterpriseGroups : adminGroups;
  };

  const groups = groupsForRole(role);

  return (
    <Sidebar collapsible="icon" className="border-r border-sidebar-border">
      <SidebarHeader className="px-3 py-4">
        <NavLink to="/dashboard" className="block">
          <Logo compact />
        </NavLink>
      </SidebarHeader>
      <SidebarContent>
        {roleLoading && (
          <SidebarGroup>
            <SidebarGroupLabel className="text-[10px] tracking-[0.2em] font-mono text-muted-foreground/70">
              LOADING ACCESS…
            </SidebarGroupLabel>
            <SidebarGroupContent className="space-y-2 px-2">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-9 w-full rounded-md" />
              ))}
            </SidebarGroupContent>
          </SidebarGroup>
        )}
        {!roleLoading &&
          groups.map((g) => (
            <SidebarGroup key={g.label}>
              <SidebarGroupLabel className="text-[10px] tracking-[0.2em] font-mono text-muted-foreground/70">
                {g.label.toUpperCase()}
              </SidebarGroupLabel>
              <SidebarGroupContent>
                <SidebarMenu>
                  {g.items.map((item) => {
                    const active = isActive(item.url, item.end);
                    return (
                      <SidebarMenuItem key={item.title}>
                        <SidebarMenuButton asChild isActive={active}>
                          <NavLink to={item.url} end={item.end} className="group">
                            <item.icon className={`h-4 w-4 ${active ? "text-accent" : ""}`} />
                            <span>{item.title}</span>
                            {active && <span className="ml-auto h-1.5 w-1.5 rounded-full bg-accent animate-pulse" />}
                          </NavLink>
                        </SidebarMenuButton>
                      </SidebarMenuItem>
                    );
                  })}
                </SidebarMenu>
              </SidebarGroupContent>
            </SidebarGroup>
          ))}
      </SidebarContent>
      <SidebarFooter className="border-t border-sidebar-border p-3">
        <SidebarMenuButton asChild>
          <NavLink to="/" className="text-xs">
            <ArrowLeft className="h-4 w-4" />
            <span>Exit to Public</span>
          </NavLink>
        </SidebarMenuButton>
      </SidebarFooter>
    </Sidebar>
  );
};
