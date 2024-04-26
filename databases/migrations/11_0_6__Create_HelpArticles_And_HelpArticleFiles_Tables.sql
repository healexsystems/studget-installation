CREATE TABLE "public"."HelpArticles" (
  "IdArticle" serial,
  "ArticleName" varchar(40) NOT NULL,
  "ArticleDescription" varchar(1000) NOT NULL,
  "ArticleDate" timestamp NOT NULL,
  "Enabled" bool NOT NULL,
  PRIMARY KEY ("IdArticle")
)
;

CREATE TABLE "public"."HelpArticleFiles" (
  "IdFile" serial,
  "FilePath" character varying NOT NULL,
  "IdArticle" int NOT NULL,
  "IdCustomer" int NOT NULL,
  "Enabled" bool NOT NULL,
  PRIMARY KEY ("IdFile"),
  CONSTRAINT "FK_IdArticle" FOREIGN KEY ("IdArticle") REFERENCES "public"."HelpArticles" ("IdArticle") ON DELETE CASCADE,
  CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES "public"."Customers" ("IdCustomer") ON DELETE CASCADE
)
;

GRANT ALL ON TABLE public."HelpArticles" TO studget;
GRANT ALL ON TABLE public."HelpArticleFiles" TO studget;