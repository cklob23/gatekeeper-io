interface LogoProps {
  variant?: "light" | "dark"
  className?: string
  width?: number
  height?: number
}

export function Logo({ variant = "dark", className = "", width = 150, height = 40 }: LogoProps) {
  return (
    <div className={`flex items-center gap-2 ${className}`}>
      <img src="/icon.png" alt="Logo" />
      <span className={`font-bold text-xl tracking-tight ${variant === "dark" ? "text-foreground" : "text-white"}`}>
        Gatekeeper.io
      </span>
    </div>
  )
}

// Icon-only version for collapsed sidebar
export function LogoIcon({ className = "" }: { className?: string }) {
  return (
    <div className={`flex items-center gap-2 ${className}`}>
      <img src="/icon.png" alt="Logo" />
    </div>
  )
}
