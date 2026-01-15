-- Load data from staging tables with one JSON object per row

create or replace function jsonb_text_array(input jsonb)
returns text[]
language sql
immutable
as $$
  select case
    when input is null then '{}'::text[]
    when jsonb_typeof(input) <> 'array' then '{}'::text[]
    else array(select jsonb_array_elements_text(input))
  end;
$$;

create table if not exists stg_characters (payload jsonb not null);
create table if not exists stg_dialogues (payload jsonb not null);
create table if not exists stg_locations (payload jsonb not null);
create table if not exists stg_encyclopedia_entries (payload jsonb not null);
create table if not exists stg_quiz_categories (payload jsonb not null);
create table if not exists stg_quizzes (payload jsonb not null);

truncate table characters, dialogues, locations, encyclopedia_entries, quiz_categories, quizzes;

insert into characters (
  id,
  era_id,
  name,
  name_korean,
  title,
  birth,
  death,
  biography,
  full_biography,
  portrait_asset,
  emotion_assets,
  dialogue_ids,
  related_character_ids,
  related_location_ids,
  achievements,
  status,
  is_historical
)
select
  payload->>'id',
  payload->>'eraId',
  payload->>'name',
  payload->>'nameKorean',
  payload->>'title',
  payload->>'birth',
  payload->>'death',
  payload->>'biography',
  payload->>'fullBiography',
  payload->>'portraitAsset',
  jsonb_text_array(payload->'emotionAssets'),
  jsonb_text_array(payload->'dialogueIds'),
  jsonb_text_array(payload->'relatedCharacterIds'),
  jsonb_text_array(payload->'relatedLocationIds'),
  jsonb_text_array(payload->'achievements'),
  coalesce(payload->>'status', 'locked'),
  coalesce((payload->>'isHistorical')::boolean, true)
from stg_characters;

insert into dialogues (
  id,
  character_id,
  title,
  title_korean,
  description,
  estimated_minutes,
  nodes,
  rewards,
  is_completed
)
select
  payload->>'id',
  payload->>'characterId',
  payload->>'title',
  payload->>'titleKorean',
  payload->>'description',
  coalesce((payload->>'estimatedMinutes')::int, 5),
  coalesce(payload->'nodes', '[]'::jsonb),
  coalesce(payload->'rewards', '[]'::jsonb),
  coalesce((payload->>'isCompleted')::boolean, false)
from stg_dialogues;

insert into locations (
  id,
  era_id,
  name,
  name_korean,
  description,
  thumbnail_asset,
  background_asset,
  kingdom,
  latitude,
  longitude,
  display_year,
  timeline_order,
  position,
  character_ids,
  event_ids,
  status,
  is_historical
)
select
  payload->>'id',
  payload->>'eraId',
  payload->>'name',
  payload->>'nameKorean',
  payload->>'description',
  payload->>'thumbnailAsset',
  payload->>'backgroundAsset',
  payload->>'kingdom',
  (payload->>'latitude')::double precision,
  (payload->>'longitude')::double precision,
  payload->>'displayYear',
  (payload->>'timelineOrder')::int,
  coalesce(payload->'position', '{"x":0,"y":0}'::jsonb),
  jsonb_text_array(payload->'characterIds'),
  jsonb_text_array(payload->'eventIds'),
  coalesce(payload->>'status', 'locked'),
  coalesce((payload->>'isHistorical')::boolean, true)
from stg_locations;

insert into encyclopedia_entries (
  id,
  type,
  title,
  title_korean,
  summary,
  content,
  thumbnail_asset,
  image_asset,
  era_id,
  related_entry_ids,
  tags,
  is_discovered,
  discovered_at,
  discovery_source
)
select
  payload->>'id',
  payload->>'type',
  payload->>'title',
  payload->>'titleKorean',
  payload->>'summary',
  payload->>'content',
  payload->>'thumbnailAsset',
  payload->>'imageAsset',
  payload->>'eraId',
  jsonb_text_array(payload->'relatedEntryIds'),
  jsonb_text_array(payload->'tags'),
  coalesce((payload->>'isDiscovered')::boolean, false),
  (payload->>'discoveredAt')::timestamptz,
  payload->>'discoverySource'
from stg_encyclopedia_entries;

insert into quiz_categories (
  id,
  title,
  description,
  sort_order
)
select
  payload->>'id',
  payload->>'title',
  payload->>'description',
  coalesce((payload->>'sortOrder')::int, 0)
from stg_quiz_categories;

insert into quizzes (
  id,
  category_id,
  question,
  type,
  difficulty,
  options,
  correct_answer,
  explanation,
  image_asset,
  era_id,
  related_fact_id,
  related_dialogue_id,
  related_character_id,
  related_location_id,
  base_points,
  time_limit_seconds
)
select
  payload->>'id',
  payload->>'categoryId',
  payload->>'question',
  payload->>'type',
  payload->>'difficulty',
  jsonb_text_array(payload->'options'),
  payload->>'correctAnswer',
  payload->>'explanation',
  payload->>'imageAsset',
  payload->>'eraId',
  payload->>'relatedFactId',
  payload->>'relatedDialogueId',
  payload->>'relatedCharacterId',
  payload->>'relatedLocationId',
  coalesce((payload->>'basePoints')::int, 10),
  coalesce((payload->>'timeLimitSeconds')::int, 30)
from stg_quizzes;

insert into content_versions (dataset, version, checksum)
values
  ('characters', 'v1', null),
  ('dialogues', 'v1', null),
  ('locations', 'v1', null),
  ('encyclopedia_entries', 'v1', null),
  ('quiz_categories', 'v1', null),
  ('quizzes', 'v1', null)
on conflict (dataset)
do update set
  version = excluded.version,
  checksum = excluded.checksum,
  updated_at = now();
