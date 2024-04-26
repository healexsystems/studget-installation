INSERT INTO "Versions" ("IdVersion","Date") values('6.0.3','2023-09-23');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (212,'Fixed issues with decimals in imports from Excel files.','6.0.3',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (213,'Fixed issue that blocked password reset for users with more than one account.','6.0.3',5);
