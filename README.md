# main-portal

Portal principal pos-login para navegacao entre modulos (`cost-center-portal` e `tenant-portal`).

## Requisitos

- Node.js 24.x
- Aplicacao Auth0 SPA configurada

## Setup

```sh
npm install
```

Crie `.env` com base no `.env.example`.

## Executar

```sh
npm run dev
```

O portal sobe em `http://localhost:5171`.

## Variaveis de ambiente

- `VITE_AUTH0_DOMAIN`
- `VITE_AUTH0_CLIENT_ID`
- `VITE_AUTH0_AUDIENCE`
- `VITE_AUTH0_REDIRECT_URI`
- `VITE_LOGIN_PORTAL_URL`
- `VITE_COST_CENTER_PORTAL_URL`
- `VITE_TENANT_PORTAL_URL`