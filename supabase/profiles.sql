-- Optional: run in Supabase SQL editor. Links auth users to ENTERPRISE | ADMIN for RBAC.
-- RLS: adjust policies to match your security model.

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  role text not null check (role in ('ENTERPRISE', 'ADMIN')),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id);

-- Example: after signup, insert profile (or use a trigger).
-- insert into public.profiles (id, role) values ('<user-uuid>', 'ENTERPRISE');
