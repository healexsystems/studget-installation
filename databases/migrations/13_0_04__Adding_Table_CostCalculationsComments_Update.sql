ALTER TABLE "public"."CostCalculationsComments"
ADD COLUMN "Resolved" boolean NOT NULL DEFAULT false;

-- Create a CHECK constraint to enforce the condition
ALTER TABLE public."CostCalculationsComments"
ADD CONSTRAINT "CK_CostCalculationsComments_Resolved"
CHECK (("Resolved" = true AND "PreviousComment" IS NULL) OR "Resolved" = false);
