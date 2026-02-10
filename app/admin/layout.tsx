import type React from "react"
import { createClient } from "@/lib/supabase/server"
import { getTenantForUser } from "@/lib/tenant"
import { AdminLayoutClient } from "@/components/admin/admin-layout-client"
import type { TenantInfo } from "@/lib/tier"

/**
 * Server component: loads the current user's tenant from the DB,
 * then passes it to the client layout wrapper.
 */
export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  let tenant: TenantInfo | null = null

  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (user) {
      tenant = await getTenantForUser(user.id)
      console.log(tenant)
    }
  } catch {
    // If tenant loading fails, the client layout defaults to Starter with no add-ons
  }

  return (
    <AdminLayoutClient tenant={tenant}>
      {children}
    </AdminLayoutClient>
  )
}
