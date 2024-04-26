CREATE VIEW "VCaseTemplateCustomers" AS
SELECT 
"CasesTemplates"."IdCaseTemplate",
"Organizational_Units"."IdCustomer",
"CasesTemplates"."CaseTemplateName",
"CasesTemplates"."IdOrganizationalUnit"
FROM "CasesTemplates"
INNER JOIN "Organizational_Units" on "CasesTemplates"."IdOrganizationalUnit" = "Organizational_Units"."IdOrganizationalunit";

GRANT ALL ON TABLE public."VCaseTemplateCustomers" TO studget;