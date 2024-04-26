ALTER TABLE "Seniority" ADD COLUMN "Enabled" boolean;
UPDATE "Seniority" SET "Enabled" = TRUE;
ALTER TABLE "Seniority" ALTER COLUMN "Enabled" SET NOT NULL;

ALTER TABLE "Category" ADD COLUMN "Enabled" boolean;
UPDATE "Category" SET "Enabled" = TRUE;
ALTER TABLE "Category" ALTER COLUMN "Enabled" SET NOT NULL;