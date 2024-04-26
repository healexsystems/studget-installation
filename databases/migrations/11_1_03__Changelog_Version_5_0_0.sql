INSERT INTO "Versions" ("IdVersion","Date") values('5.0.0','2023-04-28');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (146,'The case identifier is now the case ID, which allows the creation of cases with the same name.','5.0.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (147,'The case ID is now shown in the basic information of the case on the right side.','5.0.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (148,'The basic information fields on the right side of the case are now left aligned.','5.0.0',2);
