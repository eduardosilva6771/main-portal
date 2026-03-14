# GitHub Copilot – Instruções do Repositório `main-portal`

## Contexto do Projeto

`main-portal` é o portal principal pós-login, responsável pela navegação entre módulos do ecossistema **dudxtec**. O projeto é um SPA em **React 19 + Vite**, autenticado via **Auth0**, que serve como shell de navegação entre os portais de módulos.

### Ecossistema de Repositórios

- **Portais** (`*-portal`): aplicações SPA React/Vite, cada uma em uma porta dedicada
  - `main-portal` → porta 5171
  - `login-portal` → porta 5172
  - `cost-center-portal` → porta 5173
  - `tenant-portal` → porta 5174
  - `payment-method-portal` → porta 5175
  - `entry-type-portal` → porta 5176
- **Microserviços** (`*-ms`): APIs backend que expõem os dados consumidos pelos portais

### Dependências Principais

- `react` ^19
- `react-dom` ^19
- `@auth0/auth0-react` — autenticação
- `@dudxtec/lib-portal-ui` — biblioteca de componentes compartilhados (local: `file:../lib-portal-ui`)
- `vite` — build e dev server
- `eslint` — linting

---

## Padrões de Código

### Linguagem e Módulos

- Usar **JavaScript** (`.js` / `.jsx`). Não introduzir TypeScript sem alinhamento da equipe.
- Usar **ES Modules** (`import`/`export`). Nunca usar `require()` ou CommonJS.
- Preferir **named exports** para componentes utilitários; **default export** para o componente principal de cada arquivo.

### Estilo

- **Aspas simples** (`'`) em strings JavaScript.
- **Ponto-e-vírgula** ao final das instruções.
- **2 espaços** de indentação.
- Seguir todas as regras do `eslint.config.js` presente na raiz do projeto.
- Não deixar variáveis não utilizadas (regra `no-unused-vars` ativa; exceção: constantes em `UPPER_CASE`).

### Componentes React

- Componentes como **funções** (`function MyComponent() {}`). Não usar `class`.
- Hooks (`useState`, `useEffect`, etc.) somente dentro de componentes ou custom hooks.
- Usar `useRef` para evitar efeitos colaterais duplicados em `StrictMode`.
- Props destrutivadas na assinatura da função.
- Nomear arquivos de componentes em **PascalCase** com extensão `.jsx`.

### Variáveis de Ambiente

- Acessar variáveis via `import.meta.env.VITE_*`.
- Sempre fornecer valor padrão de fallback para desenvolvimento local.
- Nunca usar `process.env` em código de front-end.
- Manter o arquivo `.env.example` atualizado com todas as variáveis necessárias.

---

## Autenticação (Auth0)

- Usar o hook `useAuth0()` para acessar estado de autenticação.
- Verificar `isLoading` antes de qualquer verificação de `isAuthenticated`.
- Redirecionar para `VITE_LOGIN_PORTAL_URL` quando não autenticado.
- Usar `useRef` para evitar redirecionamentos duplicados em `StrictMode`.
- Nunca expor tokens ou dados sensíveis no bundle ou em logs.

---

## Navegação Entre Portais

- URLs dos portais lidas exclusivamente de `import.meta.env.VITE_*_URL`.
- Usar `buildPortalNavigation` de `@dudxtec/lib-portal-ui` para construir itens de navegação.
- Navegar entre portais com `window.location.assign()` — não usar `react-router` para navegação cross-portal.

---

## Segurança

- Nunca fazer commit de segredos, tokens ou senhas (nem em comentários).
- Não usar `dangerouslySetInnerHTML` sem sanitização prévia.
- Não expor informações de autenticação no estado global ou em `localStorage` sem criptografia.
- Seguir o princípio de menor privilégio ao definir `audience` e `scope` do Auth0.

---

## Limites de Atuação do Copilot

- Fazer somente as alterações solicitadas. Não refatorar código não relacionado.
- Não atualizar versões de dependências sem solicitação explícita.
- Perguntar antes de adicionar novas dependências externas.
- Não remover ou alterar testes existentes sem justificativa.
