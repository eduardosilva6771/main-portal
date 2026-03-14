---
applyTo: "**/*.{js,jsx,env*}"
---

# Instruções para configuração de ambiente

## Variáveis de ambiente

- Todas as variáveis expostas ao browser devem ter o prefixo `VITE_`.
- Leia variáveis de ambiente no código usando `import.meta.env.VITE_NOME_DA_VARIAVEL`.
- Forneça **sempre** um valor de fallback local para desenvolvimento:
  ```js
  const minhaUrl = import.meta.env.VITE_MINHA_URL || 'http://localhost:<porta>/'
  ```
- Documente toda nova variável no arquivo `.env.example` com um valor de exemplo representativo.
- Nunca comite o arquivo `.env` — ele está no `.gitignore`.

## Portas dos portais

| Portal                    | Porta |
| ------------------------- | ----- |
| main-portal (este)        | 5171  |
| login-portal              | 5172  |
| cost-center-portal        | 5173  |
| tenant-portal             | 5174  |
| payment-method-portal     | 5175  |
| entry-type-portal         | 5176  |

## Auth0

- As variáveis `VITE_AUTH0_DOMAIN`, `VITE_AUTH0_CLIENT_ID`, `VITE_AUTH0_AUDIENCE` e `VITE_AUTH0_REDIRECT_URI` são obrigatórias.
- O `VITE_AUTH0_REDIRECT_URI` deve apontar para a origem do portal (ex.: `http://localhost:5171/`).
- Configure a aplicação Auth0 como **Single Page Application (SPA)**.
