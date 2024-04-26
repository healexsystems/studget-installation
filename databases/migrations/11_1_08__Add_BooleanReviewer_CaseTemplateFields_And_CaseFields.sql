ALTER TABLE IF EXISTS "CaseTemplateFields"
    ADD COLUMN IF NOT EXISTS "ReviewerRequired" bool NOT NULL DEFAULT false;

ALTER TABLE IF EXISTS "CaseFields"
    ADD COLUMN IF NOT EXISTS "ReviewerRequired" bool NOT NULL DEFAULT false;  