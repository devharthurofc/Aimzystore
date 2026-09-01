-- ============================================================
--  AIMZY · CORREÇÃO DEFINITIVA DO SUPABASE
--  Execute no SQL Editor do Supabase
-- ============================================================

-- 1) Admins
alter table public.admins enable row level security;
drop policy if exists "Server full access admins" on public.admins;
create policy "Server full access admins"
on public.admins for all
using (true)
with check (true);

-- 2) Settings
alter table public.settings enable row level security;
drop policy if exists "Server full access settings" on public.settings;
create policy "Server full access settings"
on public.settings for all
using (true)
with check (true);

alter table public.settings add column if not exists announcement jsonb;
alter table public.settings add column if not exists prices jsonb default '{}'::jsonb;
alter table public.settings add column if not exists admin_panel_path text default '';
alter table public.settings add column if not exists plans jsonb default '[]'::jsonb;

-- 3) Accounts
create table if not exists public.accounts (
  id text primary key,
  email text not null unique,
  password_hash text not null,
  user_id text,
  created_at timestamptz not null default now()
);

alter table public.accounts enable row level security;
drop policy if exists "Server full access accounts" on public.accounts;
create policy "Server full access accounts"
on public.accounts for all
using (true)
with check (true);

-- 4) Keys
alter table public.keys add column if not exists type text default 'premium';
alter table public.keys add column if not exists plan text default '';
alter table public.keys add column if not exists plan_type text default '';
alter table public.keys add column if not exists duration text default '';

-- 5) Users
alter table public.users add column if not exists vip_type text default 'premium';

-- 6) Vendas
alter table public.vendas add column if not exists key_id text;
alter table public.vendas add column if not exists key_code text default '';
alter table public.vendas add column if not exists buyer_email text default '';
alter table public.vendas add column if not exists product text default '';
alter table public.vendas add column if not exists plan text default '';
alter table public.vendas add column if not exists plan_type text default '';
alter table public.vendas add column if not exists seller_admin_id text default '';
alter table public.vendas add column if not exists seller_admin_name text default '';
alter table public.vendas add column if not exists expires_at timestamptz;
alter table public.vendas add column if not exists receipt text default '';
alter table public.vendas add column if not exists paid_at timestamptz;
alter table public.vendas add column if not exists status text default 'pendente';
alter table public.vendas add column if not exists notes text default '';
alter table public.vendas add column if not exists email_sent jsonb default '{"purchase":false,"approval":false,"reminder":false,"expiry":false}'::jsonb;

alter table public.vendas enable row level security;
drop policy if exists "Server full access vendas" on public.vendas;
create policy "Server full access vendas"
on public.vendas for all
using (true)
with check (true);

-- 7) Garanta que settings tenha pelo menos uma linha
insert into public.settings (id, prices, plans)
values (
  'default',
  '{"premium":{"1h":1.50,"2h":2.00,"3h":2.50,"6h":3.50,"12h":3.50,"1d":5.00,"3d":6.00,"7d":8.00,"15d":10.00,"30d":15.00,"permanent":17.00},"vip":{"1d":1.00,"7d":1.00,"30d":1.00,"permanent":1.00}}'::jsonb,
  '[{"id":"plan_premium_1h","type":"premium","name":"1 Hora","price":1.50,"active":true},{"id":"plan_premium_2h","type":"premium","name":"2 Horas","price":2.00,"active":true},{"id":"plan_premium_3h","type":"premium","name":"3 Horas","price":2.50,"active":true},{"id":"plan_premium_6h","type":"premium","name":"6 Horas","price":3.50,"active":true},{"id":"plan_premium_12h","type":"premium","name":"12 Horas","price":3.50,"active":true},{"id":"plan_premium_1d","type":"premium","name":"1 Dia","price":5.00,"active":true},{"id":"plan_premium_3d","type":"premium","name":"3 Dias","price":6.00,"active":true},{"id":"plan_premium_7d","type":"premium","name":"7 Dias","price":8.00,"active":true},{"id":"plan_premium_15d","type":"premium","name":"15 Dias","price":10.00,"active":true},{"id":"plan_premium_30d","type":"premium","name":"30 Dias","price":15.00,"active":true},{"id":"plan_premium_permanent","type":"premium","name":"Permanente","price":17.00,"active":true},{"id":"plan_vip_1d","type":"vip","name":"1 Dia","price":1.00,"active":true},{"id":"plan_vip_7d","type":"vip","name":"7 Dias","price":1.00,"active":true},{"id":"plan_vip_30d","type":"vip","name":"30 Dias","price":1.00,"active":true},{"id":"plan_vip_permanent","type":"vip","name":"Permanente","price":1.00,"active":true}]'::jsonb
)
on conflict (id) do update set
  prices = excluded.prices,
  plans = excluded.plans,
  updated_at = now();

-- ============================================================
-- FIM
-- ============================================================
