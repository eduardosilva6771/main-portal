---
mode: "agent"
description: "Cria um novo componente React seguindo as convenções do main-portal"
---

Crie um novo componente React no diretório `src/` com o nome **`${input:componentName}`**.

## Requisitos

1. Arquivo JSX em `src/${input:componentName}.jsx`
2. Arquivo CSS em `src/${input:componentName}.css` (pode estar vazio inicialmente)
3. O componente deve:
   - Usar função nomeada `function ${input:componentName}()`
   - Ser exportado como default no final do arquivo
   - Importar seu próprio arquivo CSS
   - Usar elementos HTML semânticos quando aplicável
   - Incluir atributos de acessibilidade (`aria-label`, `role`) onde necessário
4. Seguir as convenções do projeto:
   - Aspas simples
   - Sem ponto-e-vírgula
   - Indentação de 2 espaços
   - Nomes de classes CSS em kebab-case

## Exemplo de estrutura esperada

```jsx
import './${input:componentName}.css'

function ${input:componentName}() {
  return (
    <section className="${input:componentName:kebab-case}" aria-label="${input:componentName}">
      {/* conteúdo */}
    </section>
  )
}

export default ${input:componentName}
```

Após criar os arquivos, mostre-os para revisão.
