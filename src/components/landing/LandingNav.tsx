import { motion } from "framer-motion";
import { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Logo } from "@/components/Logo";
import { Button } from "@/components/ui/button";
import { ArrowUpRight, LayoutDashboard, LogOut } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { toast } from "sonner";

const links = [
  { label: "Protocol", href: "#protocol" },
  { label: "Ecosystem", href: "#metrics" },
  { label: "Network", href: "#network" },
  { label: "ESG Ledger", href: "#ledger" },
];

export const LandingNav = () => {
  const [scrolled, setScrolled] = useState(false);
  const { session, loading, signOut } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const onLogout = async () => {
    await signOut();
    toast.success("Signed out.");
  };

  const onRequestDemo = () => {
    if (session) {
      navigate("/dashboard");
      toast.message("Welcome back", { description: "Opening your dashboard." });
      return;
    }
    navigate("/login");
  };

  return (
    <motion.header
      initial={{ y: -40, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className={`fixed top-0 inset-x-0 z-50 transition-all duration-300 ${scrolled ? "py-2" : "py-4"}`}
    >
      <div
        className={`container flex items-center justify-between rounded-2xl px-4 py-3 transition-all ${
          scrolled ? "glass-strong" : ""
        }`}
      >
        <Logo />
        <nav className="hidden md:flex items-center gap-8">
          {links.map((l) => (
            <a key={l.href} href={l.href} className="text-sm text-muted-foreground hover:text-accent transition-colors">
              {l.label}
            </a>
          ))}
        </nav>
        <div className="flex items-center gap-2">
          {loading ? (
            <span className="text-xs text-muted-foreground px-2">…</span>
          ) : session ? (
            <>
              <Button variant="ghost" size="sm" className="hidden sm:inline-flex text-xs gap-1" onClick={onLogout}>
                <LogOut className="h-3.5 w-3.5" />
                Logout
              </Button>
              <Button asChild size="sm" className="bg-accent text-accent-foreground hover:bg-accent/90 font-semibold gap-1">
                <Link to="/dashboard">
                  <LayoutDashboard className="h-3.5 w-3.5" />
                  Dashboard
                </Link>
              </Button>
            </>
          ) : (
            <>
              <Button
                variant="ghost"
                size="sm"
                className="hidden sm:inline-flex text-xs"
                onClick={onRequestDemo}
              >
                Request Demo
              </Button>
              <Button asChild size="sm" className="bg-accent text-accent-foreground hover:bg-accent/90 font-semibold">
                <Link to="/login">
                  Partner Login <ArrowUpRight className="ml-1 h-3.5 w-3.5" />
                </Link>
              </Button>
            </>
          )}
        </div>
      </div>
    </motion.header>
  );
};
