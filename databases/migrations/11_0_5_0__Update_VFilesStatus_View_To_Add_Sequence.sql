-- View: public.VFilesStatus

-- DROP VIEW public."VFilesStatus";

CREATE OR REPLACE VIEW public."VFilesStatus"
 AS
 SELECT "FilesObjects"."IdFileObject",
    "Status"."IdStatus",
    "Status"."StatusName",
	"Status"."Sequence"
   FROM "FileObjectsStatus"
     LEFT JOIN "FilesObjects" ON "FilesObjects"."IdFileObject" = "FileObjectsStatus"."IdFileObject"
     LEFT JOIN "Status" ON "Status"."IdStatus" = "FileObjectsStatus"."IdStatus"
  ORDER BY "Status"."Sequence";