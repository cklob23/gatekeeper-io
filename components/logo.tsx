"use client"

import Image from "next/image"
import { useBranding } from "@/hooks/use-branding"

interface LogoProps {
  variant?: "light" | "dark"
  className?: string
  width?: number
  height?: number
}

export function Logo({ variant = "dark", className = "", height = 40 }: LogoProps) {
  const { branding, isLoading } = useBranding()

  // If custom logo is set, use it
  if (branding.companyLogo) {
    return (
      <div className={`flex items-center ${className}`}>
        <Image
          src={branding.companyLogo || "/icon.png"}
          alt={branding.companyName}
          width={40}
          height={height}
          className="h-10 w-auto object-contain"
          priority
        />
      </div>
    )
  }

  // Default logo - use the talusAg_Logo.png image
  return (
    <div className={`flex items-center ${className}`}>
      <Image
        src="/icon.png"
        alt={branding?.companyName || "Gatekeeperio Logo"}
        width={40}
        height={height}
        className="h-10 w-auto object-contain"
        priority
      />
    </div>
  )
}

// Icon-only version for collapsed sidebar
export function LogoIcon({ className = "" }: { className?: string }) {
  const { branding } = useBranding()

  // If custom small logo is set, use it
  if (branding.companyLogoSmall) {
    return (
      <Image
        src={branding.companyLogoSmall || "/icon.png"}
        alt={branding.companyName}
        width={40}
        height={40}
        className={`object-contain ${className}`}
        priority
      />
    )
  }

  // Fallback to full logo if small not set but full is
  if (branding.companyLogo) {
    return (
      <Image
        src={branding.companyLogo || "/icon.png"}
        alt={branding.companyName}
        width={40}
        height={40}
        className={`object-contain ${className}`}
        priority
      />
    )
  }

  // Default logo image
  return (
    <Image
      src="/icon.png"
      alt={branding?.companyName || "Gatekeeperio Logo"}
      width={40}
      height={40}
      className={`object-contain ${className}`}
      priority
    />
  )
}
