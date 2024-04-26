--Update function
CREATE OR REPLACE FUNCTION public.add_material_cost_class_after_material_cost_type()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
	
	--Create Average MaterialCostClass
	INSERT INTO public."MaterialCostClasses"(
	"ClassName", "IdMaterialCostType", "Default", "Enabled")
	VALUES ('Average', new."IdMaterialCostType", True, True);
	
	return new;
	
	END;
$BODY$;

--Create function and trigger to create default seniorities when new salary type is created
CREATE OR REPLACE FUNCTION public.add_personal_seniorities_after_personal_salary_types()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
	
	--Create First and Second Average 
	INSERT INTO public."PersonalSeniorities"(
	"SeniorityName", "IdPersonalSalaryType", "Default", "Enabled")
	VALUES ('First Average', new."IdPersonalSalaryType", True, True);

	INSERT INTO public."PersonalSeniorities"(
	"SeniorityName", "IdPersonalSalaryType", "Default", "Enabled")
	VALUES ('Second Average', new."IdPersonalSalaryType", True, True);
	
	return new;
	
	END;
$BODY$;

CREATE TRIGGER tr_af_personalsalarytypes_insert AFTER INSERT ON "PersonalSalaryTypes"
    FOR EACH ROW EXECUTE PROCEDURE public.add_personal_seniorities_after_personal_salary_types();

--Create material values when new caegory is created with each seniority
CREATE OR REPLACE FUNCTION public.add_value_after_personal_category()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
		r "PersonalSeniorities"%ROWTYPE;
	BEGIN
	--Create values
	FOR r IN SELECT "IdPersonalSeniority" FROM "PersonalSeniorities" WHERE "PersonalSeniorities"."IdPersonalSalaryType" = NEW."IdPersonalSalaryType"
	
    	LOOP
			INSERT INTO "PersonalSalaries" ("IdPersonalCategory", "IdPersonalSeniority", "Salary", "Enabled") 
			                           VALUES (NEW."IdPersonalCategory", r."IdPersonalSeniority", 0, True)
									   ON CONFLICT ("IdPersonalCategory", "IdPersonalSeniority") DO NOTHING;
    	END LOOP;
		
		return new;
	END;
$BODY$;

CREATE TRIGGER tr_af_personalcategories_insert AFTER INSERT ON "PersonalCategories"
    FOR EACH ROW EXECUTE PROCEDURE public.add_value_after_personal_category();

--Create material values when new seniority is created with each category
CREATE OR REPLACE FUNCTION public.add_value_after_personal_seniority()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
		r "PersonalCategories"%ROWTYPE;
	BEGIN
	--Create values
	FOR r IN SELECT "IdPersonalCategory" FROM "PersonalCategories" WHERE "PersonalCategories"."IdPersonalSalaryType" = NEW."IdPersonalSalaryType"
	
    	LOOP
			INSERT INTO "PersonalSalaries" ("IdPersonalCategory", "IdPersonalSeniority", "Salary", "Enabled") 
			                           VALUES (r."IdPersonalCategory", NEW."IdPersonalSeniority", 0, True)
									   ON CONFLICT ("IdPersonalCategory", "IdPersonalSeniority") DO NOTHING;
    	END LOOP;
		
		return new;
	END;
$BODY$;

CREATE TRIGGER tr_af_personalseniorities_insert AFTER INSERT ON "PersonalSeniorities"
    FOR EACH ROW EXECUTE PROCEDURE public.add_value_after_personal_seniority();
