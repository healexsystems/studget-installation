ALTER TABLE "CasesTemplates" DROP CONSTRAINT "FK_IdOrganizationalUnit";
ALTER TABLE "CasesTemplates" ADD CONSTRAINT "FK_IdOrganizationalUnit" FOREIGN KEY ("IdOrganizationalUnit") REFERENCES "Organizational_Units" ("IdOrganizationalunit") ON DELETE CASCADE;

ALTER TABLE "CaseTemplatesMasterForms" DROP CONSTRAINT "FK_CaseTemplates";
ALTER TABLE "CaseTemplatesMasterForms" ADD CONSTRAINT "FK_CaseTemplates" FOREIGN KEY ("IdCaseTemplate") REFERENCES "CasesTemplates"  ("IdCaseTemplate") ON DELETE CASCADE;

ALTER TABLE "GeneralSummations" DROP CONSTRAINT "IdCustomer";
ALTER TABLE "GeneralSummations" ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES "Customers" ("IdCustomer") ON DELETE CASCADE;

ALTER TABLE "Cases" DROP CONSTRAINT "FK_Owner";
ALTER TABLE "Cases" ADD CONSTRAINT  "FK_Owner" FOREIGN KEY ("Owner") REFERENCES "Users" ("UserName") ON DELETE CASCADE;

ALTER TABLE "Parameters" DROP CONSTRAINT "FK_IdOrganizationalUnit";
ALTER TABLE "Parameters" ADD CONSTRAINT "FK_IdOrganizationalUnit" FOREIGN KEY ("IdOrganizationalUnit") REFERENCES "Organizational_Units" ("IdOrganizationalunit") ON DELETE CASCADE;

ALTER TABLE "CaseTemplatesGeneralSummations" DROP CONSTRAINT "IdGeneralSummation";
ALTER TABLE "CaseTemplatesGeneralSummations" ADD CONSTRAINT "FK_IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES "GeneralSummations" ("IdGeneralSummation") ON DELETE CASCADE;

ALTER TABLE "CasesGeneralSummations" DROP CONSTRAINT "IdGeneralSummation";
ALTER TABLE "CasesGeneralSummations" ADD CONSTRAINT "FK_IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES "GeneralSummations" ("IdGeneralSummation") ON DELETE CASCADE;

ALTER TABLE "ParametersCaseTemplates" DROP CONSTRAINT "FK_IdCaseTemplate";
ALTER TABLE "ParametersCaseTemplates" ADD CONSTRAINT  "FK_IdCaseTemplate" FOREIGN KEY ("IdCaseTemplate") REFERENCES "CasesTemplates" ("IdCaseTemplate") ON DELETE CASCADE;

ALTER TABLE "ParametersMasterForms" DROP CONSTRAINT "FK_IdParameter";
ALTER TABLE "ParametersMasterForms" ADD CONSTRAINT  "FK_IdParameter" FOREIGN KEY ("IdParameter") REFERENCES "Parameters" ("IdParameter") ON DELETE CASCADE;

ALTER TABLE "ParametersSubcases" DROP CONSTRAINT "FK_IdParameter";
ALTER TABLE "ParametersSubcases" ADD CONSTRAINT  "FK_IdParameter" FOREIGN KEY ("IdParameter") REFERENCES "Parameters" ("IdParameter") ON DELETE CASCADE;







