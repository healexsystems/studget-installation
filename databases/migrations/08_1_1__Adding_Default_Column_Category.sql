ALTER TABLE "Category" ADD COLUMN "Default" boolean;
UPDATE "Category" SET "Default" = false;
UPDATE "Category" SET "Default" = true WHERE "IdCategory" <= 125
