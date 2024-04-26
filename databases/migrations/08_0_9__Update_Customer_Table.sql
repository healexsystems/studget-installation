ALTER TABLE "Customers" ADD COLUMN "Unlimited" boolean;
UPDATE "Customers" SET "Unlimited" = TRUE;
ALTER TABLE "Customers" ALTER COLUMN "Unlimited" SET NOT NULL;

ALTER TABLE "Customers" ADD COLUMN "MaxUser" SMALLINT;
UPDATE "Customers" SET "MaxUser" = null;