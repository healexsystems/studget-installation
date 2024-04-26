CREATE TABLE "public"."PersonalSalaryTypes" (
  "IdPersonalSalaryType" serial,
  "SalaryTypeName" character varying NOT NULL,
  "IdCustomer" int NOT NULL,
  "YearlyWorkHours" float4 NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "PersonalSalaryTypes_pkey" PRIMARY KEY ("IdPersonalSalaryType"),
  CONSTRAINT "FK_IdCustomerPersonalSalaryTypes" FOREIGN KEY ("IdCustomer") REFERENCES "public"."Customers" ("IdCustomer") ON DELETE CASCADE
);

GRANT ALL ON TABLE public."PersonalSalaryTypes" TO studget;

CREATE TABLE "public"."PersonalCategories" (
  "IdPersonalCategory" serial,
  "IdPersonalSalaryType" int NOT NULL,
  "CategoryName" character varying NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "PersonalCategories_pkey" PRIMARY KEY ("IdPersonalCategory"),
  CONSTRAINT "FK_IdPersonalSalaryTypeCategories" FOREIGN KEY ("IdPersonalSalaryType") REFERENCES "public"."PersonalSalaryTypes" ("IdPersonalSalaryType")
);

GRANT ALL ON TABLE public."PersonalCategories" TO studget;

CREATE TABLE "public"."PersonalSeniorities" (
  "IdPersonalSeniority" serial,
  "IdPersonalSalaryType" int NOT NULL,
  "SeniorityName" character varying NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "PersonalSeniorities_pkey" PRIMARY KEY ("IdPersonalSeniority"),
  CONSTRAINT "FK_IdPersonalSalaryTypeSeniorities" FOREIGN KEY ("IdPersonalSalaryType") REFERENCES "public"."PersonalSalaryTypes" ("IdPersonalSalaryType")
);

GRANT ALL ON TABLE public."PersonalSeniorities" TO studget;

CREATE TABLE "public"."PersonalSalaries" (
  "IdPersonalSeniority" int  NOT NULL,
  "IdPersonalCategory" int NOT NULL,
  "Salary" numeric(9,2) NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "PersonalSalaries_pkey" PRIMARY KEY ("IdPersonalSeniority", "IdPersonalCategory"),
  CONSTRAINT "FK_IdPersonalSalaryTypeSenioritiesSalaries" FOREIGN KEY ("IdPersonalSeniority") REFERENCES "public"."PersonalSeniorities" ("IdPersonalSeniority") ON DELETE CASCADE,
  CONSTRAINT "FK_IdPersonalSalaryTypeCategoriesSalaries" FOREIGN KEY ("IdPersonalCategory") REFERENCES "public"."PersonalCategories" ("IdPersonalCategory") ON DELETE CASCADE
);

GRANT ALL ON TABLE public."PersonalSalaries" TO studget;


