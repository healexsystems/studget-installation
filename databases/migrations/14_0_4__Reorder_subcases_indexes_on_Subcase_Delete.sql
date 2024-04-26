CREATE OR REPLACE FUNCTION function_reorder_indexes_of_case_subcases()
RETURNS TRIGGER AS $$
DECLARE
	rec record;
	currentIndex int;
	elementCounter int;
	BEGIN
		elementCounter = 0;
	
		FOR rec IN SELECT * FROM "Subcases" WHERE "IdCase" = OLD."IdCase" AND "Index" <> -1 ORDER BY "Index" LOOP
			currentIndex = rec."Index";
		
			IF currentIndex <> elementCounter THEN
				UPDATE "Subcases" SET "Index" = elementCounter WHERE "IdSubcase" = rec."IdSubcase";
			END IF;
		
			elementCounter = elementCounter + 1;
	END LOOP;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_subcase_index_after_delete_subcase
AFTER DELETE ON "Subcases"
FOR EACH ROW
EXECUTE FUNCTION function_reorder_indexes_of_case_subcases();
