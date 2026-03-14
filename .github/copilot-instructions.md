# Instruções para o GitHub Copilot — main-portal

## Visão geral do projeto

`main-portal` é o portal principal pós-login do ecossistema **dudxtec**. É uma aplicação React 19 + Vite que autentica o usuário via Auth0 e fornece navegação central para os demais módulos do ecossistema.

## Tecnologias e dependências

- **React 19** com JSX (sem TypeScript)
- **Vite 7** como bundler e servidor de desenvolvimento (porta `5171`)
- **Auth0** (`@auth0/auth0-react`) para autenticação SPA
- **@dudxtec/lib-portal-ui** — biblioteca interna de componentes de UI (`PortalShell`, `PortalTopUserActions`, `buildPortalNavigation`)
- **ESLint 9** com flat config (`eslint.config.js`)

## Módulos do ecossistema

| Variável de ambiente             | Portal                   | Porta padrão |
| -------------------------------- | ------------------------ | ------------ |
| `VITE_LOGIN_PORTAL_URL`          | login-portal             | 5172         |
| `VITE_COST_CENTER_PORTAL_URL`    | cost-center-portal       | 5173         |
| `VITE_TENANT_PORTAL_URL`         | tenant-portal            | 5174         |
| `VITE_PAYMENT_METHOD_PORTAL_URL` | payment-method-portal    | 5175         |
| `VITE_ENTRY_TYPE_PORTAL_URL`     | entry-type-portal        | 5176         |

## Convenções de código

- **Linguagem**: JavaScript (`.js`, `.jsx`) — sem TypeScript.
- **Componentes**: funções React com arrow functions ou declarações `function`; exportação default no final do arquivo.
- **Hooks**: use `useEffect`, `useRef`, `useState` da API padrão do React; evite criar hooks customizados desnecessários.
- **Variáveis de ambiente**: sempre lidas via `import.meta.env.VITE_*`; forneça sempre um valor fallback local (`|| 'http://localhost:<porta>/'`).
- **CSS**: estilos globais em `src/index.css`; estilos específicos de componente em arquivos `.css` importados diretamente no componente.
- **Estilo de código**: aspas simples, sem ponto-e-vírgula (`;`), indentação de 2 espaços.
- **Imports**: agrupe primeiro imports de bibliotecas externas, depois imports internos, depois assets e CSS.
- **Linting**: execute `npm run lint` antes de abrir um PR; não suprima regras do ESLint sem justificativa.

## Padrões de autenticação

- Utilize sempre `useAuth0()` para acessar `isLoading`, `isAuthenticated`, `user` e `logout`.
- Redirecione usuários não autenticados para `VITE_LOGIN_PORTAL_URL` usando `window.location.assign()`.
- Utilize `useRef` (`redirectStartedRef`) para evitar múltiplos redirecionamentos em StrictMode.

## Padrões de navegação

- Toda navegação entre portais usa `buildPortalNavigation({ active, urls })` da `@dudxtec/lib-portal-ui`.
- O campo `active` identifica o portal atual; use `'home'` neste repositório.
- O componente `PortalShell` envolve todo o conteúdo autenticado.

## Variáveis de ambiente

- Arquivo de referência: `.env.example` na raiz do projeto.
- Nunca comite o arquivo `.env` real.
- Toda nova variável de ambiente deve ser adicionada ao `.env.example` com um valor de exemplo.

## Scripts disponíveis

```sh
npm run dev      # inicia o servidor de desenvolvimento na porta 5171
npm run build    # gera o build de produção
npm run lint     # executa o ESLint
npm run preview  # pré-visualiza o build de produção
```
