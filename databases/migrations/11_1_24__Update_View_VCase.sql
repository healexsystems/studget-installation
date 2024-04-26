CREATE OR REPLACE VIEW public."VCases"
 AS
 SELECT ca."IdCase",
    ca."Owner",
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
    fc."LastModified",
    fc."CreatedDate",
    fc."File",
    fc."CurrentEditor",
    fc."Enabled"
   FROM "Cases" ca
     JOIN "Files" fc ON ca."IdCase" = fc."IdFile"
     LEFT JOIN "Organizational_Units" ou ON fc."IdOrganizationalUnit" = ou."IdOrganizationalunit"
     LEFT JOIN "Conditions" co ON ca."IdCondition" = co."IdCondition" AND co."IdCustomer" = ou."IdCustomer";