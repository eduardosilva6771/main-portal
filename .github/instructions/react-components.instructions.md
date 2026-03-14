---
applyTo: "src/**/*.{js,jsx}"
---

# Instruções para componentes React

## Estrutura de um componente

- Use funções nomeadas com `function NomeDoComponente()` ou arrow functions atribuídas a `const`.
- Exporte o componente como **default** no final do arquivo.
- Importe React explicitamente apenas quando necessário (hooks, tipos); em JSX puro o import não é obrigatório com o novo JSX transform.

## Boas práticas de JSX

- Prefira elementos semânticos HTML (`<main>`, `<section>`, `<nav>`, `<header>`) a `<div>` genéricas.
- Sempre forneça `aria-label` ou `aria-hidden` onde apropriado para acessibilidade.
- Não use `index` como `key` em listas a menos que a lista seja estática e não reordenável.

## Hooks

- Declare todos os hooks no topo do componente, antes de qualquer lógica condicional.
- Use `useRef` para valores mutáveis que não devem re-renderizar o componente (ex.: flags de controle de redirecionamento).
- Liste todas as dependências em `useEffect`; evite suprimir o lint de dependências.

## Integração com @dudxtec/lib-portal-ui

- Importe apenas o que for necessário: `import { PortalShell, PortalTopUserActions, buildPortalNavigation } from '@dudxtec/lib-portal-ui'`
- Consulte a documentação da biblioteca antes de criar componentes de layout ou navegação customizados.
- O componente `PortalShell` aceita as props: `brandKicker`, `brandTitle`, `exclusiveNavigation`, `railItems`, `menuItems`, `topLeft`, `topRight` e filhos.

## Estilo

- Importe arquivos CSS com `import './NomeDoComponente.css'`
- Nomes de classes CSS seguem o padrão kebab-case (ex.: `main-auth-gate`, `login-card`).
