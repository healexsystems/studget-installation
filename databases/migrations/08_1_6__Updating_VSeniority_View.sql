CREATE OR REPLACE VIEW public."VSeniority"
 AS
 SELECT "Seniority"."IdSeniority",
    "Seniority"."Description",
    "SalaryCustomers"."IdCustomer",
    "SalaryCustomers"."IdSalaryType",
    "SalaryCustomers"."IdCategory",
    "Seniority"."Average",
	"Seniority"."Enabled"
   FROM "SalaryCustomers"
     LEFT JOIN "Seniority" ON "Seniority"."IdSeniority" = "SalaryCustomers"."IdSeniority"
  ORDER BY "Seniority"."IdSeniority";