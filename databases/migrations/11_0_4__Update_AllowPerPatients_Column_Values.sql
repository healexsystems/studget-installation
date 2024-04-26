UPDATE "Subcases" SET "AllowPerPatients" = null WHERE "AllowPerPatients" = false;
UPDATE "Subcases" SET "AllowPerPatients" = "PerPatients" WHERE "AllowPerPatients" = true;
ALTER TABLE "Subcases" DROP COLUMN "PerPatients";

/*Validate if this applyl to masterforms*/
UPDATE "MasterForms" SET "AllowPerPatients" = null WHERE "AllowPerPatients" = false;