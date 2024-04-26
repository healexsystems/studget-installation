CREATE TABLE "public"."CostCalculationsComments" (
  "IdComment" serial8,
  "IdCostCalculation" int4 NOT NULL,
  "CreatedBy" character varying NOT NULL,
  "CreatedDate" timestamp NOT NULL,
  "Comment" varchar(2000) NOT NULL,
  "PreviousComment" int4,
  PRIMARY KEY ("IdComment"),
  CONSTRAINT "FK_ConstCalculationReview_IdCostCalculation" FOREIGN KEY ("IdCostCalculation") REFERENCES "public"."Cases" ("IdCase") ON DELETE CASCADE,
  CONSTRAINT "FK_ConstCalculationReview_UserName" FOREIGN KEY ("CreatedBy") REFERENCES "public"."Users" ("UserName") ON DELETE CASCADE,
  CONSTRAINT "FK_ConstCalculationReview_PreviousComment" FOREIGN KEY ("PreviousComment") REFERENCES "public"."CostCalculationsComments" ("IdComment") ON DELETE CASCADE
);