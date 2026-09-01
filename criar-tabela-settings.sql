-- ============================================================
--  AIMZY · TABELA DE CONFIGURAÇÕES
--  Execute no Supabase SQL Editor se a tabela settings não existir
-- ============================================================

drop table if exists public.settings cascade;

create table public.settings (
  id text primary key default 'default',
  contact_link text default '',
  free_daily_limit integer default 3,
  admin_panel_path text default '/painel-admin',
  announcement jsonb default null,
  prices jsonb default '{}'::jsonb,
  plans jsonb default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

-- Garantir que existe pelo menos uma linha
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

alter table public.settings enable row level security;

create policy "Admin full access settings" on public.settings
  for all using (true) with check (true);
