CREATE OR REPLACE VIEW "VSubcases" AS
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
    ca."Duration",
    s."Index"
   FROM "Subcases" s
     JOIN "Files" f ON s."IdSubcase" = f."IdFile"
     LEFT JOIN "Files" fc ON s."IdCase" = fc."IdFile"
     LEFT JOIN "Cases" ca ON s."IdCase" = ca."IdCase"
     LEFT JOIN "Files" fm ON s."IdMasterForm" = fm."IdFile"
     LEFT JOIN "Users" ow ON s."Owner"::text = ow."UserName"::text
     LEFT JOIN "Users" cb ON f."CreatedBy"::text = cb."UserName"::text
   ORDER BY "IdCase", "Index";