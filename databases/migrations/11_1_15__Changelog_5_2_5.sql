INSERT INTO "Versions" ("IdVersion","Date") values('5.2.5','2023-06-17');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (185,'Special characters “/ * ? [ ] : |” will no longer be accepted as characters while specifying the case’s name.','5.2.5',2);

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (186,'Certain characters will now appear correctly in the export file.','5.2.5',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (187,'While selecting a case, the case export buttons now display the correct text.','5.2.5',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (188,'The username in the export file’s header is now shown above the table of sums.','5.2.5',5);
