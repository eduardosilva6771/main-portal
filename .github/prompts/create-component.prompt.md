---
description: "Criar um novo componente React seguindo os padrões do projeto"
---

Crie um novo componente React chamado `${componentName}` seguindo os padrões do projeto `main-portal`:

## Requisitos

1. **Arquivo**: `src/components/${componentName}.jsx`
2. **Estrutura**: function declaration com default export
3. **Props**: destruturadas na assinatura da função
4. **Estilo**: arquivo CSS separado em `src/components/${componentName}.css` (se necessário)
5. **Acessibilidade**: incluir atributos `aria-*` e roles semânticos adequados

## Template Base

```jsx
import './${componentName}.css'

function ${componentName}({ /* props */ }) {
  return (
    <section className="${componentName.replace(/([A-Z])/g, '-$1').toLowerCase().slice(1)}" aria-label="...">
      {/* conteúdo */}
    </section>
  )
}

export default ${componentName}
```

## Observações

- Usar classes CSS em kebab-case
- Não usar estilos inline para estilização estrutural
- Se o componente precisar de autenticação, usar o hook `useAuth0()` de `@auth0/auth0-react`
- Se o componente precisar de navegação entre portais, usar URLs de `import.meta.env.VITE_*_URL`
- Seguir as regras do ESLint configuradas em `eslint.config.js`
