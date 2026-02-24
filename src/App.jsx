import { useEffect, useRef } from 'react'
import { useAuth0 } from '@auth0/auth0-react'
import { PortalShell, PortalTopUserActions, portalIconPaymentMethod } from '@dudxtec/lib-portal-ui'
import './App.css'

const loginPortalUrl = import.meta.env.VITE_LOGIN_PORTAL_URL || 'http://localhost:5172/'
const costCenterPortalUrl = import.meta.env.VITE_COST_CENTER_PORTAL_URL || 'http://localhost:5173/'
const tenantPortalUrl = import.meta.env.VITE_TENANT_PORTAL_URL || 'http://localhost:5174/'
const coinPortalUrl = import.meta.env.VITE_COIN_PORTAL_URL || 'http://localhost:5175/'

function App() {
  const { isLoading, isAuthenticated, error, user, logout } = useAuth0()
  const homeUrl = window.location.origin
  const loginRedirectUrl = loginPortalUrl.replace(/\/$/, '')
  const redirectStartedRef = useRef(false)

  useEffect(() => {
    if (isLoading || isAuthenticated || redirectStartedRef.current) return
    redirectStartedRef.current = true
    window.location.assign(loginPortalUrl)
  }, [isLoading, isAuthenticated])

  const iconHome = (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M3 11l9-7 9 7" />
      <path d="M5 10v10h14V10" />
    </svg>
  )
  const iconCostCenter = (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <rect x="3" y="6" width="18" height="12" rx="2" />
      <path d="M3 10h18" />
    </svg>
  )
  const iconTenant = (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M4 20V6h10v14" />
      <path d="M14 20V10h6v10" />
      <path d="M7 9h2M7 12h2M7 15h2M11 9h1M11 12h1M11 15h1M16 13h2M16 16h2" />
    </svg>
  )
  const iconCoin = portalIconPaymentMethod

  const railItems = [
    { label: 'Inicio', href: homeUrl, icon: iconHome, active: true },
    { label: 'Cost Center', href: costCenterPortalUrl, icon: iconCostCenter },
    { label: 'Tenant', href: tenantPortalUrl, icon: iconTenant },
    { label: 'Payment Method', href: coinPortalUrl, icon: iconCoin },
  ]

  const menuItems = [
    { label: 'Inicio', href: homeUrl, icon: iconHome, active: true },
    { label: 'Cost Center', href: costCenterPortalUrl, icon: iconCostCenter },
    { label: 'Tenant', href: tenantPortalUrl, icon: iconTenant },
    { label: 'Payment Method', href: coinPortalUrl, icon: iconCoin },
  ]

  if (isLoading) {
    return (
      <main className="main-auth-gate">
        <section className="login-card" aria-hidden="true" />
      </main>
    )
  }

  if (!isAuthenticated) {
    return (
      <main className="main-auth-gate">
        <section className="login-card">
          {error && <p className="error">{error.message}</p>}
        </section>
      </main>
    )
  }

  return (
    <PortalShell
      brandKicker="Main Portal"
      brandTitle="Workspace"
      exclusiveNavigation
      railItems={railItems}
      menuItems={menuItems}
      topLeft={<span>Portal principal</span>}
      topRight={
        <PortalTopUserActions
          subtitle="Ambiente autenticado"
          userName={user?.email || user?.name || 'Usuario'}
          logoutLabel="Sair"
          onLogout={() => logout({ logoutParams: { returnTo: loginRedirectUrl } })}
          logoutButtonClassName="ghost"
        />
      }
    >
      <section className="main-empty-canvas" aria-label="Area principal" />
    </PortalShell>
  )
}

export default App
