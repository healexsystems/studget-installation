INSERT INTO "Versions" ("IdVersion","Date") values('4.5.0','2023-04-21');

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (136,'An option to duplicate cost calculations was added.','4.5.0',1);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (137,'The “Help” option was added in the user menu, which allows the creation/deletion of articles that may include files (Files need to be uploaded from the local machine).','4.5.0',1);

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (138,'When a case ownership is changed, the basic information “owner” of that case changes, but the “created by” section remains the same.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (139,'The totals and their values are highlighted in the export (pdf/excel) files in partial calculations.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (140,'Moved the calculation mode drop down list from the sub cases to the master forms section. Can be changed while in edition mode by the Customer Admin.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (141,'In the filtering option in the Cost Calculation section, the Status dropdown list was re-sorted.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (142,'The duration option during the creation of a new case can not be negative.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (143,'Closed cost calculations can only be deleted by Customer Admins.','4.5.0',2);
INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (144,'The hourly rate can also be edited in the Resource Pool belonging to a Master Form.','4.5.0',2);

INSERT INTO "VersionChangeLog" ("IdChangeLog","Description","IdVersion","IdChangeCategory") values (145,'Removed the sub cases and signature fields in external pdf/excel export.','4.5.0',4);