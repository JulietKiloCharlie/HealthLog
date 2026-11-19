-- Run in Supabase SQL Editor. Do not put real patient records in this SQL file.
-- Access is denied until you add the two verified parent emails below.
create table if not exists public.care_members (
  email text primary key check (email = lower(email)),
  added_at timestamptz not null default now()
);
create table if not exists public.care_entries (
  id uuid primary key,
  occurred_at timestamptz not null,
  payload jsonb not null check (jsonb_typeof(payload) = 'object'),
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists care_entries_occurred_at_idx on public.care_entries (occurred_at desc);
alter table public.care_members enable row level security;
alter table public.care_entries enable row level security;
revoke all on public.care_members from anon, authenticated;
revoke all on public.care_entries from anon;
grant select, insert, update on public.care_entries to authenticated;
-- Verify against Supabase Auth's verified email, not client-supplied profile data.
create or replace function public.is_care_member() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from auth.users u
    join public.care_members m on m.email = lower(u.email)
    where u.id = (select auth.uid()) and u.email_confirmed_at is not null
  );
$$;
revoke all on function public.is_care_member() from public, anon;
grant execute on function public.is_care_member() to authenticated;
drop policy if exists "Two parents read diary" on public.care_entries;
drop policy if exists "Two parents add entries" on public.care_entries;
drop policy if exists "Two parents update entries" on public.care_entries;
create policy "Two parents read diary" on public.care_entries for select to authenticated using ((select public.is_care_member()));
create policy "Two parents add entries" on public.care_entries for insert to authenticated with check ((select public.is_care_member()) and created_by = (select auth.uid()));
create policy "Two parents update entries" on public.care_entries for update to authenticated using ((select public.is_care_member())) with check ((select public.is_care_member()));
-- Optional: enable realtime publication (skip if already added).
do $$ begin
  alter publication supabase_realtime add table public.care_entries;
exception when duplicate_object then null;
end $$;
-- IMPORTANT: Replace placeholders with the two actual parent email addresses, lowercase.
-- Uncomment and run separately after creating and verifying their Supabase Auth accounts:
-- insert into public.care_members(email) values
--   ('parent-one@example.com'),
--   ('parent-two@example.com')
-- on conflict (email) do nothing;
