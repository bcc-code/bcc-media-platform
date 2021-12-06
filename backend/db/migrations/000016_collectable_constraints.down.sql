ALTER TABLE public.usergroup_collectable ALTER COLUMN usergroup_id DROP NOT NULL;
ALTER TABLE public.usergroup_collectable ALTER COLUMN collectable_id DROP NOT NULL;
ALTER TABLE public.usergroup_collectable DROP CONSTRAINT IF EXISTS usergroup_collectable_uq CASCADE;
ALTER TABLE public.tag_collectable DROP CONSTRAINT IF EXISTS tag_collectable_uq CASCADE;