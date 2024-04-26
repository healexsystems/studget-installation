CREATE TABLE "public"."CostCalculationsDistributionList" (
  "IdCostCalculation" int4 NOT NULL,
  "UserName" character varying NOT NULL,
  PRIMARY KEY ("IdCostCalculation", "UserName"),
  CONSTRAINT "FK_Cases_CostCalculationDistributionList_IdCostCalculation" FOREIGN KEY ("IdCostCalculation") REFERENCES "public"."Cases" ("IdCase") ON DELETE CASCADE,
  CONSTRAINT "FK_Cases_CostCalculationDistributionList_UserName" FOREIGN KEY ("UserName") REFERENCES "public"."Users" ("UserName") ON DELETE CASCADE
);