CREATE OR REPLACE VIEW public."VCostCalculationsDistributionList" AS
 SELECT dl."IdCostCalculation", dl."UserName", u.mail AS "Email"
   FROM "CostCalculationsDistributionList" dl
     JOIN "Users" u ON u."UserName" = dl."UserName"
     ORDER BY u."UserName";