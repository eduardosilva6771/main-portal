---
applyTo: "src/**/*.css"
---

# Instruções para estilização CSS

## Organização

- `src/index.css` — estilos globais e variáveis CSS customizadas.
- `src/App.css` — estilos específicos do componente raiz `App`.
- Cada componente que necessitar de estilos próprios deve ter seu arquivo `.css` nomeado com o mesmo nome do componente (ex.: `MyComponent.css`).

## Convenções de nomenclatura

- Use **kebab-case** para nomes de classes (ex.: `.main-auth-gate`, `.login-card`).
- Prefixe classes de contêiner de página com o contexto (ex.: `main-`, `portal-`).
- Evite ids CSS para estilização; prefira classes.

## Boas práticas

- Prefira unidades relativas (`rem`, `%`, `vh`, `vw`) a valores fixos em `px` para layout.
- Use variáveis CSS (`--var-name`) para cores, espaçamentos e tipografia reutilizáveis.
- Não use `!important` sem justificativa explícita em comentário.
- Organize as propriedades na ordem: posicionamento → display/layout → dimensões → espaçamento → visual → tipografia → outros.
