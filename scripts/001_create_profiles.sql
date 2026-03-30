-- Profiles table to store user birth data and wallet info
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  birth_date date,
  birth_time time,
  birth_time_known boolean default false,
  birth_city text,
  sun_sign text,
  rising_sign text,
  moon_sign text,
  astro_balance integer default 500,
  trust_score integer default 0,
  onboarding_complete boolean default false,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

alter table public.profiles enable row level security;

create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id);
create policy "profiles_delete_own" on public.profiles for delete using (auth.uid() = id);

-- Session logs table for storing encrypted session records
create table if not exists public.session_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  facilitator_name text not null,
  transit_title text not null,
  session_date date default current_date,
  what_happened text,
  feeling_rating integer check (feeling_rating >= 1 and feeling_rating <= 5),
  what_shifted text,
  encrypted_cid text,
  created_at timestamp with time zone default now()
);

alter table public.session_logs enable row level security;

create policy "session_logs_select_own" on public.session_logs for select using (auth.uid() = user_id);
create policy "session_logs_insert_own" on public.session_logs for insert with check (auth.uid() = user_id);
create policy "session_logs_update_own" on public.session_logs for update using (auth.uid() = user_id);
create policy "session_logs_delete_own" on public.session_logs for delete using (auth.uid() = user_id);

-- Milestones table for tracking user achievements
create table if not exists public.milestones (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  milestone_type text not null,
  xp_earned integer default 0,
  earned_at timestamp with time zone default now()
);

alter table public.milestones enable row level security;

create policy "milestones_select_own" on public.milestones for select using (auth.uid() = user_id);
create policy "milestones_insert_own" on public.milestones for insert with check (auth.uid() = user_id);
