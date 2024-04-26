ALTER TABLE "MaterialCostClasses" ADD COLUMN "Default" boolean;
UPDATE "MaterialCostClasses"  SET "Default" = true;
ALTER TABLE "MaterialCostClasses" ALTER COLUMN "Default" SET NOT NULL;

ALTER TABLE "PersonalSeniorities" ADD COLUMN "Default" boolean;
UPDATE "PersonalSeniorities"  SET "Default" = false;
ALTER TABLE "PersonalSeniorities" ALTER COLUMN "Default" SET NOT NULL;