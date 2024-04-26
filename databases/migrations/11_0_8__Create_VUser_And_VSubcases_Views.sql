CREATE OR REPLACE VIEW public."VCases"
 AS
 SELECT ca."IdCase",
    ca."Owner",
    ca."ClosedDate",
    ca."Duration",
    ca."IdCondition",
    co."ConditionName",
    ca."IdCustomer",
    ca."ResourcePoolFile",
    fc."IdOrganizationalUnit",
    ou."NameOrganizationalUnit" AS "OrganizationalUnitName",
    fc."Name",
    fc."IdStatus",
    fc."CreatedBy",
    fc."LastModified",
    fc."CreatedDate",
    fc."File",
    fc."CurrentEditor",
    fc."Enabled"
   FROM "Cases" ca
     JOIN "Files" fc ON ca."IdCase" = fc."IdFile"
     LEFT JOIN "Conditions" co ON ca."IdCondition" = co."IdCondition"
     LEFT JOIN "Organizational_Units" ou ON fc."IdOrganizationalUnit" = ou."IdOrganizationalunit";

GRANT ALL ON TABLE public."VCases" TO studget;

CREATE OR REPLACE VIEW public."VSubcases"
 AS
 SELECT s."IdSubcase",
    s."IdCase",
    s."Owner",
    s."ClosedDate",
    s."SummaryFile",
    s."Patients",
    s."Blocked",
    s."IdMasterForm",
    s."AllowPerPatients",
    f."IdOrganizationalUnit",
    f."Name",
    f."IdStatus",
    f."CreatedBy",
    f."LastModified",
    f."CreatedDate",
    f."File",
    f."CurrentEditor",
    f."Enabled",
    fc."Name" AS "CaseName",
    fm."Name" AS "MasterFormName",
    ca."Duration"
   FROM "Subcases" s
     JOIN "Files" fc ON s."IdCase" = fc."IdFile"
     LEFT JOIN "Files" f ON s."IdSubcase" = f."IdFile"
     LEFT JOIN "Cases" ca ON s."IdCase" = ca."IdCase"
     LEFT JOIN "Files" fm ON s."IdMasterForm" = fm."IdFile";

GRANT ALL ON TABLE public."VSubcases" TO studget;