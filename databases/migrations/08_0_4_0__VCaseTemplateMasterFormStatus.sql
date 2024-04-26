create view "VCaseTemplateMasterFormStatus" as 
select 
"CaseTemplatesMasterForms"."IdTemplateRow",
"CaseTemplatesMasterForms"."IdMasterForm",
"CaseTemplatesMasterForms"."IdCaseTemplate",
"CaseTemplatesMasterForms"."Index",
"CaseTemplatesMasterForms"."Name",
"CaseTemplatesMasterForms"."Blocked",
"Files"."Enabled"
from "Files"
inner join "CaseTemplatesMasterForms" on "CaseTemplatesMasterForms"."IdMasterForm" = "Files"."IdFile";

GRANT ALL ON TABLE public."VCaseTemplateMasterFormStatus" TO studget;