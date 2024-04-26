INSERT INTO "Versions" ("IdVersion","Date") values('5.2.7','2023-06-23');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (192,'The user can now login correctly if that same user has an active session on-going.','5.2.7',5);
