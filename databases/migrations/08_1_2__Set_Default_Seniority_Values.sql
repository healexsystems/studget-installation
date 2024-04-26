update "Seniority" set "Default" = false;;
update "Seniority" set "Default" = true where "IdSeniority" in (6, 8);
