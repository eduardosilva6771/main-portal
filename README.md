# main-portal

Portal principal pos-login para navegacao entre modulos (`cost-center-portal` e `tenant-portal`).

## Requisitos

- Flutter SDK 3.x
- Dart SDK 3.x
- Aplicacao Auth0 SPA configurada

## Setup

```sh
flutter pub get
```

## Executar

```sh
flutter run -d chrome \
  --dart-define=AUTH0_DOMAIN=<seu-dominio> \
  --dart-define=AUTH0_CLIENT_ID=<seu-client-id> \
  --dart-define=AUTH0_AUDIENCE=<sua-audience> \
  --dart-define=LOGIN_PORTAL_URL=http://localhost:5172/ \
  --dart-define=COST_CENTER_PORTAL_URL=http://localhost:5173/ \
  --dart-define=TENANT_PORTAL_URL=http://localhost:5174/ \
  --dart-define=ENTRY_TYPE_PORTAL_URL=http://localhost:5176/ \
  --dart-define=PAYMENT_METHOD_PORTAL_URL=http://localhost:5175/
```

O portal sobe em `http://localhost:5171` quando configurado com o `--web-port` adequado:

```sh
flutter run -d chrome --web-port 5171 --dart-define=...
```

## Build para producao

```sh
flutter build web \
  --dart-define=AUTH0_DOMAIN=<seu-dominio> \
  --dart-define=AUTH0_CLIENT_ID=<seu-client-id> \
  --dart-define=AUTH0_AUDIENCE=<sua-audience> \
  --dart-define=LOGIN_PORTAL_URL=<url-login> \
  --dart-define=COST_CENTER_PORTAL_URL=<url-cost-center> \
  --dart-define=TENANT_PORTAL_URL=<url-tenant> \
  --dart-define=ENTRY_TYPE_PORTAL_URL=<url-entry-type> \
  --dart-define=PAYMENT_METHOD_PORTAL_URL=<url-payment-method>
```

O build gerado estara em `build/web/`.

## Deploy no Railway

O Railway nao detecta Flutter Web automaticamente via Railpack. Este repositorio agora inclui um `Dockerfile` para:

- buildar o app com `flutter build web`
- embutir os valores de `--dart-define` no build
- servir `build/web` via Nginx

### Configuracao

1. No serviço do Railway, use este repositorio com o `Dockerfile` na raiz.
2. Configure as variaveis do serviço:
   - `AUTH0_DOMAIN`
   - `AUTH0_CLIENT_ID`
   - `AUTH0_AUDIENCE`
   - `LOGIN_PORTAL_URL`
   - `COST_CENTER_PORTAL_URL`
   - `TENANT_PORTAL_URL`
   - `ENTRY_TYPE_PORTAL_URL`
   - `PAYMENT_METHOD_PORTAL_URL`
3. Faça um novo deploy.

Observacao: em Flutter Web, esses valores sao resolvidos no build. Alterar variaveis no Railway exige novo deploy para refletir no frontend.

## Variaveis de ambiente (--dart-define)

- `AUTH0_DOMAIN`
- `AUTH0_CLIENT_ID`
- `AUTH0_AUDIENCE`
- `LOGIN_PORTAL_URL`
- `COST_CENTER_PORTAL_URL`
- `TENANT_PORTAL_URL`
- `ENTRY_TYPE_PORTAL_URL`
- `PAYMENT_METHOD_PORTAL_URL`
