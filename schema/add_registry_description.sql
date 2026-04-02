-- Add O*NET occupation description to registry (run once in Supabase SQL editor)
ALTER TABLE registry_metadata
  ADD COLUMN IF NOT EXISTS description TEXT;

COMMENT ON COLUMN registry_metadata.description IS
  'O*NET occupation description; populated by scripts/onet_metadata_sync.py';
