export const Logo = () => {
  return (
    <div className="flex items-center gap-2">
      {/* Ganti /logo-loopra.svg dengan nama file logomu di folder public */}
      <img src="/logo-loopra.svg" alt="Loopra Logo" className="h-8 w-auto" />
      <span className="text-xl font-bold tracking-tight text-white">
        loopra<span className="text-primary">.</span>
      </span>
    </div>
  );
};