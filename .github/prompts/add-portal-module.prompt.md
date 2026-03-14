---
mode: "agent"
description: "Adiciona um novo portal/módulo ao ecossistema main-portal"
---

Adicione suporte a um novo portal/módulo chamado **`${input:moduleName}`** que rodará na porta **`${input:port}`**.

## Passos

### 1. Variável de ambiente

Adicione ao arquivo `.env.example`:
```
VITE_${input:moduleName:upper_snake_case}_URL=http://localhost:${input:port}/
```

### 2. Leitura da variável em `src/App.jsx`

Adicione junto às outras constantes de URL no topo do arquivo:
```js
const ${input:moduleName:camelCase}Url = import.meta.env.VITE_${input:moduleName:upper_snake_case}_URL || 'http://localhost:${input:port}/'
```

### 3. Navegação

Passe a nova URL para `buildPortalNavigation` dentro do objeto `urls`:
```js
${input:moduleName:camelCase}: ${input:moduleName:camelCase}Url,
```

### 4. Verificação

- Execute `npm run lint` para garantir que não há erros de lint.
- Confirme que o novo portal aparece na navegação ao rodar `npm run dev`.

## Convenções

- O nome da variável de ambiente segue o padrão `VITE_<NOME_EM_UPPER_SNAKE_CASE>_URL`.
- A constante JS segue o padrão `<nomeEmCamelCase>Url`.
- A chave no objeto `urls` de `buildPortalNavigation` segue camelCase sem o sufixo `Url`.
