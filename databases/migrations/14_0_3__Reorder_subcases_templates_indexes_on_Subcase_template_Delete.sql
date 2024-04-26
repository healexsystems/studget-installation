CREATE OR REPLACE FUNCTION function_reorder_indexes_of_case_template_subcases()
RETURNS TRIGGER AS $$
DECLARE
	rec record;
	currentIndex int;
	elementCounter int;
	BEGIN
		elementCounter = 0;
	
		FOR rec IN SELECT * FROM "CaseTemplatesMasterForms" WHERE "IdCaseTemplate" = OLD."IdCaseTemplate" ORDER BY "Index" LOOP
			currentIndex = rec."Index";
		
			IF currentIndex <> elementCounter THEN
				UPDATE "CaseTemplatesMasterForms" SET "Index" = elementCounter WHERE "IdTemplateRow" = rec."IdTemplateRow";
			END IF;
		
			elementCounter = elementCounter + 1;
	END LOOP;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_subcase_template_index_after_delete_subcase_template
AFTER DELETE ON "CaseTemplatesMasterForms"
FOR EACH ROW
EXECUTE FUNCTION function_reorder_indexes_of_case_template_subcases();
