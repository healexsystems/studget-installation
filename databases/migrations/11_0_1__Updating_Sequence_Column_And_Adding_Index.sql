UPDATE "Status" SET "Sequence" = 2 WHERE "IdStatus" = 3; /*Edition*/
UPDATE "Status" SET "Sequence" = 3 WHERE "IdStatus" = 4; /*Submitted*/
UPDATE "Status" SET "Sequence" = 4 WHERE "IdStatus" = 5; /*Accepted*/
UPDATE "Status" SET "Sequence" = 5 WHERE "IdStatus" = 6; /*Returned*/
UPDATE "Status" SET "Sequence" = 6 WHERE "IdStatus" = 2; /*Closed*/

CREATE INDEX "StatusSequence" ON "Status"("Sequence");