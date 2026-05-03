import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Building2, Loader2, Shield, ArrowLeft } from "lucide-react";
import { toast } from "sonner";
import { GlassCard } from "@/components/GlassCard";
import { Logo } from "@/components/Logo";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useAuth } from "@/contexts/AuthContext";
import { USER_ROLE_METADATA_KEY, normalizeRole, type AppRole } from "@/lib/roles";
import { supabase } from "@/lib/supabase";
import { cn } from "@/lib/utils";

const portalCopy: Record<AppRole, { title: string; description: string; badge: string }> = {
  ENTERPRISE: {
    title: "Enterprise",
    description: "Inventory levels, carbon credits, and ESG reporting — no fleet or hub operations consoles.",
    badge: "ENTERPRISE",
  },
  ADMIN: {
    title: "Administrator",
    description: "Fleet tracking, hub management, and deposit validation — operations console.",
    badge: "ADMIN",
  },
};

const Login = () => {
  const navigate = useNavigate();
  const { session, loading: authLoading } = useAuth();
  const [portal, setPortal] = useState<AppRole>("ENTERPRISE");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (!authLoading && session) {
      navigate("/dashboard", { replace: true });
    }
  }, [authLoading, session, navigate]);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !password) {
      toast.error("Enter your email and password.");
      return;
    }

    setSubmitting(true);
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email.trim(),
        password,
      });

      if (error) {
        toast.error(error.message || "Sign-in failed.");
        return;
      }

      const rawMeta =
        data.user?.user_metadata?.[USER_ROLE_METADATA_KEY] ?? data.user?.user_metadata?.portal ?? null;
      const assigned = normalizeRole(rawMeta);
      if (assigned && assigned !== portal) {
        await supabase.auth.signOut();
        toast.error(
          `This account is registered as ${assigned}. Switch to the ${assigned === "ADMIN" ? "Admin" : "Enterprise"} tab and try again.`,
        );
        return;
      }

      toast.success("Signed in successfully.");
      navigate("/dashboard", { replace: true });
    } finally {
      setSubmitting(false);
    }
  };

  if (authLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background grid-bg">
        <Loader2 className="h-8 w-8 text-primary animate-spin" />
      </div>
    );
  }

  if (session) {
    return null;
  }

  const copy = portalCopy[portal];

  return (
    <div className="min-h-screen flex flex-col relative overflow-hidden">
      <div className="absolute inset-0 grid-bg opacity-25 [mask-image:radial-gradient(ellipse_at_center,black_35%,transparent_75%)]" />
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 h-[420px] w-[720px] rounded-full bg-primary/15 blur-[100px] pointer-events-none" />

      <header className="relative z-10 border-b border-border/40 glass-strong">
        <div className="container flex items-center justify-between h-16 px-4">
          <Link
            to="/"
            className="flex items-center gap-2 text-muted-foreground hover:text-foreground transition-colors text-sm"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to site
          </Link>
          <Logo />
          <div className="w-[88px]" aria-hidden />
        </div>
      </header>

      <main className="relative z-10 flex-1 flex items-center justify-center p-4 md:p-8">
        <div className="w-full max-w-md">
          <div className="text-center mb-8">
            <p className="text-[11px] font-mono tracking-[0.3em] text-muted-foreground mb-3">SECURE ACCESS</p>
            <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Command Center</h1>
            <p className="text-muted-foreground text-sm mt-2 max-w-sm mx-auto">
              Sign in with your Loopra credentials. Pick the role that matches your account metadata in Supabase.
            </p>
          </div>

          <GlassCard strong className="border border-border/50 shadow-[var(--shadow-card)]">
            <Tabs value={portal} onValueChange={(v) => setPortal(v as AppRole)} className="w-full">
              <TabsList className="grid w-full grid-cols-2 h-12 p-1 bg-secondary/80 border border-border/60 rounded-xl">
                <TabsTrigger
                  value="ENTERPRISE"
                  className={cn(
                    "rounded-lg gap-1.5 text-xs sm:text-sm px-2 sm:px-3",
                    "data-[state=active]:bg-card data-[state=active]:text-foreground data-[state=active]:shadow-sm",
                    "data-[state=active]:border data-[state=active]:border-primary/30",
                  )}
                >
                  <Building2 className="h-4 w-4 opacity-80 shrink-0" />
                  Enterprise
                </TabsTrigger>
                <TabsTrigger
                  value="ADMIN"
                  className={cn(
                    "rounded-lg gap-1.5 text-xs sm:text-sm px-2 sm:px-3",
                    "data-[state=active]:bg-card data-[state=active]:text-foreground data-[state=active]:shadow-sm",
                    "data-[state=active]:border data-[state=active]:border-accent/40",
                  )}
                >
                  <Shield className="h-4 w-4 opacity-80 shrink-0" />
                  Admin
                </TabsTrigger>
              </TabsList>
            </Tabs>

            <PortalPanel copy={copy} />

            <form onSubmit={onSubmit} className="space-y-4 mt-6">
              <div className="space-y-2">
                <Label htmlFor="email" className="text-muted-foreground">
                  Work email
                </Label>
                <Input
                  id="email"
                  type="email"
                  autoComplete="email"
                  placeholder="you@organization.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="bg-background/60 border-border/80 focus-visible:ring-primary/50"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="password" className="text-muted-foreground">
                  Password
                </Label>
                <Input
                  id="password"
                  type="password"
                  autoComplete="current-password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="bg-background/60 border-border/80 focus-visible:ring-primary/50"
                />
              </div>

              <Button
                type="submit"
                disabled={submitting}
                className="w-full h-11 font-semibold bg-primary text-primary-foreground hover:bg-primary/90 glow-emerald"
              >
                {submitting ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" />
                    Signing in…
                  </>
                ) : (
                  "Sign in"
                )}
              </Button>
            </form>

            <p className="text-[11px] text-muted-foreground text-center mt-6 font-mono leading-relaxed">
              Primary: <span className="text-accent">user_roles.role_name</span> (see{" "}
              <span className="text-mono">supabase/user_roles.sql</span>). Fallback:{" "}
              <span className="text-accent">profiles</span> or <span className="text-accent">user_metadata.role</span>.
            </p>
          </GlassCard>
        </div>
      </main>
    </div>
  );
};

function PortalPanel({
  copy,
}: {
  copy: { title: string; description: string; badge: string };
}) {
  return (
    <div className="mt-5 pt-5 border-t border-border/50">
      <div className="flex items-start justify-between gap-3">
        <div>
          <h2 className="text-sm font-semibold text-foreground">{copy.title}</h2>
          <p className="text-xs text-muted-foreground mt-1 leading-relaxed">{copy.description}</p>
        </div>
        <span className="shrink-0 text-[10px] font-mono tracking-wider px-2 py-1 rounded-md bg-secondary border border-border/60 text-accent">
          {copy.badge}
        </span>
      </div>
    </div>
  );
}

export default Login;
