---
description: "Revisar o código alterado em busca de problemas de qualidade, segurança e padrões do projeto"
---

Revise o código alterado neste PR/sessão verificando os seguintes aspectos:

## 1. Padrões do Projeto

- [ ] Componentes usam function declaration (não arrow function no nível de módulo)?
- [ ] Props são destruturadas na assinatura da função?
- [ ] Arquivos de componentes nomeados em PascalCase com extensão `.jsx`?
- [ ] Usa `import`/`export` (ES Modules), sem `require()`?
- [ ] Aspas simples em strings JS, ponto-e-vírgula ao final?

## 2. Variáveis de Ambiente

- [ ] Variáveis de ambiente acessadas via `import.meta.env.VITE_*`?
- [ ] Todos os acessos de `import.meta.env` têm valor padrão de fallback?
- [ ] `.env.example` está atualizado com novas variáveis?

## 3. Segurança e Autenticação

- [ ] `isLoading` verificado antes de `isAuthenticated`?
- [ ] Nenhum token ou segredo exposto em logs, estado ou bundle?
- [ ] `dangerouslySetInnerHTML` ausente ou com sanitização?
- [ ] `useRef` usado para evitar redirecionamentos duplicados?

## 4. Qualidade de Código

- [ ] Sem variáveis não utilizadas (exceto constantes `UPPER_CASE`)?
- [ ] Efeitos `useEffect` com cleanup quando necessário?
- [ ] Sem `console.log` de depuração esquecido?
- [ ] Mensagens de erro exibidas com `aria-live` ou `role="alert"`?

## 5. Dependências

- [ ] Novas dependências aprovadas e sem vulnerabilidades conhecidas (`npm audit`)?
- [ ] Sem introdução de TypeScript sem alinhamento da equipe?

Reporte os problemas encontrados com sugestão de correção.
