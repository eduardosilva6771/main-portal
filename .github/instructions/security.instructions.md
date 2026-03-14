---
applyTo: "src/**/*.{js,jsx}"
---

# Instruções de Segurança e Autenticação

## Autenticação Auth0

- Usar **exclusivamente** o hook `useAuth0()` de `@auth0/auth0-react` para gerenciar autenticação.
- Verificar `isLoading` **antes** de `isAuthenticated` para evitar flashes de conteúdo não autorizado.
- Redirecionar para o `VITE_LOGIN_PORTAL_URL` quando `isAuthenticated` for `false` e o carregamento tiver concluído.
- Usar `useRef` para garantir que o redirecionamento ocorra apenas uma vez (evitar loop em `StrictMode`):

```jsx
const redirectStartedRef = useRef(false)

useEffect(() => {
  if (isLoading || isAuthenticated || redirectStartedRef.current) return
  redirectStartedRef.current = true
  window.location.assign(loginPortalUrl)
}, [isLoading, isAuthenticated])
```

- Chamar `logout()` com `logoutParams: { returnTo: loginRedirectUrl }` para retornar ao portal de login.

## Dados Sensíveis

- Nunca logar tokens de acesso, `id_token` ou dados do usuário com `console.log`.
- Não armazenar tokens em `localStorage` ou `sessionStorage` — deixar o Auth0 SDK gerenciar.
- Nunca incluir segredos (chaves de API, client secrets) em código front-end ou em `.env` commitado.
- Não expor `VITE_AUTH0_CLIENT_ID` de produção em repositórios públicos.

## Sanitização

- Não usar `dangerouslySetInnerHTML` sem sanitização prévia do conteúdo com biblioteca aprovada (ex.: DOMPurify).
- Validar e sanitizar qualquer dado proveniente de `window.location` ou query params antes de usar.

## Política de Dependências

- Verificar vulnerabilidades conhecidas antes de adicionar novas dependências (`npm audit`).
- Não adicionar dependências com licenças incompatíveis (GPL, AGPL) sem aprovação.
- Preferir dependências já presentes no ecossistema `@dudxtec/*`.

## CORS e Requisições HTTP

- Configurar `audience` correto no `Auth0Provider` para que tokens sejam aceitos pelos `-ms`.
- Incluir o token de acesso (`getAccessTokenSilently`) no header `Authorization: Bearer` em chamadas a microserviços.
- Não fazer chamadas HTTP a APIs externas não aprovadas.
