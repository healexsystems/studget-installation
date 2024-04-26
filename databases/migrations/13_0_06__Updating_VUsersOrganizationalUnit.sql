CREATE OR REPLACE VIEW public."VUsersOrganizationalUnit"
 AS
 SELECT "Users_Organizational_Units"."UserName",
    "Users"."Enabled" AS "UserEnabled",
    "Users_Organizational_Units"."IdOrganizationalunit" AS "IdOrganizationalUnit",
    "Organizational_Units"."Enabled" AS "OrganizationalUnitEnabled",
	"Users"."Name"
   FROM "Users_Organizational_Units"
     JOIN "Users" ON "Users"."UserName"::text = "Users_Organizational_Units"."UserName"::text
     JOIN "Organizational_Units" ON "Users_Organizational_Units"."IdOrganizationalunit" = "Organizational_Units"."IdOrganizationalunit"
 ORDER BY "Users_Organizational_Units"."UserName";