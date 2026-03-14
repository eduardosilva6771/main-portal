---
applyTo: "lib/**/*.dart"
---

# Instruções para código Dart / Flutter

## Estrutura de widgets

- Prefira `StatelessWidget` quando não há estado mutável.
- Use `const` em construtores e literais sempre que possível.
- Exporte widgets privados (prefixados com `_`) apenas dentro do mesmo arquivo.

## Boas práticas

- Declare `super.key` em todos os construtores de widgets públicos.
- Use `final` para campos imutáveis em `State`.
- Evite `print()`; use `debugPrint()` ou remova antes de commitar.
- Liste todos os imports em ordem: `dart:*`, depois `package:*`, depois imports relativos.

## Configuração

- Toda constante de ambiente fica em `lib/config/app_config.dart` via `String.fromEnvironment()`.
- Não use `dotenv` neste projeto; as variáveis são injetadas via `--dart-define`.

## Web-only

- Imports `dart:html` são permitidos (projeto web exclusivo).
- Imports `auth0_flutter/auth0_flutter_web.dart` são necessários para a autenticação web.
- Para redirecionar o usuário na aba atual, use `html.window.location.assign(url)`.
- Para abrir módulos externos em nova aba, use `url_launcher`'s `launchUrl()`.

## Integração Auth0

- Crie o cliente: `Auth0Web(AppConfig.auth0Domain, AppConfig.auth0ClientId)`.
- Processe o callback de login: `await _auth0.onLoad(audience: ..., redirectUrl: Uri.base.origin)`.
- Verifique credenciais: `final credentials = await _auth0.credentials;`.
- Logout: `await _auth0.logout(returnToUrl: returnToUrl)`.
