interface LogoProps {
  variant?: "light" | "dark"
  className?: string
  width?: number
  height?: number
}

const logo = process.env.NEXT_PUBLIC_LOGO_URL || "/icon.png"
const smLogo = process.env.NEXT_PUBLIC_SM_LOGO_URL || "/icon-sm.png"
const logoText = process.env.NEXT_PUBLIC_LOGO_NAME

export function Logo({ variant = "dark", className = "", width = 150, height = 40 }: LogoProps) {
  return (
    <div className={`flex items-center gap-2 ${className}`}>
      <img src={logo} alt="Logo" height={height} width={width} />
      <span className={`font-bold text-xl tracking-tight ${variant === "dark" ? "text-foreground" : "text-white"}`}>
        {logoText}
      </span>
    </div>
  )
}

// Icon-only version for collapsed sidebar
export function LogoIcon({ className = "" }: { className?: string }) {
  return (
    <div className={`flex items-center gap-2 ${className}`}>
      <img src={smLogo} alt="Logo" height={50}/>
    </div>
  )
}
