
/*
Default datbase data
*/

INSERT INTO public."Action" ("IdAction","ActionName") VALUES (1,'Open');
INSERT INTO public."Action" ("IdAction","ActionName") VALUES (2,'Closed');
INSERT INTO public."Action" ("IdAction","ActionName") VALUES (3,'View');
INSERT INTO public."Action" ("IdAction","ActionName") VALUES (4,'Reopen');
INSERT INTO public."Action" ("IdAction","ActionName") VALUES (5,'Changed');


INSERT INTO public."Customers" ("IdCustomer","NameCustomer","Enabled","Default","IdMasterForm","AverageCostReference","Surcharge")
VALUES (1, 'Admin', true, true, NULL, 0, 0.00);

/*
Tables Needed: 
1.-Customers
*/
INSERT INTO public."Organizational_Units" ("IdOrganizationalunit", "NameOrganizationalUnit", "IdCustomer","Enabled","Default") 
VALUES(1,'Admin', 1, true, true);

/*
Tables Needed: 
1.-Customers, 
*/
INSERT INTO public."Users" ("UserName", "Name", "Password", "mail","IsStudget","Enabled","PasswordChanged","MailVerified","IdCustomer","SMSAccount")
VALUES ('Admin', 'Admin', '2wK3bitj7LvO+8qloZO8Pw==', 'admin@healex.systems', TRUE, TRUE, TRUE, TRUE, 1, NULL);

INSERT INTO public."Users" ("UserName", "Name", "Password", "mail","IsStudget","Enabled","PasswordChanged","MailVerified","IdCustomer","SMSAccount")
VALUES ('MEXabat Admin','MEXabat Admin', '', 'xarm@abatgroup.de', TRUE, TRUE, FALSE, FALSE, 1, NULL);

/*
Tables Needed: 
1.-Status, 
*/
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (1, 'Open');
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (2, 'Closed');
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (3, 'Edition');
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (4, 'Submitted');
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (5, 'Accepted');
INSERT INTO public."Status" ("IdStatus","StatusName") VALUES (6, 'Returned');

INSERT INTO public."Files" ("IdFile", "IdOrganizationalUnit", "Name", "IdStatus", "CreatedBy", "LastModified", "CreatedDate", "File", "CurrentEditor", "Enabled") 
VALUES (1,1,'General',1 , 'Admin','2020-02-04 00:00:00', '2020-02-04 00:00:00','{
    "CostCategories": [
        {
            "Name": "Material Costs",
            "Items": [],
            "SystemBlocked": false,
            "Blocked": false,
            "Id": "311790331.18547916"
        },
        {
            "Name": "Investments",
            "Items": [],
            "SystemBlocked": false,
            "Blocked": false,
            "Id": "496403833.1042507"
        }
    ],
    "TimeCategories": [
        {
            "Name": "Basic Information",
            "Items": [],
            "SystemBlocked": false,
            "Blocked": false,
            "Id": "221517510.7078679"
        }
    ],
    "MainCategories": [
        {
            "Name": "Labor Costs",
            "Structures": [
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Start-Up Fee",
                    "Tasks": [],
                    "Id": "626803.8986102834",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                },
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Visits during Screening",
                    "Tasks": [],
                    "Id": "425257.17815136036",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                },
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Baseline Visit",
                    "Tasks": [],
                    "Id": "938313.9099041743",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                },
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Arm1",
                    "Tasks": [],
                    "Id": "2047.9893838611217",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                },
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Arm2",
                    "Tasks": [],
                    "Id": "237473.83351096997",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                },
                {
                    "Cost": 0,
                    "ExternalCost": 0,
                    "Name": "Close-Out",
                    "Tasks": [],
                    "Id": "281431.2190439961",
                    "Comment": "",
                    "_showDetails": true,
                    "SystemBlocked": false,
                    "Blocked": false
                }
            ],
            "Blocked": false,
            "SystemBlocked": false,
            "Id": "2693958310.7034679",
            "ExternalCost": 0
        }
    ],
    "ResourcePool": {
        "Resources": []
    },
    "metadata": {
        "version": "1.5"
    },
    "Summations": [],
    "StudyType": {
        "sumlageName": "",
        "idSurcharge": "-1"
    },
    "External": false,
    "GeneralModification": {
        "CostCategories": [],
        "TimeCategories": [],
        "MainCategories": [],
        "Summations": []
    }
}',NULL,TRUE);

/*
Tables Needed: 
1.-Files
*/
INSERT INTO public."MasterForms" ("IdMasterForm", "SummaryFile", "General", "Parent", "AllowPerPatients") VALUES (1,'[]', TRUE, NULL, TRUE);

