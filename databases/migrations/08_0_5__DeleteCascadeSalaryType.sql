ALTER TABLE "CustomersSalaryTypes" DROP CONSTRAINT "FK_IdSalaryType";

ALTER TABLE "CustomersSalaryTypes"
ADD CONSTRAINT "FK_IdSalaryType" FOREIGN KEY ("IdSalaryType")
        REFERENCES public."SalaryTypes" ("IdSalaryType") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;

ALTER TABLE "Category" DROP CONSTRAINT "IdSalaryType";

ALTER TABLE "Category"
ADD CONSTRAINT "FK_CategoryIdSalaryType" FOREIGN KEY ("IdSalaryType")
        REFERENCES public."SalaryTypes" ("IdSalaryType") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;

ALTER TABLE "SalaryCustomers" DROP CONSTRAINT "FK_CategorySalary";
ALTER TABLE "SalaryCustomers" DROP CONSTRAINT "FK_SalaryTime";


ALTER TABLE "SalaryCustomers"
ADD  CONSTRAINT "FK_CategorySalary" FOREIGN KEY ("IdCategory", "IdSalaryType")
        REFERENCES public."Category" ("IdCategory", "IdSalaryType") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;

ALTER TABLE "SalaryCustomers"
ADD  CONSTRAINT "FK_SalarySeniority" FOREIGN KEY ("IdSeniority")
        REFERENCES public."Seniority" ("IdSeniority") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE;

