# Finanças da Casa

Controle financeiro para casais e para quem mora sozinho: entradas, saídas por categoria, maiores gastos, parcelas, reserva com porcentagem segura e outras metas.

- Site: https://geanliberato4-commits.github.io/financas-casa/
- Banco: Supabase, projeto `financas-casa` (São Paulo).

## Como funciona o acesso

- Cada conta tem **um usuário e uma senha**. A conta pode ser de **casal** (os dois usam o mesmo login) ou **individual**.
- A primeira conta criada no app é a do **administrador**. Só ela vê a área "Casais do app" em Ajustes, onde dá para criar contas para outros casais ou pessoas, trocar senhas esquecidas e excluir contas.
- O administrador vê só o usuário, os nomes e as datas de cada conta. As finanças de cada casal ficam protegidas no próprio banco (Row Level Security): cada conta só lê e grava o que é dela.

## Arquivos

- `index.html`: o app inteiro (telas, estilo e lógica).
- `config.js`: endereço e chave pública do Supabase. A chave pode ser pública: sem login, ela não mostra nada.
- `manifest.json` e ícones: para instalar na tela do celular.
