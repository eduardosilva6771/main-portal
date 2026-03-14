---
applyTo: "**/*.{dart,yaml,env*}"
---

# Instruções para configuração de ambiente

## Variáveis de ambiente

- As variáveis são injetadas em **tempo de compilação** via `--dart-define=NOME=valor`.
- Leia variáveis no código usando `String.fromEnvironment('NOME', defaultValue: '...')` em `lib/config/app_config.dart`.
- **Não** use prefixo `VITE_` — este não é um projeto Vite/React.
- Nunca comite o arquivo `.env` real (está no `.gitignore`).
- Toda nova variável deve ser adicionada ao `.env.example` e a `lib/config/app_config.dart`.

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

- As variáveis `AUTH0_DOMAIN`, `AUTH0_CLIENT_ID` e `AUTH0_AUDIENCE` são obrigatórias.
- Configure a aplicação Auth0 como **Single Page Application (SPA)**.
- Adicione `http://localhost:5171` (e a URL de produção) como **Allowed Callback URL** e **Allowed Logout URL** na aplicação Auth0.

## Build

```sh
flutter build web \
  --dart-define=AUTH0_DOMAIN=<dominio> \
  --dart-define=AUTH0_CLIENT_ID=<client-id> \
  --dart-define=AUTH0_AUDIENCE=<audience> \
  --dart-define=LOGIN_PORTAL_URL=<url> \
  --dart-define=COST_CENTER_PORTAL_URL=<url> \
  --dart-define=TENANT_PORTAL_URL=<url> \
  --dart-define=ENTRY_TYPE_PORTAL_URL=<url> \
  --dart-define=PAYMENT_METHOD_PORTAL_URL=<url>
```

Em CI, as variáveis são lidas de **GitHub Secrets** (`secrets.AUTH0_DOMAIN`, etc.).
