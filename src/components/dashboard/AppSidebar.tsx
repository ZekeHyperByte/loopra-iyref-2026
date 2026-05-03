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
import { LayoutDashboard, Map, TrendingUp, FileLock2, Truck, Activity, ShieldCheck, ArrowLeft } from "lucide-react";
import { Logo } from "@/components/Logo";

const groups = [
  {
    label: "Enterprise Portal",
    items: [
      { title: "Inventory Visibility", url: "/dashboard", icon: LayoutDashboard, end: true },
      { title: "Geospatial Network", url: "/dashboard/network", icon: Map },
      { title: "AI Supply Forecast", url: "/dashboard/forecast", icon: TrendingUp },
      { title: "Carbon Ledger", url: "/dashboard/ledger", icon: FileLock2 },
    ],
  },
  {
    label: "Operations",
    items: [
      { title: "Fleet Control", url: "/dashboard/fleet", icon: Truck },
      { title: "Hub Health", url: "/dashboard/hub-health", icon: Activity },
      { title: "Assay Validation", url: "/dashboard/assay", icon: ShieldCheck },
    ],
  },
];

export const AppSidebar = () => {
  const { pathname } = useLocation();
  const isActive = (url: string, end?: boolean) => (end ? pathname === url : pathname.startsWith(url));
  return (
    <Sidebar collapsible="icon" className="border-r border-sidebar-border">
      <SidebarHeader className="px-3 py-4">
        <Logo size="sm" />
      </SidebarHeader>
      <SidebarContent>
        {groups.map((g) => (
          <SidebarGroup key={g.label}>
            <SidebarGroupLabel className="text-[10px] tracking-[0.25em] font-mono text-muted-foreground/70">
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
