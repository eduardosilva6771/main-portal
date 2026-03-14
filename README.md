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

## Variaveis de ambiente (--dart-define)

- `AUTH0_DOMAIN`
- `AUTH0_CLIENT_ID`
- `AUTH0_AUDIENCE`
- `LOGIN_PORTAL_URL`
- `COST_CENTER_PORTAL_URL`
- `TENANT_PORTAL_URL`
- `ENTRY_TYPE_PORTAL_URL`
- `PAYMENT_METHOD_PORTAL_URL`
