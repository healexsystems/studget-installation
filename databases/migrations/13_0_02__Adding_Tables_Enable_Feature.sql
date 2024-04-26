CREATE TABLE "public"."Features" (
  "IdFeature" serial4,
  "FeatureDescription" character varying NOT NULL,
  "Enabled" bool NOT NULL,
  PRIMARY KEY ("IdFeature")
);

CREATE TABLE "public"."CustomersFeatures" (
  "IdCustomer" int4 NOT NULL,
  "IdFeature" int4 NOT NULL,
  "Enabled" bool NOT NULL,
  PRIMARY KEY ("IdCustomer", "IdFeature"),
  CONSTRAINT "FK_CustomerFeatures_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES "public"."Customers" ("IdCustomer") ON DELETE CASCADE,
  CONSTRAINT "FK_CustomerFeatures_IdFeature" FOREIGN KEY ("IdFeature") REFERENCES "public"."Features" ("IdFeature") ON DELETE CASCADE
);
