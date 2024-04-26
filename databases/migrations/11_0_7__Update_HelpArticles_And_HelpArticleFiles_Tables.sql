ALTER TABLE "HelpArticles"
    ADD COLUMN "IdCustomer" int NOT NULL,
    ADD CONSTRAINT "FK_IdCustomer_HelpArticle" FOREIGN KEY ("IdCustomer") REFERENCES "Customers" ("IdCustomer") ON DELETE CASCADE;
     

ALTER TABLE "HelpArticleFiles" 
    DROP COLUMN "IdCustomer";