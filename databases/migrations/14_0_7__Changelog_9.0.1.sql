INSERT INTO "Versions" ("IdVersion","Date") values('9.0.1','2024-02-02');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (274,'Fixed format errors in export.','9.0.1', 5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (275,'External exports with variable costs now use external rate.','9.0.1', 5);
