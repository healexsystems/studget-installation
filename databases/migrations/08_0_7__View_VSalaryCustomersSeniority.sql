create view "VSalaryCustomerSeniority" as
select DISTINCT 
"SalaryCustomers"."IdCustomer",
"SalaryCustomers"."IdSalaryType",
"SalaryCustomers"."IdSeniority",
"Seniority"."Description"
from "SalaryCustomers"
inner join "Seniority" on "Seniority"."IdSeniority" = "SalaryCustomers"."IdSeniority";

GRANT ALL ON TABLE public."VSalaryCustomerSeniority" TO studget;