# main-portal

Portal principal pos-login para navegacao entre modulos (`cost-center-portal` e `tenant-portal`).

## Requisitos

- Flutter SDK 3.19+
- Dart SDK 3.3+
- Aplicacao Auth0 SPA configurada

## Setup

Crie `.env` com base no `.env.example`.

```sh
flutter pub get
```

## Executar

```sh
flutter run -d chrome
```

O portal sobe em `http://localhost:5171`.

Para especificar a porta:

```sh
flutter run -d web-server --web-port 5171
```

## Build

```sh
flutter build web
```

## Variaveis de ambiente

O arquivo `.env` deve conter:

- `AUTH0_DOMAIN`
- `AUTH0_CLIENT_ID`
- `AUTH0_AUDIENCE`
- `AUTH0_LOGIN_PORTAL_URL`
- `COST_CENTER_PORTAL_URL`
- `TENANT_PORTAL_URL`
- `ENTRY_TYPE_PORTAL_URL`
- `PAYMENT_METHOD_PORTAL_URL`