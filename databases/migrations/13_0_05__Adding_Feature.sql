INSERT INTO "public"."Features" ("FeatureDescription", "Enabled")
VALUES ('Reviewers Feedback', TRUE);

-- Insert rows into CustomersFeatures for all customers and all features
INSERT INTO "public"."CustomersFeatures" ("IdCustomer", "IdFeature", "Enabled")
SELECT c."IdCustomer", f."IdFeature", FALSE
FROM "public"."Customers" c
CROSS JOIN "public"."Features" f;
