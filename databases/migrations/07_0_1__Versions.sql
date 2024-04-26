CREATE TABLE "Versions" (
"IdVersion" character varying NOT NULL,
"Date" date NOT NULL,
PRIMARY KEY ("IdVersion") 
)
WITHOUT OIDS;

CREATE TABLE "ChangeCategory" (
"IdChangeCategory" serial2 NOT NULL,
"CategoryName" character varying NOT NULL,
PRIMARY KEY ("IdChangeCategory") 
)
WITHOUT OIDS;

CREATE TABLE "VersionChangeLog" (
"IdChangeLog" serial8 NOT NULL,
"Description" character varying NOT NULL,
"IdVersion" character varying NOT NULL,
"IdChangeCategory" int2 NOT NULL,
PRIMARY KEY ("IdChangeLog") ,
CONSTRAINT "FK_IdVersion" FOREIGN KEY ("IdVersion") REFERENCES "Versions" ("IdVersion"),
CONSTRAINT "FK_IdCategory" FOREIGN KEY ("IdChangeCategory") REFERENCES "ChangeCategory" ("IdChangeCategory")
)
WITHOUT OIDS;

INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (1,'Added');
INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (2,'Chenged');
INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (3,'Deprecated');
INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (4,'Removed');
INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (5,'Fixed');
INSERT INTO "ChangeCategory" ("IdChangeCategory","CategoryName") VALUES (6,'Security');