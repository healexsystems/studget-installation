DO $$
DECLARE
	rec record;
BEGIN
	FOR rec IN SELECT * FROM "Files" WHERE "Enabled" = false LOOP
		UPDATE "Subcases" SET "Index" = -1 WHERE "IdSubcase" = rec."IdFile";
	END LOOP;
END $$;

DO $$
DECLARE
   rec record;
   lastCase int;
   currentCase int;
   indexvalue int;
BEGIN
   FOR rec IN SELECT * FROM "Subcases" WHERE "Index" <> -1 ORDER BY "IdCase", "IdSubcase" LOOP
   	if lastCase is null then
		indexvalue = 0;
	end if;
	
	currentCase = rec."IdCase";
	if lastCase <> currentCase then
		indexvalue = 0;
	end if;
	
	EXECUTE 'UPDATE "Subcases" SET "Index" = ' || indexvalue || ' WHERE "IdCase" = ' || rec."IdCase" || ' AND "IdSubcase" = ' || rec."IdSubcase" ;
	
	indexvalue = indexvalue + 1;
	lastCase = rec."IdCase";
   END LOOP;
END $$;
