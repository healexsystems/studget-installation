ALTER TABLE "CustomersSalaryTypes" ADD COLUMN "Enabled" boolean;
UPDATE "CustomersSalaryTypes"  SET "Enabled" = true;
ALTER TABLE "CustomersSalaryTypes" ALTER COLUMN "Enabled" SET NOT NULL;