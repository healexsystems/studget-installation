ALTER TABLE "LogIns" DROP CONSTRAINT "FK_IdUser";

ALTER TABLE "LogIns" 
ADD CONSTRAINT "FK_IdUser" FOREIGN KEY ("UserId")
    REFERENCES public."Users" ("UserName") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;