CREATE OR REPLACE VIEW public."VCategories"
 AS
 SELECT DISTINCT "Category"."IdCategory",
    "Category"."CategoryName",
    "SalaryCustomers"."IdCustomer",
    "SalaryCustomers"."IdSalaryType",
	"Category"."Enabled"
   FROM "SalaryCustomers"
     LEFT JOIN "Category" ON "Category"."IdCategory" = "SalaryCustomers"."IdCategory" AND "Category"."IdSalaryType" = "SalaryCustomers"."IdSalaryType"
  ORDER BY "Category"."IdCategory";
