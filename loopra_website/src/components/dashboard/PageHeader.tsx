interface PageHeaderProps {
  eyebrow: string;
  title: string;
  description?: string;
  children?: React.ReactNode;
}
export const PageHeader = ({ eyebrow, title, description, children }: PageHeaderProps) => (
  <div className="flex flex-wrap items-end justify-between gap-4 mb-6">
    <div>
      <div className="text-[10px] font-mono tracking-[0.3em] text-accent">{eyebrow.toUpperCase()}</div>
      <h1 className="text-2xl md:text-3xl font-bold tracking-tight mt-1">{title}</h1>
      {description && <p className="text-sm text-muted-foreground mt-1.5 max-w-2xl">{description}</p>}
    </div>
    {children && <div className="flex items-center gap-2">{children}</div>}
  </div>
);
