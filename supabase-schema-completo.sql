-- ============================================================
--  AIMZY · SCHEMA COMPLETO PARA SUPABASE
--
--  Como usar:
--   1. Abra seu projeto em https://supabase.com
--   2. Menu lateral: SQL Editor -> New query
--   3. Cole TODO este arquivo e clique em RUN
--   4. Aguarde conclusão
-- ============================================================

-- Tabela de Admins
create table if not exists public.admins (
  id text primary key,
  username text not null unique,
  password_hash text not null,
  role text not null default 'mod',
  must_change boolean default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_admins_username on public.admins(username);

-- Tabela de Usuários
create table if not exists public.users (
  id text primary key,
  device_id text,
  label text,
  is_vip boolean default false,
  vip_source text,
  vip_key_id text,
  vip_type text default 'premium',
  vip_since timestamptz,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz
);

create index if not exists idx_users_device_id on public.users(device_id);
create index if not exists idx_users_is_vip on public.users(is_vip);
create index if not exists idx_users_created_at on public.users(created_at);

-- Tabela de Keys
create table if not exists public.keys (
  id text primary key,
  code text not null unique,
  type text not null default 'premium',
  status text not null default 'ativa',
  plan text default '',
  plan_type text default 'premium',
  duration text default '',
  created_at timestamptz not null default now(),
  expires_at timestamptz,
  max_uses integer default 0,
  uses integer default 0,
  activated_by_user_id text,
  activated_by_label text,
  activated_at timestamptz
);

create index if not exists idx_keys_code on public.keys(code);
create index if not exists idx_keys_type on public.keys(type);
create index if not exists idx_keys_status on public.keys(status);
create index if not exists idx_keys_expires_at on public.keys(expires_at);
create index if not exists idx_keys_created_at on public.keys(created_at);

-- Tabela de Sessões
create table if not exists public.sessions (
  token text primary key,
  user_id text,
  admin_id text,
  is_admin boolean default false,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null
);

create index if not exists idx_sessions_user_id on public.sessions(user_id);
create index if not exists idx_sessions_admin_id on public.sessions(admin_id);
create index if not exists idx_sessions_expires_at on public.sessions(expires_at);
create index if not exists idx_sessions_is_admin on public.sessions(is_admin);

-- Tabela de Gerações
create table if not exists public.generations (
  id text primary key,
  at timestamptz not null default now(),
  user_id text,
  mode text,
  data jsonb default '{}'::jsonb
);

create index if not exists idx_generations_user_id on public.generations(user_id);
create index if not exists idx_generations_at on public.generations(at);
create index if not exists idx_generations_mode on public.generations(mode);

-- Tabela de Perfis
create table if not exists public.profiles (
  id text primary key,
  user_id text,
  name text,
  inputs jsonb default '{}'::jsonb,
  at timestamptz not null default now()
);

create index if not exists idx_profiles_user_id on public.profiles(user_id);

-- Tabela de Log de Auditoria
create table if not exists public.audit_log (
  id text primary key default gen_random_uuid()::text,
  at timestamptz not null default now(),
  action text not null,
  detail text default '',
  ip text default ''
);

create index if not exists idx_audit_log_at on public.audit_log(at desc);
create index if not exists idx_audit_log_action on public.audit_log(action);

-- Tabela de Configurações
create table if not exists public.settings (
  id text primary key default 'default',
  contact_link text default '',
  free_daily_limit integer default 3,
  admin_panel_path text default '/painel-admin',
  announcement text,
  prices jsonb default '{}'::jsonb,
  plans jsonb default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

-- Inserir configurações padrão
insert into public.settings (id, prices, plans) values (
  'default',
  '{"premium": {"1h": 1.50, "2h": 2.00, "3h": 2.50, "6h": 3.50, "12h": 3.50, "1d": 5.00, "3d": 6.00, "7d": 8.00, "15d": 10.00, "30d": 15.00, "permanent": 17.00}, "vip": {"1d": 1.00, "7d": 1.00, "30d": 1.00, "permanent": 1.00}}'::jsonb,
  '[{"id": "plan_premium_1h", "type": "premium", "name": "1 Hora", "price": 1.50, "active": true}, {"id": "plan_premium_2h", "type": "premium", "name": "2 Horas", "price": 2.00, "active": true}, {"id": "plan_premium_3h", "type": "premium", "name": "3 Horas", "price": 2.50, "active": true}, {"id": "plan_premium_6h", "type": "premium", "name": "6 Horas", "price": 3.50, "active": true}, {"id": "plan_premium_12h", "type": "premium", "name": "12 Horas", "price": 3.50, "active": true}, {"id": "plan_premium_1d", "type": "premium", "name": "1 Dia", "price": 5.00, "active": true}, {"id": "plan_premium_3d", "type": "premium", "name": "3 Dias", "price": 6.00, "active": true}, {"id": "plan_premium_7d", "type": "premium", "name": "7 Dias", "price": 8.00, "active": true}, {"id": "plan_premium_15d", "type": "premium", "name": "15 Dias", "price": 10.00, "active": true}, {"id": "plan_premium_30d", "type": "premium", "name": "30 Dias", "price": 15.00, "active": true}, {"id": "plan_premium_permanent", "type": "premium", "name": "Permanente", "price": 17.00, "active": true}, {"id": "plan_vip_1d", "type": "vip", "name": "1 Dia", "price": 1.00, "active": true}, {"id": "plan_vip_7d", "type": "vip", "name": "7 Dias", "price": 1.00, "active": true}, {"id": "plan_vip_30d", "type": "vip", "name": "30 Dias", "price": 1.00, "active": true}, {"id": "plan_vip_permanent", "type": "vip", "name": "Permanente", "price": 1.00, "active": true}]'::jsonb
) on conflict (id) do update set
  prices = excluded.prices,
  plans = excluded.plans,
  updated_at = now();

-- Tabela de Vendas (renomeada de 'sales' para 'vendas')
create table if not exists public.vendas (
  id text primary key,
  key_id text,
  key_code text default '',
  price numeric(10,2) default 0,
  buyer_label text default '',
  buyer_contact text default '',
  buyer_email text default '',
  product text default '',
  plan text default '',
  plan_type text default '',
  seller_admin_id text default '',
  seller_admin_name text default '',
  sold_at timestamptz not null default now(),
  notes text default '',
  status text default 'pago',
  expires_at timestamptz,
  receipt text default '',
  paid_at timestamptz,
  email_sent jsonb default '{"purchase": false, "approval": false, "reminder": false, "expiry": false}'::jsonb
);

create index if not exists idx_vendas_sold_at on public.vendas(sold_at);
create index if not exists idx_vendas_status on public.vendas(status);
create index if not exists idx_vendas_key_code on public.vendas(key_code);
create index if not exists idx_vendas_product on public.vendas(product);
create index if not exists idx_vendas_seller_admin_id on public.vendas(seller_admin_id);

-- Tabela de Produtos
create table if not exists public.products (
  id text primary key,
  name text not null default '',
  description text default '',
  active boolean default true,
  plans jsonb default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_products_active on public.products(active);

-- Tabela de Contas (accounts)
create table if not exists public.accounts (
  id text primary key,
  email text not null unique,
  password_hash text not null,
  user_id text,
  created_at timestamptz not null default now()
);

create index if not exists idx_accounts_email on public.accounts(email);
create index if not exists idx_accounts_user_id on public.accounts(user_id);

-- Tabela de dados gerais (backup legado)
create table if not exists public.app_data (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  saved_at timestamptz not null default now()
);

-- ============================================================
-- Row Level Security (RLS) - Permitir acesso público por enquanto
-- Em produção, configure políticas mais restritivas
-- ============================================================

alter table public.admins enable row level security;
alter table public.users enable row level security;
alter table public.keys enable row level security;
alter table public.sessions enable row level security;
alter table public.generations enable row level security;
alter table public.profiles enable row level security;
alter table public.audit_log enable row level security;
alter table public.settings enable row level security;
alter table public.vendas enable row level security;
alter table public.products enable row level security;
alter table public.accounts enable row level security;
alter table public.app_data enable row level security;

-- Políticas de acesso aberto (trocar depois por autenticação real)
create policy "Allow all admins" on public.admins for all using (true) with check (true);
create policy "Allow all users" on public.users for all using (true) with check (true);
create policy "Allow all keys" on public.keys for all using (true) with check (true);
create policy "Allow all sessions" on public.sessions for all using (true) with check (true);
create policy "Allow all generations" on public.generations for all using (true) with check (true);
create policy "Allow all profiles" on public.profiles for all using (true) with check (true);
create policy "Allow all audit_log" on public.audit_log for all using (true) with check (true);
create policy "Allow all settings" on public.settings for all using (true) with check (true);
create policy "Allow all vendas" on public.vendas for all using (true) with check (true);
create policy "Allow all products" on public.products for all using (true) with check (true);
create policy "Allow all accounts" on public.accounts for all using (true) with check (true);
create policy "Allow all app_data" on public.app_data for all using (true) with check (true);

-- ============================================================
-- FIM DO SCHEMA
-- ============================================================
