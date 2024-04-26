CREATE OR REPLACE FUNCTION public.add_material_cost_class_after_material_cost_type()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
	
	--Create Average MaterialCostClass
	INSERT INTO public."MaterialCostClasses"(
	"ClassName", "IdMaterialCostType", "Enabled")
	VALUES ('Average', new."IdMaterialCostType", True);
	
	return new;
	
	END;
$BODY$;

CREATE TRIGGER tr_af_materialcosttypes_insert AFTER INSERT ON "MaterialCostTypes"
    FOR EACH ROW EXECUTE PROCEDURE public.add_material_cost_class_after_material_cost_type();

CREATE OR REPLACE FUNCTION public.add_value_after_material_cost_category()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
		r "MaterialCostClasses"%ROWTYPE;
	BEGIN
	--Create values
	FOR r IN SELECT "IdMaterialCostClass" FROM "MaterialCostClasses" WHERE "MaterialCostClasses"."IdMaterialCostType" = NEW."IdMaterialCostType"
	
    	LOOP
			INSERT INTO "MaterialCostValues" ("IdMaterialCostCategory", "IdMaterialCostClass", "Value", "Enabled") 
			                           VALUES (NEW."IdMaterialCostCategory", r."IdMaterialCostClass", 0, True);
    	END LOOP;
		
		return new;
	END;
$BODY$;

CREATE TRIGGER tr_af_materialcostcategory_insert AFTER INSERT ON "MaterialCostCategories"
    FOR EACH ROW EXECUTE PROCEDURE public.add_value_after_material_cost_category()
