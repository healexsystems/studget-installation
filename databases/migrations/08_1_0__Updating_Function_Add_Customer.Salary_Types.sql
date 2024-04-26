--First Delete the existing function and trigger
DROP TRIGGER IF EXISTS "TFillCustomerSalaryTypes"
ON "Customers" CASCADE ;

DROP FUNCTION IF EXISTS "function_add_customer_salary_types";

--Recreate it with all the values updated
CREATE FUNCTION public.function_add_customer_salary_types()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
		salaryTypes "SalaryTypes"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR salaryTypes IN select "IdSalaryType" from "SalaryTypes"
    	LOOP
			insert into "CustomersSalaryTypes" ("IdCustomer","IdSalaryType", "YearlyWorkHours", "Enabled") 
			                            values (new."IdCustomer", salaryTypes."IdSalaryType", 1540.00, true);
    	END LOOP;
		
		return new;
	END;
$BODY$;

ALTER FUNCTION public.function_add_customer_salary_types()
    OWNER TO studget;


CREATE TRIGGER "TFillCustomerSalaryTypes"
    AFTER INSERT
    ON public."Customers"
    FOR EACH ROW
    EXECUTE PROCEDURE public.function_add_customer_salary_types();