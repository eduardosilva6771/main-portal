---
description: "Adicionar suporte a um novo módulo/portal no main-portal"
---

Adicione suporte ao novo módulo `${moduleName}` no `main-portal`, seguindo os padrões do ecossistema:

## Passos

### 1. Variável de Ambiente

Adicionar em `.env.example`:
```
VITE_${MODULE_NAME_UPPER}_PORTAL_URL=http://localhost:${PORT}/
```

Adicionar no `src/main.jsx` ou `src/App.jsx` (onde as demais URLs são lidas):
```js
const ${moduleName}PortalUrl = import.meta.env.VITE_${MODULE_NAME_UPPER}_PORTAL_URL || 'http://localhost:${PORT}/'
```

### 2. Navegação

Incluir a URL do novo módulo no objeto `urls` passado para `buildPortalNavigation`:
```js
const { railItems, menuItems } = buildPortalNavigation({
  active: 'home',
  urls: {
    // ... URLs existentes
    ${moduleName}: ${moduleName}PortalUrl,
  },
})
```

### 3. Documentação

Atualizar o `README.md`:
- Adicionar `VITE_${MODULE_NAME_UPPER}_PORTAL_URL` na seção de variáveis de ambiente
- Descrever o novo módulo na introdução

## Observações

- A porta do novo portal deve ser única no ecossistema
- Não usar `react-router` para navegação cross-portal; usar `window.location.assign()`
- A URL deve ter trailing slash (`/`) para consistência
- O identificador do módulo em `active` deve seguir o padrão camelCase já usado em `buildPortalNavigation`