UPDATE public."Customers" SET "IdMasterForm" = 1 WHERE "IdCustomer" = 1;

INSERT INTO public."FilesObjects" ("IdFileObject","ObjectName") VALUES (1,'Case');
INSERT INTO public."FilesObjects" ("IdFileObject","ObjectName") VALUES (2,'Subcase');
INSERT INTO public."FilesObjects" ("IdFileObject","ObjectName") VALUES (3,'Master Form');

INSERT INTO public."Roles" ("IdRole","NameRole") values (1, 'Administrator Healex');
INSERT INTO public."Roles" ("IdRole","NameRole") values (2, 'Administrator Customer');
INSERT INTO public."Roles" ("IdRole","NameRole") values (3, 'key User');
INSERT INTO public."Roles" ("IdRole","NameRole") values (4, 'User');
INSERT INTO public."Roles" ("IdRole","NameRole") values (5, 'Reviewer');

INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (1,'Customers');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (2,'Master Form');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (3,'Organizational Units');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (4,'Salaries');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (5,'Users');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (6,'Surcharges');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (7,'Conditions');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (8,'Case Templates');
INSERT INTO public."Screens" ("IdScreen", "ScreenName") VALUES (9,'General Summations');

/*
Tables Needed: 
1.-Roles, 
2.-Screens
*/
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (1,1);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (5,1);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (2,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (3,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (4,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (5,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (6,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (2,3);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (7,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (8,2);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (8,3);
INSERT INTO public."Roles_Screens" ("IdScreen","IdRole") VALUES (9,2);

INSERT INTO public."SalaryTypes" ("IdSalaryType","SalaryType") VALUES (4,'TV-Ä');
INSERT INTO public."SalaryTypes" ("IdSalaryType","SalaryType") VALUES (8,'Beamte');
INSERT INTO public."SalaryTypes" ("IdSalaryType","SalaryType") VALUES (12,'TV-L');
INSERT INTO public."SalaryTypes" ("IdSalaryType","SalaryType") VALUES (13,'Sonstige Personalien');

/*
Tables Needed: 
1.-"SalaryTypes
*/
INSERT INTO public."Category" VALUES (23, 4, 'Ä1');
INSERT INTO public."Category" VALUES (24, 4, 'Ä2');
INSERT INTO public."Category" VALUES (25, 4, 'Ä3');
INSERT INTO public."Category" VALUES (73, 8, 'Beamte A5');
INSERT INTO public."Category" VALUES (74, 8, 'Beamte A6');
INSERT INTO public."Category" VALUES (75, 8, 'Beamte A7');
INSERT INTO public."Category" VALUES (76, 8, 'Beamte A8');
INSERT INTO public."Category" VALUES (77, 8, 'Beamte A9');
INSERT INTO public."Category" VALUES (78, 8, 'Beamte A10');
INSERT INTO public."Category" VALUES (79, 8, 'Beamte A11');
INSERT INTO public."Category" VALUES (80, 8, 'Beamte A12');
INSERT INTO public."Category" VALUES (81, 8, 'Beamte A13');
INSERT INTO public."Category" VALUES (82, 8, 'Beamte A14');
INSERT INTO public."Category" VALUES (83, 8, 'Beamte A15');
INSERT INTO public."Category" VALUES (84, 8, 'Beamte A16');
INSERT INTO public."Category" VALUES (85, 8, 'Beamte B1');
INSERT INTO public."Category" VALUES (86, 8, 'Beamte B2');
INSERT INTO public."Category" VALUES (87, 8, 'Beamte B3');
INSERT INTO public."Category" VALUES (88, 8, 'Beamte B4');
INSERT INTO public."Category" VALUES (89, 8, 'Beamte B5');
INSERT INTO public."Category" VALUES (90, 8, 'Beamte B6');
INSERT INTO public."Category" VALUES (91, 8, 'Beamte B7');
INSERT INTO public."Category" VALUES (92, 8, 'Beamte B8');
INSERT INTO public."Category" VALUES (93, 8, 'Beamte B9');
INSERT INTO public."Category" VALUES (94, 8, 'Beamte B10');
INSERT INTO public."Category" VALUES (95, 8, 'Beamte B11');
INSERT INTO public."Category" VALUES (96, 8, 'Beamte C1');
INSERT INTO public."Category" VALUES (97, 8, 'Beamte C2');
INSERT INTO public."Category" VALUES (98, 8, 'Beamte C3');
INSERT INTO public."Category" VALUES (99, 8, 'Beamte C4');
INSERT INTO public."Category" VALUES (100, 8, 'Beamte W1');
INSERT INTO public."Category" VALUES (101, 8, 'Beamte W2');
INSERT INTO public."Category" VALUES (102, 8, 'Beamte W3');
INSERT INTO public."Category" VALUES (103, 4, 'Ä4');
INSERT INTO public."Category" VALUES (104, 12, 'E15Ü');
INSERT INTO public."Category" VALUES (105, 12, 'E15');
INSERT INTO public."Category" VALUES (106, 12, 'E14');
INSERT INTO public."Category" VALUES (107, 12, 'E13Ü');
INSERT INTO public."Category" VALUES (108, 12, 'E13');
INSERT INTO public."Category" VALUES (109, 12, 'E12');
INSERT INTO public."Category" VALUES (110, 12, 'E11');
INSERT INTO public."Category" VALUES (111, 12, 'E10');
INSERT INTO public."Category" VALUES (112, 12, 'E9b');
INSERT INTO public."Category" VALUES (113, 12, 'E9a');
INSERT INTO public."Category" VALUES (114, 12, 'E8');
INSERT INTO public."Category" VALUES (115, 12, 'E7');
INSERT INTO public."Category" VALUES (116, 12, 'E6');
INSERT INTO public."Category" VALUES (117, 12, 'E5');
INSERT INTO public."Category" VALUES (118, 12, 'E4');
INSERT INTO public."Category" VALUES (119, 12, 'E3');
INSERT INTO public."Category" VALUES (120, 12, 'E2Ü');
INSERT INTO public."Category" VALUES (121, 12, 'E2');
INSERT INTO public."Category" VALUES (122, 12, 'E1');
INSERT INTO public."Category" VALUES (123, 13, 'SHK');
INSERT INTO public."Category" VALUES (124, 13, 'WHK_FH (WHB)');
INSERT INTO public."Category" VALUES (125, 13, 'WHK');

/*
Tables Needed: 
1.-"SalaryTypes
*/
INSERT INTO public."CustomersSalaryTypes" ("IdCustomer","IdSalaryType","YearlyWorkHours") VALUES (1,4,1540.00);
INSERT INTO public."CustomersSalaryTypes" ("IdCustomer","IdSalaryType","YearlyWorkHours") VALUES (1,8,1540.00);
INSERT INTO public."CustomersSalaryTypes" ("IdCustomer","IdSalaryType","YearlyWorkHours") VALUES (1,12,1540.00);
INSERT INTO public."CustomersSalaryTypes" ("IdCustomer","IdSalaryType","YearlyWorkHours") VALUES (1,13,1540.00);

INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (1, 'Stufe 1', TRUE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (2, 'Stufe 2', TRUE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (3, 'Stufe 3', TRUE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (4, 'Stufe 4', TRUE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (5, 'Stufe 5', TRUE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (6, 'First Average', TRUE, 1);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (7, 'Stufe 6', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (8, 'Second Average', TRUE, 2);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (9, 'Stufe 7', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (10, 'Stufe 8', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (11, 'Stufe 9', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (12, 'Stufe 10', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (13, 'Stufe 11', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (14, 'Stufe 12', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (15, 'Stufe 13', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (16, 'Stufe 14', FALSE, 0);
INSERT INTO public."Seniority" ("IdSeniority", "Description", "Default", "Average") 
VALUES (17, 'Stufe 15', FALSE, 0);


 
/*
Tables Needed: 
1.-Status, 
2.-FilesObjects
*/
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,1);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,2);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,3);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,4);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,5);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (1,6);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (2,1);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (2,2);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (2,3);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (3,1);
INSERT INTO public."FileObjectsStatus" ("IdFileObject", "IdStatus") VALUES (3,3);

/*
Tables Needed: 
1.-Status, 
*/
INSERT INTO public."TokenSatus" ("IdStauts", "StatusName") VALUES (1,'Available');
INSERT INTO public."TokenSatus" ("IdStauts", "StatusName") VALUES (2,'Used');
INSERT INTO public."TokenSatus" ("IdStauts", "StatusName") VALUES (3,'Invalidated');
INSERT INTO public."TokenSatus" ("IdStauts", "StatusName") VALUES (4,'Expired');

/*
Tables Needed: 
1.-Users,
2.-Organizational_Units 
*/
INSERT INTO public."Users_Organizational_Units" ("UserName", "IdOrganizationalunit", "IdRole") VALUES ('Admin',1,1);
INSERT INTO public."Users_Organizational_Units" ("UserName", "IdOrganizationalunit", "IdRole") VALUES ('MEXabat Admin',1,1);

