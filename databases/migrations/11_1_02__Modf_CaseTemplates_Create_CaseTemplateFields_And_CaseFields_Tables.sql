ALTER TABLE "CasesTemplates"
ADD COLUMN "StudyType" int,
ADD COLUMN "CaseDefaultName" character varying,
ADD COLUMN "Duration" int;

UPDATE "CasesTemplates" 
  SET "Duration" = 0;


CREATE TABLE "public"."CaseTemplateFields" (
  "IdCaseTemplateField" bigserial,
  "FieldTitle" varchar(150) NOT NULL,
  "FieldValue" varchar(150),
  "Mandatory" bool NOT NULL,
  "Sequence" smallint NOT NULL,
  "IdCaseTemplate" int NOT NULL,
  PRIMARY KEY ("IdCaseTemplateField"),
  CONSTRAINT "FK_IdCaseTemplate_CaseTemplateField" FOREIGN KEY ("IdCaseTemplate") REFERENCES "public"."CasesTemplates" ("IdCaseTemplate") ON DELETE CASCADE
)
;

CREATE TABLE "public"."CaseFields" (
  "IdCaseField" bigserial,
  "FieldTitle" varchar(150) NOT NULL,
  "FieldValue" varchar(150),
  "Mandatory" bool NOT NULL,
  "Sequence" smallint NOT NULL,
  "IdCase" int NOT NULL,
  PRIMARY KEY ("IdCaseField"),
  CONSTRAINT "FK_IdCases_CaseField" FOREIGN KEY ("IdCase") REFERENCES "public"."Cases" ("IdCase") ON DELETE CASCADE
)
;


ALTER TABLE "CasesTemplates"
  ALTER COLUMN "Duration" SET NOT NULL;