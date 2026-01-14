-- Supabase content schema

create table if not exists characters (
  id text primary key,
  era_id text not null,
  name text not null,
  name_korean text not null,
  title text,
  birth text,
  death text,
  biography text,
  full_biography text,
  portrait_asset text,
  emotion_assets text[] not null default '{}',
  dialogue_ids text[] not null default '{}',
  related_character_ids text[] not null default '{}',
  related_location_ids text[] not null default '{}',
  achievements text[] not null default '{}',
  status text not null default 'locked',
  is_historical boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists dialogues (
  id text primary key,
  character_id text not null,
  title text not null,
  title_korean text not null,
  description text,
  estimated_minutes int not null default 5,
  nodes jsonb not null default '[]'::jsonb,
  rewards jsonb not null default '[]'::jsonb,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists locations (
  id text primary key,
  era_id text not null,
  name text not null,
  name_korean text not null,
  description text,
  thumbnail_asset text,
  background_asset text,
  kingdom text,
  latitude double precision,
  longitude double precision,
  display_year text,
  timeline_order int,
  position jsonb not null default '{"x":0,"y":0}'::jsonb,
  character_ids text[] not null default '{}',
  event_ids text[] not null default '{}',
  status text not null default 'locked',
  is_historical boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists encyclopedia_entries (
  id text primary key,
  type text not null,
  title text not null,
  title_korean text not null,
  summary text,
  content text,
  thumbnail_asset text,
  image_asset text,
  era_id text not null,
  related_entry_ids text[] not null default '{}',
  tags text[] not null default '{}',
  is_discovered boolean not null default false,
  discovered_at timestamptz,
  discovery_source text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists quiz_categories (
  id text primary key,
  title text not null,
  description text,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists quizzes (
  id text primary key,
  category_id text,
  question text not null,
  type text not null,
  difficulty text not null,
  options text[] not null default '{}',
  correct_answer text not null,
  explanation text,
  image_asset text,
  era_id text not null,
  related_fact_id text,
  related_dialogue_id text,
  related_character_id text,
  related_location_id text,
  base_points int not null default 10,
  time_limit_seconds int not null default 30,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists content_versions (
  dataset text primary key,
  version text,
  checksum text,
  updated_at timestamptz not null default now()
);

create index if not exists characters_era_id_idx on characters (era_id);
create index if not exists dialogues_character_id_idx on dialogues (character_id);
create index if not exists locations_era_id_idx on locations (era_id);
create index if not exists encyclopedia_entries_era_id_idx on encyclopedia_entries (era_id);
create index if not exists quizzes_era_id_idx on quizzes (era_id);
create index if not exists quizzes_dialogue_id_idx on quizzes (related_dialogue_id);
create index if not exists quizzes_category_id_idx on quizzes (category_id);

create or replace function set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger characters_set_updated_at
before update on characters
for each row execute function set_updated_at();

create trigger dialogues_set_updated_at
before update on dialogues
for each row execute function set_updated_at();

create trigger locations_set_updated_at
before update on locations
for each row execute function set_updated_at();

create trigger encyclopedia_entries_set_updated_at
before update on encyclopedia_entries
for each row execute function set_updated_at();

create trigger quiz_categories_set_updated_at
before update on quiz_categories
for each row execute function set_updated_at();

create trigger quizzes_set_updated_at
before update on quizzes
for each row execute function set_updated_at();

alter table characters enable row level security;
alter table dialogues enable row level security;
alter table locations enable row level security;
alter table encyclopedia_entries enable row level security;
alter table quiz_categories enable row level security;
alter table quizzes enable row level security;
alter table content_versions enable row level security;

create policy "public read characters" on characters
  for select using (true);
create policy "public read dialogues" on dialogues
  for select using (true);
create policy "public read locations" on locations
  for select using (true);
create policy "public read encyclopedia_entries" on encyclopedia_entries
  for select using (true);
create policy "public read quiz_categories" on quiz_categories
  for select using (true);
create policy "public read quizzes" on quizzes
  for select using (true);
create policy "public read content_versions" on content_versions
  for select using (true);

create policy "service role write characters" on characters
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write dialogues" on dialogues
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write locations" on locations
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write encyclopedia_entries" on encyclopedia_entries
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write quiz_categories" on quiz_categories
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write quizzes" on quizzes
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
create policy "service role write content_versions" on content_versions
  for all using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');
