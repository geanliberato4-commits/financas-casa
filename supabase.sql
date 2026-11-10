-- Finanças da Casa: estrutura do banco (já aplicada no projeto financas-casa).

-- Quem pode usar o site (só as pessoas desta lista veem e mexem nos dados)
create table if not exists public.fin_membros (
  user_id uuid primary key references auth.users(id) on delete cascade,
  nome text not null
);

-- Entradas, saídas e movimentos da reserva
create table if not exists public.fin_lancamentos (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('entrada','saida','reserva')),
  valor numeric(12,2) not null,
  categoria text,
  descricao text,
  data date not null default current_date,
  quem text,
  criado_por uuid default auth.uid() references auth.users(id) on delete set null,
  criado_em timestamptz not null default now(),
  grupo uuid,        -- compras parceladas: todas as parcelas têm o mesmo grupo
  parcela int,       -- número da parcela (1, 2, 3...)
  parcelas int       -- total de parcelas
);
alter table public.fin_lancamentos add column if not exists grupo uuid;
alter table public.fin_lancamentos add column if not exists parcela int;
alter table public.fin_lancamentos add column if not exists parcelas int;
create index if not exists fin_lancamentos_grupo_idx on public.fin_lancamentos (grupo);
create index if not exists fin_lancamentos_data_idx on public.fin_lancamentos (data desc);

-- Configuração da reserva (uma linha só)
create table if not exists public.fin_config (
  id int primary key default 1 check (id = 1),
  percentual numeric(5,2) not null default 20,
  meta numeric(12,2) not null default 15000
);
alter table public.fin_config add column if not exists limites jsonb not null default '{}'::jsonb;     -- limite mensal por categoria
alter table public.fin_config add column if not exists categorias jsonb not null default '{}'::jsonb;  -- categorias personalizadas
insert into public.fin_config (id) values (1) on conflict (id) do nothing;

-- Outras metas (viagem, carro...)
create table if not exists public.fin_metas (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  alvo numeric(12,2) not null,
  guardado numeric(12,2) not null default 0,
  prazo date,
  criado_em timestamptz not null default now()
);

-- Função que diz se quem está logado é membro
create schema if not exists private;
grant usage on schema private to authenticated;
create or replace function private.fin_is_member()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.fin_membros where user_id = (select auth.uid()));
$$;
revoke all on function private.fin_is_member() from public, anon;
grant execute on function private.fin_is_member() to authenticated;

-- Segurança: só membros logados acessam
alter table public.fin_membros enable row level security;
alter table public.fin_lancamentos enable row level security;
alter table public.fin_config enable row level security;
alter table public.fin_metas enable row level security;

drop policy if exists "membros leem membros" on public.fin_membros;
create policy "membros leem membros" on public.fin_membros
  for select to authenticated using (private.fin_is_member());

drop policy if exists "membros usam lancamentos" on public.fin_lancamentos;
create policy "membros usam lancamentos" on public.fin_lancamentos
  for all to authenticated using (private.fin_is_member()) with check (private.fin_is_member());

drop policy if exists "membros leem config" on public.fin_config;
create policy "membros leem config" on public.fin_config
  for select to authenticated using (private.fin_is_member());
drop policy if exists "membros mudam config" on public.fin_config;
create policy "membros mudam config" on public.fin_config
  for update to authenticated using (private.fin_is_member()) with check (private.fin_is_member());

drop policy if exists "membros usam metas" on public.fin_metas;
create policy "membros usam metas" on public.fin_metas
  for all to authenticated using (private.fin_is_member()) with check (private.fin_is_member());

-- Atualização ao vivo entre os dois celulares
do $$ begin
  alter publication supabase_realtime add table public.fin_lancamentos;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.fin_config;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.fin_metas;
exception when duplicate_object then null; end $$;

-- ===========================================================
-- DEPOIS de criar os dois usuários em Authentication > Users,
-- troque os e-mails abaixo e rode só estas linhas:
-- ===========================================================
-- insert into public.fin_membros (user_id, nome)
--   select id, 'Gean' from auth.users where email = 'EMAIL_DO_GEAN';
-- insert into public.fin_membros (user_id, nome)
--   select id, 'Esposa' from auth.users where email = 'EMAIL_DA_ESPOSA';
