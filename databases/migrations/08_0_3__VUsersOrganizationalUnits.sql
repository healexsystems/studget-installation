create view "VUsersOrganizationalUnit"  as
select 
"Users_Organizational_Units"."UserName",
"Users"."Enabled" as "UserEnabled",
"Users_Organizational_Units"."IdOrganizationalunit" as "IdOrganizationalUnit",
"Organizational_Units"."Enabled" as "OrganizationalUnitEnabled"
from "Users_Organizational_Units"
inner join "Users" on "Users"."UserName" = "Users_Organizational_Units"."UserName"
inner join "Organizational_Units" on "Users_Organizational_Units"."IdOrganizationalunit" = "Organizational_Units"."IdOrganizationalunit";

GRANT ALL ON TABLE public."VUsersOrganizationalUnit" TO studget;