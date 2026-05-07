-- Optional: link auth users to role_name (ADMIN | ENTERPRISE). Query: user_roles where user_id = auth.uid()
create table if not exists public.user_roles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  role_name text not null check (role_name in ('ADMIN', 'ENTERPRISE')),
  updated_at timestamptz default now()
);

alter table public.user_roles enable row level security;

create policy "user_roles_select_own"
  on public.user_roles for select
  using (auth.uid() = user_id);

-- insert into public.user_roles (user_id, role_name) values ('<uuid>', 'ADMIN');
