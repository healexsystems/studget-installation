INSERT INTO "Versions" ("IdVersion","Date") values('6.0.2','2023-09-02');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (210,'Fixed issues with some specific user configurations from ClinicalSite','6.0.2',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (211,'Decimal places are no longer ignored when CSV-files are imported as personal cost catalogs.','6.0.2',5);
