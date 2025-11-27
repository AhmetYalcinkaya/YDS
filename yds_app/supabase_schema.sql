-- Create words table (Global word set - admin only)
create table public.words (
  id uuid not null default gen_random_uuid (),
  english text not null,
  turkish text not null,
  part_of_speech text not null default 'noun',
  example_sentence text null,
  created_at timestamp with time zone not null default now(),
  constraint words_pkey primary key (id)
);

-- Create user_words table (User-specific custom words)
create table public.user_words (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null references auth.users (id) on delete cascade,
  english text not null,
  turkish text not null,
  part_of_speech text not null default 'noun',
  example_sentence text null,
  created_at timestamp with time zone not null default now(),
  constraint user_words_pkey primary key (id)
);

-- Create users table (User profiles with display names)
create table public.users (
  id uuid not null references auth.users (id) on delete cascade,
  display_name text null,
  daily_target integer not null default 10,
  created_at timestamp with time zone not null default now(),
  constraint users_pkey primary key (id)
);

-- Create user_progress table
create table public.user_progress (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null references auth.users (id) on delete cascade,
  word_id uuid null references public.words (id) on delete cascade,
  user_word_id uuid null references public.user_words (id) on delete cascade,
  next_review_date timestamp with time zone not null default now(),
  interval integer not null default 0,
  ease_factor real not null default 2.5,
  created_at timestamp with time zone not null default now(),
  constraint user_progress_pkey primary key (id),
  constraint user_progress_word_unique unique (user_id, word_id, user_word_id),
  constraint user_progress_word_check check (
    (word_id is not null and user_word_id is null) or
    (word_id is null and user_word_id is not null)
  )
);

-- Enable RLS
alter table public.words enable row level security;
alter table public.user_words enable row level security;
alter table public.users enable row level security;
alter table public.user_progress enable row level security;

-- Policies for words (Public read only)
create policy "Enable read access for all users" on public.words
  for select using (true);

-- Policies for user_words (Users can CRUD their own words)
create policy "Users can view their own words" on public.user_words
  for select using (auth.uid() = user_id);

create policy "Users can insert their own words" on public.user_words
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own words" on public.user_words
  for update using (auth.uid() = user_id);

create policy "Users can delete their own words" on public.user_words
  for delete using (auth.uid() = user_id);

-- Policies for users (Users can read/update their own profile)
create policy "Users can view their own profile" on public.users
  for select using (auth.uid() = id);

create policy "Users can insert their own profile" on public.users
  for insert with check (auth.uid() = id);

create policy "Users can update their own profile" on public.users
  for update using (auth.uid() = id);

-- Policies for user_progress (Users can CRUD their own progress)
create policy "Users can view their own progress" on public.user_progress
  for select using (auth.uid() = user_id);

create policy "Users can insert their own progress" on public.user_progress
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own progress" on public.user_progress
  for update using (auth.uid() = user_id);
