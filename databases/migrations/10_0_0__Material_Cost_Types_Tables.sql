CREATE TABLE "public"."MaterialCostTypes" (
  "IdMaterialCostType" serial,
  "CostTypeName" character varying NOT NULL,
  "IdCustomer" int NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "_copy_1" PRIMARY KEY ("IdMaterialCostType"),
  CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES "public"."Customers"  ON DELETE CASCADE
);

GRANT ALL ON TABLE public."MaterialCostTypes" TO studget;

CREATE TABLE "public"."MaterialCostCategories" (
  "IdMaterialCostCategory" serial,
  "CategoryName" character varying NOT NULL,
  "IdMaterialCostType" int NOT NULL,
  "Enabled" bool NOT NULL,
  PRIMARY KEY ("IdMaterialCostCategory"),
  CONSTRAINT "FK_IdMaterialCostTypeCategories" FOREIGN KEY ("IdMaterialCostType") REFERENCES "public"."MaterialCostTypes"  ON DELETE CASCADE
);

GRANT ALL ON TABLE public."MaterialCostCategories" TO studget;

CREATE TABLE "public"."MaterialCostClasses" (
  "IdMaterialCostClass" serial,
  "ClassName" character varying NOT NULL,
  "IdMaterialCostType" int NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "_copy_2" PRIMARY KEY ("IdMaterialCostClass"),
  CONSTRAINT "FK_IdMaterialCostTypeClasses" FOREIGN KEY ("IdMaterialCostType") REFERENCES "public"."MaterialCostTypes"  ON DELETE CASCADE
);

GRANT ALL ON TABLE public."MaterialCostClasses" TO studget;

CREATE TABLE "public"."MaterialCostValues" (
  "IdMaterialCostCategory" int NOT NULL,
  "IdMaterialCostClass" int NOT NULL,
  "Value" numeric(9,2) NOT NULL,
  "Enabled" bool NOT NULL,
  CONSTRAINT "_copy_3" PRIMARY KEY ("IdMaterialCostCategory", "IdMaterialCostClass"),
  CONSTRAINT "FK_IdCategory" FOREIGN KEY ("IdMaterialCostCategory") REFERENCES "public"."MaterialCostCategories" ,
  CONSTRAINT "FK_IdClass" FOREIGN KEY ("IdMaterialCostClass") REFERENCES "public"."MaterialCostClasses" 
);

GRANT ALL ON TABLE public."MaterialCostValues" TO studget;
