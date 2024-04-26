-- FUNCTION: public.function_default_salaries(integer)

-- DROP FUNCTION public.function_default_salaries(integer);

CREATE OR REPLACE FUNCTION public.function_default_salaries(
	pidcustomer integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
		category "Category"%ROWTYPE;
		seniority "Seniority"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR category IN SELECT "IdCategory", "IdSalaryType"  FROM "Category" WHERE "Default" = true 
    	LOOP
			FOR seniority IN SELECT "IdSeniority" FROM "Seniority" WHERE "Default" = true
				LOOP
            		INSERT INTO "SalaryCustomers" ("IdCustomer", "IdCategory", "IdSalaryType", "IdSeniority", "Salary") VALUES ( pIdCustomer, category."IdCategory", category."IdSalaryType", seniority."IdSeniority", 0.00);
				END LOOP;
    	END LOOP;
	END;
$BODY$;

ALTER FUNCTION public.function_default_salaries(integer)
    OWNER TO studget;

GRANT EXECUTE ON FUNCTION public.function_default_salaries(integer) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.function_default_salaries(integer) TO studget;

COMMENT ON FUNCTION public.function_default_salaries(integer)
    IS 'This functions creates the default salary structure';
