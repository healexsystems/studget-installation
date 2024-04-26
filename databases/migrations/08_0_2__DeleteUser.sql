ALTER TABLE "ChangeLog" ALTER COLUMN "UserName" DROP NOT NULL;
ALTER TABLE "Files" ALTER COLUMN "CreatedBy" DROP NOT NULL;
ALTER TABLE "Cases" ALTER COLUMN "Owner" DROP NOT NULL;
ALTER TABLE "Subcases" ALTER COLUMN "Owner" DROP NOT NULL;

ALTER TABLE "Subcases" DROP CONSTRAINT "FK_IdCase";

ALTER TABLE "Subcases"
ADD CONSTRAINT "FK_IdCase" FOREIGN KEY ("IdCase")
        REFERENCES public."Files" ("IdFile") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;
		
ALTER TABLE "ChangeLog" DROP CONSTRAINT "FK_IdFile";

ALTER TABLE "ChangeLog"
ADD CONSTRAINT "FK_IdFile" FOREIGN KEY ("IdFile")
        REFERENCES public."Files" ("IdFile") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;
		
ALTER TABLE "ParametersCases" DROP CONSTRAINT "FK_IdCases";

ALTER TABLE "ParametersCases"
ADD CONSTRAINT "FK_IdCases" FOREIGN KEY ("IdCase")
        REFERENCES public."Cases" ("IdCase") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;
		

ALTER TABLE "CasesGeneralSummations" DROP CONSTRAINT "IdCase";

ALTER TABLE "CasesGeneralSummations"
ADD CONSTRAINT "IdCase" FOREIGN KEY ("IdCases")
        REFERENCES public."Cases" ("IdCase") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;
		
ALTER TABLE "ParametersSubcases" DROP CONSTRAINT "FK_IdSubcase";

ALTER TABLE "ParametersSubcases"
ADD CONSTRAINT "FK_IdSubcase" FOREIGN KEY ("IdSubcase")
        REFERENCES public."Subcases" ("IdSubcase") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;
