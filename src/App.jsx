import { useAuth0 } from '@auth0/auth0-react'
import './App.css'

const loginPortalUrl = import.meta.env.VITE_LOGIN_PORTAL_URL || 'http://localhost:5172/'
const costCenterPortalUrl = import.meta.env.VITE_COST_CENTER_PORTAL_URL || 'http://localhost:5173/'
const tenantPortalUrl = import.meta.env.VITE_TENANT_PORTAL_URL || 'http://localhost:5174/'

function App() {
  const {
    isLoading,
    isAuthenticated,
    error,
    user,
    loginWithRedirect,
    logout,
  } = useAuth0()

  if (isLoading) {
    return (
      <main className="main-shell">
        <section className="status-card">Carregando sessao...</section>
      </main>
    )
  }

  if (!isAuthenticated) {
    return (
      <main className="main-shell">
        <section className="hero-card">
          <p className="kicker">MAIN PORTAL</p>
          <h1>Painel principal</h1>
          <p>Autentique-se para acessar os modulos do ecossistema.</p>
        </section>

        <section className="status-card">
          <div className="actions">
            <button type="button" onClick={() => loginWithRedirect()}>
              Entrar com Auth0
            </button>
            <a className="link-btn ghost" href={loginPortalUrl}>Ir para Login Portal</a>
          </div>
          {error && <p className="error">{error.message}</p>}
        </section>
      </main>
    )
  }

  return (
    <main className="main-shell">
      <section className="hero-card">
        <p className="kicker">MAIN PORTAL</p>
        <h1>Bem-vindo, {user?.name || user?.email || 'usuario'}</h1>
        <p>Selecione o modulo que deseja acessar.</p>
      </section>

      <section className="cards-grid">
        <article className="module-card">
          <h2>Cost Center</h2>
          <p>Gestao operacional de centros de custo.</p>
          <a className="link-btn" href={costCenterPortalUrl}>Abrir modulo</a>
        </article>

        <article className="module-card">
          <h2>Tenant</h2>
          <p>Gestao de tenants e parametros relacionados.</p>
          <a className="link-btn" href={tenantPortalUrl}>Abrir modulo</a>
        </article>
      </section>

      <section className="status-card">
        <p className="user-line">Conta autenticada: <strong>{user?.email || user?.sub}</strong></p>
        <div className="actions">
          <a className="link-btn ghost" href={loginPortalUrl}>Voltar ao Login Portal</a>
          <button type="button" className="ghost" onClick={() => logout({ logoutParams: { returnTo: window.location.origin } })}>
            Sair
          </button>
        </div>
      </section>
    </main>
  )
}

export default App