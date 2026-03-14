# entry-type-portal

Portal para gerenciamento de tipos de lançamento, construído com Flutter Web.

## Requisitos

- Flutter SDK 3.3.0 ou superior
- Aplicação Auth0 SPA configurada

## Setup

```sh
flutter pub get
```

Crie `.env` com base no `.env.example`.

## Executar

```sh
flutter run -d chrome --web-server-port 5176
```

O portal sobe em `http://localhost:5176`.

## Build

```sh
flutter build web
```

## Variáveis de ambiente

- `AUTH0_DOMAIN`
- `AUTH0_CLIENT_ID`
- `AUTH0_AUDIENCE`
- `AUTH0_REDIRECT_URI`
- `LOGIN_PORTAL_URL`
- `COST_CENTER_PORTAL_URL`
- `TENANT_PORTAL_URL`
- `PAYMENT_METHOD_PORTAL_URL`
