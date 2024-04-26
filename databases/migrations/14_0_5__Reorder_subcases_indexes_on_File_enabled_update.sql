CREATE OR REPLACE FUNCTION function_reorder_indexes_of_case_subcases_on_file_update()
RETURNS TRIGGER AS $$
DECLARE
	rec record;
	currentIndex int;
	elementCounter int;
	
	caseRecord record;
	BEGIN
		--Update File's associated Subcase Index
		IF NEW."Enabled" <> OLD."Enabled" THEN
			IF NEW."Enabled" = false THEN
				UPDATE "Subcases" SET "Index" = -1 WHERE NEW."IdFile" = "Subcases"."IdSubcase";
			END IF;
			
			--Rearrange the subcases Index ignoring Indexes with -1 values
			SELECT * INTO caseRecord FROM "Subcases" WHERE "IdSubcase" = NEW."IdFile";
			
			elementCounter = 0;
			FOR rec IN SELECT * FROM "Subcases" WHERE "IdCase" = caseRecord."IdCase" AND "Index" <> -1 ORDER BY "Index" LOOP
				currentIndex = rec."Index";
		
				IF currentIndex <> elementCounter THEN
					UPDATE "Subcases" SET "Index" = elementCounter WHERE "IdSubcase" = rec."IdSubcase";
				END IF;
		
				elementCounter = elementCounter + 1;
			END LOOP;
		END IF;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_subcase_index_after_update_files
AFTER UPDATE ON "Files"
FOR EACH ROW
EXECUTE FUNCTION function_reorder_indexes_of_case_subcases_on_file_update();
