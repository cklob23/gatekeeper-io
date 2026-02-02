"use client"

import Image from "next/image"
import { useBranding } from "@/hooks/use-branding"

interface LogoProps {
  variant?: "light" | "dark"
  className?: string
  width?: number
  height?: number
  borderRadius?: string
}

export function Logo({ variant = "dark", className = "", height = 40, borderRadius = "sm" }: LogoProps) {
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
          className={`h-10 w-auto object-contain rounded-${borderRadius}`}
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
        className={`h-10 w-auto object-contain rounded-${borderRadius}`}
        priority
      />
    </div>
  )
}

// Icon-only version for collapsed sidebar
export function LogoIcon({ className = "", borderRadius = "sm" }: { className?: string, borderRadius?: string }) {
  const { branding } = useBranding()

  // If custom small logo is set, use it
  if (branding.companyLogoSmall) {
    return (
      <Image
        src={branding.companyLogoSmall || "/icon.png"}
        alt={branding.companyName}
        width={40}
        height={40}
        className={`object-contain ${className} rounded-${borderRadius}`}
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
        className={`object-contain ${className} rounded-${borderRadius}`}
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
      className={`object-contain ${className} rounded-${borderRadius}`}
      priority
    />
  )
}
