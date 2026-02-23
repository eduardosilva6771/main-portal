import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { Auth0Provider } from '@auth0/auth0-react'
import './index.css'
import App from './App.jsx'

const auth0Domain = import.meta.env.VITE_AUTH0_DOMAIN || 'dev-usvbyuppee5767fg.us.auth0.com'
const auth0ClientId = import.meta.env.VITE_AUTH0_CLIENT_ID || 'B4pqqYpFZYQN6U7FMaV5NNKU5Nbmn3t1'
const auth0Audience = import.meta.env.VITE_AUTH0_AUDIENCE || 'http://localhost:3000'
const redirectUri = import.meta.env.VITE_AUTH0_REDIRECT_URI || 'http://localhost:5171/'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Auth0Provider
      domain={auth0Domain}
      clientId={auth0ClientId}
      authorizationParams={{
        redirect_uri: redirectUri,
        audience: auth0Audience,
      }}
    >
      <App />
    </Auth0Provider>
  </StrictMode>,
)