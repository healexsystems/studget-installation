create view "VVersionInformation" as
select "Versions"."IdVersion", "Versions"."Date", "ChangeCategory"."IdChangeCategory", "ChangeCategory"."CategoryName", "VersionChangeLog"."IdChangeLog", "VersionChangeLog"."Description"
from  "Versions" 
left join "VersionChangeLog" on "Versions"."IdVersion" = "VersionChangeLog"."IdVersion"
left join "ChangeCategory" on "ChangeCategory"."IdChangeCategory" = "VersionChangeLog"."IdChangeCategory";