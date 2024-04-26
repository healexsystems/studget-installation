-- View: public.VSubcases

-- DROP VIEW public."VSubcases";

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
     JOIN "Files" f ON s."IdSubcase" = f."IdFile"
     LEFT JOIN "Files" fc ON s."IdCase" = fc."IdFile"
     LEFT JOIN "Cases" ca ON s."IdCase" = ca."IdCase"
     LEFT JOIN "Files" fm ON s."IdMasterForm" = fm."IdFile";

GRANT ALL ON TABLE public."VSubcases" TO studget;
