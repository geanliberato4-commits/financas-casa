# Finanças da Casa

Controle financeiro do Gean e da esposa: entradas, saídas por categoria, maiores gastos e reserva com porcentagem segura.

## Como colocar no ar

1. **Supabase**: abra o projeto e vá em **SQL Editor**. Cole o conteúdo de `supabase.sql` e clique em **Run**.
2. **Bloquear cadastros**: vá em **Authentication > Sign In / Providers** e desligue a opção **Allow new users to sign up**. Assim ninguém mais cria conta.
3. **Criar as contas**: vá em **Authentication > Users > Add user > Create new user**. Crie uma conta para você e outra para sua esposa, com e-mail e senha, e marque **Auto Confirm User**.
4. **Liberar as contas**: no **SQL Editor**, rode as duas linhas do fim do `supabase.sql`, trocando pelos e-mails que você usou.
5. **Chaves**: vá em **Project Settings > API**. Copie a **Project URL** e a chave **anon public** (ou **publishable**) e cole no arquivo `config.js`.
6. **Site**: o site é publicado pelo GitHub Pages (Settings > Pages > Branch `main`).
7. **Link de "Esqueci minha senha"**: no Supabase, vá em **Authentication > URL Configuration**. Em **Site URL**, coloque o endereço do site (ex.: `https://geanliberato4-commits.github.io/financas-casa/`) e adicione o mesmo endereço em **Redirect URLs**.

Os dados só aparecem para quem entrar com uma das duas contas. A chave do `config.js` pode ficar pública: sem login, ela não mostra nada.
