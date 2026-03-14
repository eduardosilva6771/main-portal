# Instruções para o GitHub Copilot — main-portal

## Visão geral do projeto

`main-portal` é o portal principal pós-login do ecossistema **dudxtec**. É uma aplicação **Flutter web** que autentica o usuário via Auth0 e fornece navegação central para os demais módulos do ecossistema.

## Tecnologias e dependências

- **Flutter 3.x** com Dart 3.x (sem TypeScript, sem React)
- **auth0_flutter** (`^1.4.0`) para autenticação SPA via `Auth0Web`
- **url_launcher** (`^6.3.0`) para abrir módulos em nova aba
- **flutter_lints** (`^4.0.0`) para análise estática

## Módulos do ecossistema

| Variável de ambiente         | Portal                | Porta padrão |
| ---------------------------- | --------------------- | ------------ |
| `LOGIN_PORTAL_URL`           | login-portal          | 5172         |
| `COST_CENTER_PORTAL_URL`     | cost-center-portal    | 5173         |
| `TENANT_PORTAL_URL`          | tenant-portal         | 5174         |
| `PAYMENT_METHOD_PORTAL_URL`  | payment-method-portal | 5175         |
| `ENTRY_TYPE_PORTAL_URL`      | entry-type-portal     | 5176         |

> O `main-portal` sobe na porta `5171`.

## Convenções de código

- **Linguagem**: Dart (arquivos `.dart`).
- **Widgets**: classes que estendem `StatelessWidget` ou `StatefulWidget`; use `const` sempre que possível.
- **Configuração**: variáveis de ambiente injetadas via `--dart-define` em tempo de compilação; lidas com `String.fromEnvironment()` em `lib/config/app_config.dart`.
- **Web-only**: este projeto é exclusivamente Flutter web. Imports `dart:html` e `auth0_flutter_web.dart` são permitidos.
- **Redirecionamento de login**: use `dart:html`'s `window.location.assign()` para navegar na aba atual; use `url_launcher` para abrir módulos em nova aba.
- **Linting**: execute `flutter analyze` antes de abrir um PR.

## Padrões de autenticação

- Use `Auth0Web(domain, clientId)` para criar o cliente Auth0 na web.
- Chame `_auth0.onLoad(audience: ..., redirectUrl: Uri.base.origin)` no `initState` para processar o callback do Auth0.
- Verifique `_auth0.credentials` após `onLoad()`; se nulo, redirecione para `LOGIN_PORTAL_URL` com `html.window.location.assign()`.
- Logout: `_auth0.logout(returnToUrl: loginPortalUrl)`.

## Variáveis de ambiente

- Arquivo de referência: `.env.example` na raiz do projeto.
- Nunca comite o arquivo `.env` real.
- Toda nova variável de ambiente deve ser adicionada a `.env.example` e a `lib/config/app_config.dart`.
- As variáveis **não** usam prefixo `VITE_` (este não é um projeto Vite/React).

## Scripts disponíveis

```sh
flutter pub get                          # instala dependências
flutter analyze                          # lint e análise estática
flutter run -d chrome --web-port 5171 \  # desenvolvimento local
  --dart-define=AUTH0_DOMAIN=...
flutter build web --dart-define=...      # build de produção (output: build/web/)
```

## Web — requisitos obrigatórios

O arquivo `web/index.html` **deve** carregar o Auth0 SPA JS SDK antes do bootstrap do Flutter:

```html
<script src="https://cdn.auth0.com/js/auth0-spa-js/2.0/auth0-spa-js.production.min.js"></script>
```

Sem este script, o pacote `auth0_flutter` falha em tempo de execução na web.
