
ALTER TABLE public.assetfiles ADD COLUMN service character varying(255) DEFAULT NULL;
ALTER TABLE public.assets ADD COLUMN mediabank_id text;
