import { useEffect, useRef } from 'react'
import { useAuth0 } from '@auth0/auth0-react'
import { PortalShell, PortalTopUserActions, buildPortalNavigation } from '@dudxtec/lib-portal-ui'
import './App.css'

const loginPortalUrl = import.meta.env.VITE_LOGIN_PORTAL_URL || 'http://localhost:5172/'
const costCenterPortalUrl = import.meta.env.VITE_COST_CENTER_PORTAL_URL || 'http://localhost:5173/'
const tenantPortalUrl = import.meta.env.VITE_TENANT_PORTAL_URL || 'http://localhost:5174/'
const entryTypePortalUrl = import.meta.env.VITE_ENTRY_TYPE_PORTAL_URL || 'http://localhost:5176/'
const coinPortalUrl = import.meta.env.VITE_PAYMENT_METHOD_PORTAL_URL || 'http://localhost:5175/'

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

  const { railItems, menuItems } = buildPortalNavigation({
    active: 'home',
    urls: {
      home: homeUrl,
      costCenter: costCenterPortalUrl,
      tenant: tenantPortalUrl,
      entryType: entryTypePortalUrl,
      paymentMethod: coinPortalUrl,
    },
  })

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
