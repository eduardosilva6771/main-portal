import { useEffect, useMemo, useRef, useState } from 'react'
import { useAuth0 } from '@auth0/auth0-react'
import { PortalShell } from '@dudxtec/portal-ui'
import './App.css'

const loginPortalUrl = import.meta.env.VITE_LOGIN_PORTAL_URL || 'http://localhost:5172/'
const costCenterPortalUrl = import.meta.env.VITE_COST_CENTER_PORTAL_URL || 'http://localhost:5173/'
const tenantPortalUrl = import.meta.env.VITE_TENANT_PORTAL_URL || 'http://localhost:5174/'
const auth0Domain = import.meta.env.VITE_AUTH0_DOMAIN || 'dev-usvbyuppee5767fg.us.auth0.com'

function normalizeAuth0Domain(domain) {
  if (!domain) return 'https://dev-usvbyuppee5767fg.us.auth0.com'
  if (domain.startsWith('http://') || domain.startsWith('https://')) return domain.replace(/\/+$/, '')
  return `https://${domain.replace(/\/+$/, '')}`
}

function App() {
  const { isLoading, isAuthenticated, error, user, loginWithRedirect, logout } = useAuth0()
  const [menuOpen, setMenuOpen] = useState(false)
  const menuRef = useRef(null)
  const homeUrl = window.location.origin
  const profileUrl = useMemo(() => `${normalizeAuth0Domain(auth0Domain)}/u/account`, [])

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
      <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Z" />
      <path d="M4 20a8 8 0 0 1 16 0" />
    </svg>
  )
  const iconBell = (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M6 9a6 6 0 0 1 12 0v5l2 2H4l2-2z" />
      <path d="M10 18a2 2 0 0 0 4 0" />
    </svg>
  )
  const iconUser = (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Z" />
      <path d="M4 20a8 8 0 0 1 16 0" />
    </svg>
  )

  const railItems = [
    { label: 'Inicio', href: homeUrl, icon: iconHome, active: true },
    { label: 'Cost Center', href: costCenterPortalUrl, icon: iconCostCenter },
    { label: 'Tenant', href: tenantPortalUrl, icon: iconTenant },
  ]

  const menuItems = [
    { label: 'Inicio', href: homeUrl, icon: iconHome, active: true },
    { label: 'Cost Center', href: costCenterPortalUrl, icon: iconCostCenter },
    { label: 'Tenant', href: tenantPortalUrl, icon: iconTenant },
  ]

  useEffect(() => {
    function handleClickOutside(event) {
      if (!menuRef.current) return
      if (!menuRef.current.contains(event.target)) setMenuOpen(false)
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  if (isLoading) {
    return (
      <PortalShell
        brandKicker="Main Portal"
        brandTitle="Workspace"
        railItems={railItems}
        menuItems={menuItems}
        topLeft={<span>Aguardando autenticacao...</span>}
        topRight={<span>Nao autenticado</span>}
      >
        <section className="login-card">Carregando sessao...</section>
      </PortalShell>
    )
  }

  if (!isAuthenticated) {
    return (
      <PortalShell
        brandKicker="Main Portal"
        brandTitle="Workspace"
        railItems={railItems}
        menuItems={menuItems}
        topLeft={<span>Ambiente nao autenticado</span>}
        topRight={<span>Convidado</span>}
      >
        <section className="login-card">
          <p className="kicker">MAIN PORTAL</p>
          <h1>Painel principal</h1>
          <p>Autentique-se para acessar os modulos do ecossistema.</p>
          <div className="actions">
            <button type="button" onClick={() => loginWithRedirect()}>
              Entrar com Auth0
            </button>
            <a className="btn ghost" href={loginPortalUrl}>Ir para Login Portal</a>
          </div>
          {error && <p className="error">{error.message}</p>}
        </section>
      </PortalShell>
    )
  }

  return (
    <PortalShell
      brandKicker="Main Portal"
      brandTitle="Workspace"
      railItems={railItems}
      menuItems={menuItems}
      topLeft={
        <div className="balance-box">
          <span>Ambiente autenticado</span>
          <strong>{user?.email || user?.name || 'usuario'}</strong>
        </div>
      }
      topRight={
        <div className="top-actions" ref={menuRef}>
          <button className="icon-btn" type="button" title="Notificacoes">
            {iconBell}
          </button>
          <button
            className="icon-btn"
            type="button"
            aria-haspopup="menu"
            aria-expanded={menuOpen}
            onClick={() => setMenuOpen((prev) => !prev)}
            title="Conta"
          >
            {iconUser}
          </button>

          {menuOpen && (
            <div className="menu-dropdown" role="menu">
              <p className="menu-user">{user?.email || user?.sub}</p>
              <a className="dropdown-item" href={profileUrl} target="_blank" rel="noreferrer" role="menuitem">
                Editar perfil (Auth0)
              </a>
              <button
                type="button"
                className="dropdown-item danger"
                onClick={() => logout({ logoutParams: { returnTo: window.location.origin } })}
                role="menuitem"
              >
                Sair
              </button>
            </div>
          )}
        </div>
      }
    >
      <section className="breadcrumb-bar">
        <span>Portal</span>
        <span className="divider">›</span>
        <span>Modulos</span>
      </section>

      <section className="modules-card">
        <div className="modules-header">
          <h1>Modulos</h1>
          <a className="btn ghost" href={loginPortalUrl}>Voltar ao Login</a>
        </div>

        <div className="module-list">
          <article className="module-row">
            <div>
              <h2>Cost Center</h2>
              <p>Gestao operacional de centros de custo e seus status.</p>
            </div>
            <a className="btn" href={costCenterPortalUrl}>Acessar</a>
          </article>

          <article className="module-row">
            <div>
              <h2>Tenant</h2>
              <p>Gestao de tenants e parametros de identificacao.</p>
            </div>
            <a className="btn" href={tenantPortalUrl}>Acessar</a>
          </article>
        </div>
      </section>
    </PortalShell>
  )
}

export default App
