ALTER TABLE "CaseTemplatesMasterForms" DROP CONSTRAINT "FK_MasterForms";

ALTER TABLE "CaseTemplatesMasterForms" 
ADD CONSTRAINT "FK_IdMasterForm_CaseTemplate" 
FOREIGN KEY ("IdMasterForm") 
REFERENCES "MasterForms"  ("IdMasterForm") 
ON DELETE CASCADE;

ALTER TABLE "MasterFormsGeneralSummations" DROP CONSTRAINT "IdMasterForm";

ALTER TABLE "MasterFormsGeneralSummations" 
ADD CONSTRAINT "FK_IdMasterForm_GeneralSummations" 
FOREIGN KEY ("IdMasterForm") 
REFERENCES "MasterForms"  ("IdMasterForm") 
ON DELETE CASCADE;

ALTER TABLE "ParametersMasterForms" DROP CONSTRAINT "FK_MasterForm";

ALTER TABLE "ParametersMasterForms" 
ADD CONSTRAINT "FK_IdMasterForm_Parameter"
FOREIGN KEY ("IdMasterForm") 
REFERENCES "MasterForms"  ("IdMasterForm") 
ON DELETE CASCADE;

ALTER TABLE "SubcasesGeneralSummations" DROP CONSTRAINT "IdSubcase";

ALTER TABLE "SubcasesGeneralSummations"
ADD CONSTRAINT "FK_ISubcase_GeneralSummation"
FOREIGN KEY ("IdSubcase") 
REFERENCES "Subcases"  ("IdSubcase") 
ON DELETE CASCADE;


ALTER TABLE "Subcases"
ADD CONSTRAINT "FK_IdMasterForm_Subcase"
FOREIGN KEY ("IdMasterForm" ) 
REFERENCES "MasterForms"  ("IdMasterForm" ) 
ON DELETE CASCADE;