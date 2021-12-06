
ALTER TABLE public.usergroup_collectable ALTER COLUMN usergroup_id SET NOT NULL;
ALTER TABLE public.usergroup_collectable ALTER COLUMN collectable_id SET NOT NULL;
ALTER TABLE public.usergroup_collectable ADD CONSTRAINT usergroup_collectable_uq UNIQUE (usergroup_id,collectable_id);
ALTER TABLE public.tag_collectable ADD CONSTRAINT tag_collectable_uq UNIQUE (collectable_id,tag_id);