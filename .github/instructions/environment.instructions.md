---
applyTo: "**/.env*,**/vite.config.{js,ts},**/*.{js,jsx}"
---

# Instruções de Ambiente e Configuração

## Variáveis de Ambiente

- Todas as variáveis de ambiente expostas ao front-end **devem** ter o prefixo `VITE_`.
- Acessar via `import.meta.env.VITE_NOME_DA_VARIAVEL`.
- Sempre fornecer um valor padrão para desenvolvimento local:

```js
// ✅ correto
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000'

// ❌ errado — falhará em desenvolvimento sem .env configurado
const apiUrl = import.meta.env.VITE_API_URL
```

- Nunca usar `process.env` — não está disponível no contexto Vite/browser.
- Manter `.env.example` com todas as variáveis necessárias e valores de exemplo seguros.
- Nunca commitar o arquivo `.env` com valores reais.

## Variáveis Obrigatórias

| Variável                        | Descrição                                   |
|---------------------------------|---------------------------------------------|
| `VITE_AUTH0_DOMAIN`             | Domínio Auth0 da aplicação                  |
| `VITE_AUTH0_CLIENT_ID`          | Client ID da aplicação Auth0 SPA            |
| `VITE_AUTH0_AUDIENCE`           | Audience (API identifier) Auth0             |
| `VITE_AUTH0_REDIRECT_URI`       | URI de redirecionamento após login          |
| `VITE_LOGIN_PORTAL_URL`         | URL do portal de login                      |
| `VITE_COST_CENTER_PORTAL_URL`   | URL do portal de centros de custo           |
| `VITE_TENANT_PORTAL_URL`        | URL do portal de tenants                    |
| `VITE_ENTRY_TYPE_PORTAL_URL`    | URL do portal de tipos de lançamento        |
| `VITE_PAYMENT_METHOD_PORTAL_URL`| URL do portal de meios de pagamento         |

## Configuração Vite

- Manter `resolve.dedupe: ['react', 'react-dom']` para evitar conflitos com `@dudxtec/lib-portal-ui`.
- Alterar a porta via `vite --port <PORTA> --strictPort` no script `dev`.
- Não remover `@vitejs/plugin-react` — necessário para JSX e Fast Refresh.

## Porta Dedicada

`main-portal` roda na **porta 5171**. Não alterar sem atualizar todos os portais dependentes que referenciam essa URL.
