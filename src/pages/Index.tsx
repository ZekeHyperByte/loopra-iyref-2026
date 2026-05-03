import { LandingNav } from "@/components/landing/LandingNav";
import { Hero } from "@/components/landing/Hero";
import { LiveMetrics } from "@/components/landing/LiveMetrics";
import { SmerProtocol } from "@/components/landing/SmerProtocol";
import { LandingFooter } from "@/components/landing/LandingFooter";

const Index = () => (
  <div className="min-h-screen relative">
    <LandingNav />
    <Hero />
    <LiveMetrics />
    <SmerProtocol />
    <LandingFooter />
  </div>
);

export default Index;
