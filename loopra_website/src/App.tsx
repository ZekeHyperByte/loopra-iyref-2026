import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AuthProvider } from "@/contexts/AuthContext";
import { RequireAuth } from "@/components/auth/RequireAuth";
import { RoleRoute } from "@/components/auth/RoleRoute";
import Index from "./pages/Index.tsx";
import NotFound from "./pages/NotFound.tsx";
import Login from "./pages/Login.tsx";
import { DashboardLayout } from "./components/dashboard/DashboardLayout";
import DashboardIndex from "./pages/dashboard/DashboardIndex";
import Inventory from "./pages/dashboard/Inventory";
import Ledger from "./pages/dashboard/Ledger";
import Fleet from "./pages/dashboard/Fleet";
import HubHealth from "./pages/dashboard/HubHealth";
import DepositReview from "./pages/dashboard/DepositReview";
import EsgReports from "./pages/dashboard/EsgReports";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <Routes>
            <Route path="/" element={<Index />} />
            <Route path="/login" element={<Login />} />
            <Route
              path="/dashboard"
              element={
                <RequireAuth>
                  <DashboardLayout />
                </RequireAuth>
              }
            >
              <Route
                index
                element={
                  <RoleRoute allow={["ENTERPRISE", "ADMIN"]}>
                    <DashboardIndex />
                  </RoleRoute>
                }
              />
              <Route
                path="inventory"
                element={
                  <RoleRoute allow={["ENTERPRISE"]}>
                    <Inventory />
                  </RoleRoute>
                }
              />
              <Route
                path="ledger"
                element={
                  <RoleRoute allow={["ENTERPRISE"]}>
                    <Ledger />
                  </RoleRoute>
                }
              />
              <Route
                path="esg-reports"
                element={
                  <RoleRoute allow={["ENTERPRISE"]}>
                    <EsgReports />
                  </RoleRoute>
                }
              />
              <Route
                path="fleet"
                element={
                  <RoleRoute allow={["ADMIN"]}>
                    <Fleet />
                  </RoleRoute>
                }
              />
              <Route
                path="hub-health"
                element={
                  <RoleRoute allow={["ADMIN"]}>
                    <HubHealth />
                  </RoleRoute>
                }
              />
              <Route
                path="deposits"
                element={
                  <RoleRoute allow={["ADMIN"]}>
                    <DepositReview />
                  </RoleRoute>
                }
              />
            </Route>
            <Route path="*" element={<NotFound />} />
          </Routes>
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
