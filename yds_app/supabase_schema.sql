-- Create words table
create table public.words (
  id uuid not null default gen_random_uuid (),
  english text not null,
  turkish text not null,
  part_of_speech text not null default 'noun',
  example_sentence text null,
  created_at timestamp with time zone not null default now(),
  constraint words_pkey primary key (id)
);

-- Create user_progress table
create table public.user_progress (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null references auth.users (id) on delete cascade,
  word_id uuid not null references public.words (id) on delete cascade,
  next_review_date timestamp with time zone not null default now(),
  interval integer not null default 0,
  ease_factor real not null default 2.5,
  created_at timestamp with time zone not null default now(),
  constraint user_progress_pkey primary key (id),
  constraint user_progress_word_unique unique (user_id, word_id)
);

-- Enable RLS
alter table public.words enable row level security;
alter table public.user_progress enable row level security;

-- Policies for words (Public read, Admin write - assuming public read for now)
create policy "Enable read access for all users" on public.words
  for select using (true);

-- Policies for user_progress (Users can CRUD their own progress)
create policy "Users can view their own progress" on public.user_progress
  for select using (auth.uid() = user_id);

create policy "Users can insert their own progress" on public.user_progress
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own progress" on public.user_progress
  for update using (auth.uid() = user_id);
