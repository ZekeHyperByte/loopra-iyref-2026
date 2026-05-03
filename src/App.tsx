import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import Index from "./pages/Index.tsx";
import NotFound from "./pages/NotFound.tsx";
import { DashboardLayout } from "./components/dashboard/DashboardLayout";
import Inventory from "./pages/dashboard/Inventory";
import Network from "./pages/dashboard/Network";
import Forecast from "./pages/dashboard/Forecast";
import Ledger from "./pages/dashboard/Ledger";
import Fleet from "./pages/dashboard/Fleet";
import HubHealth from "./pages/dashboard/HubHealth";
import AssayValidation from "./pages/dashboard/AssayValidation";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/dashboard" element={<DashboardLayout />}>
            <Route index element={<Inventory />} />
            <Route path="network" element={<Network />} />
            <Route path="forecast" element={<Forecast />} />
            <Route path="ledger" element={<Ledger />} />
            <Route path="fleet" element={<Fleet />} />
            <Route path="hub-health" element={<HubHealth />} />
            <Route path="assay" element={<AssayValidation />} />
          </Route>
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
