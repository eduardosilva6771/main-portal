---
applyTo: "src/**/*.{js,jsx}"
---

# Instruções para Componentes React

## Estrutura de Componente

- Declarar componentes com **function declaration**, não arrow function no nível de módulo.
- Destruturar props diretamente na assinatura: `function MyComponent({ label, onClick })`.
- Um componente por arquivo `.jsx`.
- Default export para o componente principal do arquivo.

```jsx
// ✅ correto
function UserCard({ name, email }) {
  return (
    <div className="user-card">
      <span>{name}</span>
      <span>{email}</span>
    </div>
  )
}

export default UserCard
```

## Hooks

- Chamar hooks apenas no nível superior do componente ou de um custom hook.
- Nomear custom hooks com o prefixo `use` (ex.: `usePortalNavigation`).
- Usar `useRef` para guardar valores mutáveis que não disparam re-render.
- Limpar efeitos em `useEffect` quando necessário (retornar função de cleanup).

## JSX

- Usar **fragmentos curtos** (`<>…</>`) em vez de `<div>` desnecessário.
- Passar `key` única e estável em listas (evitar índice do array como `key`).
- Usar `aria-*` para acessibilidade quando o elemento não tiver semântica nativa.
- Fechar todas as tags, incluindo tags auto-fechadas: `<img />`, `<input />`.

## Estilo CSS

- Usar **CSS modules** ou classes CSS plain declaradas em arquivos `.css` separados.
- Não usar estilos inline para estilização estrutural; usar apenas para valores dinâmicos.
- Nomear classes em **kebab-case** (ex.: `main-auth-gate`, `login-card`).

## Padrões com `@dudxtec/lib-portal-ui`

- Usar `PortalShell` como container raiz da página autenticada.
- Usar `PortalTopUserActions` para ações do usuário no topo.
- Usar `buildPortalNavigation` para construir itens de rail e menu de navegação.
- Não duplicar lógica de navegação; centralizar URLs nas variáveis de ambiente.

## Tratamento de Erro

- Exibir mensagem de erro quando `error` de `useAuth0()` estiver definido.
- Usar `aria-live` ou `role="alert"` em mensagens de erro visíveis.
- Não suprimir erros com `try/catch` vazio.
