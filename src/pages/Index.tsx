import { useEffect } from "react";
import { useLocation } from "react-router-dom";
import { toast } from "sonner";
import { LandingNav } from "@/components/landing/LandingNav";
import { Hero } from "@/components/landing/Hero";
import { LiveMetrics } from "@/components/landing/LiveMetrics";
import { SmerProtocol } from "@/components/landing/SmerProtocol";
import { LandingFooter } from "@/components/landing/LandingFooter";

const Index = () => {
  const location = useLocation();

  useEffect(() => {
    const st = location.state as { requireAuth?: boolean } | null;
    if (st?.requireAuth) {
      toast.info("Sign in required", { description: "Use Partner Login to access the command center." });
      window.history.replaceState({}, document.title);
    }
  }, [location.state]);

  return (
    <div className="min-h-screen relative">
      <LandingNav />
      <Hero />
      <LiveMetrics />
      <SmerProtocol />
      <LandingFooter />
    </div>
  );
};

export default Index;
