DROP VIEW public."VCases";
DROP VIEW public."VSubcases";


CREATE OR REPLACE VIEW public."VCases"
 AS
 SELECT ca."IdCase",
    ca."Owner",
    ow."Name" AS "OwnerName",
    ca."ClosedDate",
    ca."Duration",
    ca."IdCondition",
    co."ConditionName",
    ou."IdCustomer",
    ca."ResourcePoolFile",
    fc."IdOrganizationalUnit",
    ou."NameOrganizationalUnit" AS "OrganizationalUnitName",
    fc."Name",
    fc."IdStatus",
    fc."CreatedBy",
    cb."Name" AS "CreatedByName",
    fc."LastModified",
    fc."CreatedDate",
    fc."File",
    fc."CurrentEditor",
    fc."Enabled"
   FROM "Cases" ca
     JOIN "Files" fc ON ca."IdCase" = fc."IdFile"
     LEFT JOIN "Organizational_Units" ou ON fc."IdOrganizationalUnit" = ou."IdOrganizationalunit"
     LEFT JOIN "Conditions" co ON ca."IdCondition" = co."IdCondition" AND co."IdCustomer" = ou."IdCustomer"
     LEFT JOIN "Users" ow ON ca."Owner" = ow."UserName"
     LEFT JOIN "Users" cb ON fc."CreatedBy" = cb."UserName";

CREATE OR REPLACE VIEW public."VSubcases"
 AS
 SELECT s."IdSubcase",
    s."IdCase",
    s."Owner",
    ow."Name" AS "OwnerName",
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
    cb."Name" AS "CreatedByName",
    f."LastModified",
    f."CreatedDate",
    f."File",
    f."CurrentEditor",
    f."Enabled",
    fc."Name" AS "CaseName",
    fm."Name" AS "MasterFormName",
    ca."Duration"
   FROM "Subcases" s
     JOIN "Files" f ON s."IdSubcase" = f."IdFile"
     LEFT JOIN "Files" fc ON s."IdCase" = fc."IdFile"
     LEFT JOIN "Cases" ca ON s."IdCase" = ca."IdCase"
     LEFT JOIN "Files" fm ON s."IdMasterForm" = fm."IdFile"
     LEFT JOIN "Users" ow ON s."Owner" = ow."UserName"
     LEFT JOIN "Users" cb ON f."CreatedBy" = cb."UserName";