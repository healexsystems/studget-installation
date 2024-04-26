INSERT INTO "Versions" ("IdVersion","Date") values('3.0.0','2021-07-29');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (125,'Excel format download of administrative costs.','3.0.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (126,'Excel format upload of administrative costs.','3.0.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (127,'Creation of salary types.','3.0.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (128,'Deletion of salary types.','3.0.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (129,'Maximum number of users can now be set for each individual customer.','3.0.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (130,'Edition of administrative costs is now able to modify columns and rows.','3.0.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (131,'User creation now takes consideration of maximum number of users by customer.','3.0.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (132,'Customers’ screen now shows the maximum number of users and current number of users.','3.0.0',2);

INSERT INTO "Versions" ("IdVersion","Date") values('3.0.1','2021-09-07');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (133,'Deletion of cost items now correctly sets the summations values.','3.0.1',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (134,'Screen now shows error when the maximum number of users is past the limit.','3.0.1',5);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (135,'Master forms no longer appear with an empty resource pool.','3.0.1',5);

