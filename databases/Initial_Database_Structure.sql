--
-- PostgreSQL database dump
--

-- Dumped from database version 11.12 (Debian 11.12-0+deb10u1)
-- Dumped by pg_dump version 13.2

-- Started on 2021-09-27 14:13:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


--
-- Roles
--
CREATE ROLE healexuser;
ALTER ROLE healexuser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5ed3eec013c289b1710ad3a4bb4107850';

--
-- TOC entry 280 (class 1255 OID 35428)
-- Name: function_add_customer_salary_types(); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_add_customer_salary_types() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
		salaryTypes "SalaryTypes"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR salaryTypes IN select "IdSalaryType" from "SalaryTypes"
    	LOOP
			insert into "CustomersSalaryTypes" ("IdCustomer","IdSalaryType", "YearlyWorkHours") 
			                            values (new."IdCustomer", salaryTypes."IdSalaryType", 1540.00);
    	END LOOP;
		
		return new;
	END;
$$;


ALTER FUNCTION public.function_add_customer_salary_types() OWNER TO "healexuser";

--
-- TOC entry 297 (class 1255 OID 25233)
-- Name: function_default_salaries(integer); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_default_salaries(pidcustomer integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
		category "Category"%ROWTYPE;
		seniority "Seniority"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR category IN SELECT "IdCategory", "IdSalaryType"  FROM "Category" 
    	LOOP
			FOR seniority IN SELECT "IdSeniority" FROM "Seniority" WHERE "Default" = true
				LOOP
            		INSERT INTO "SalaryCustomers" ("IdCustomer", "IdCategory", "IdSalaryType", "IdSeniority", "Salary") VALUES ( pIdCustomer, category."IdCategory", category."IdSalaryType", seniority."IdSeniority", 0.00);
				END LOOP;
    	END LOOP;
	END;																	  
$$;


ALTER FUNCTION public.function_default_salaries(pidcustomer integer) OWNER TO "healexuser";

--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 297
-- Name: FUNCTION function_default_salaries(pidcustomer integer); Type: COMMENT; Schema: public; Owner: healexuser
--

COMMENT ON FUNCTION public.function_default_salaries(pidcustomer integer) IS 'This functions creates the default salary structure';


--
-- TOC entry 296 (class 1255 OID 25234)
-- Name: function_drop_customer(integer); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_drop_customer(pidcustomer integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE 

	BEGIN
		--At the end the customer can be deleted

		delete from "Customers" where "IdCustomer" = pidcustomer;
		
	END;

	

$$;


ALTER FUNCTION public.function_drop_customer(pidcustomer integer) OWNER TO "healexuser";

--
-- TOC entry 298 (class 1255 OID 29604)
-- Name: function_fill_conditions(); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_fill_conditions() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
		r "Conditions"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR r IN select "IdCondition", "IdCustomer"  from "Conditions" where "Conditions"."IdCustomer" = new."IdCustomer"
    	LOOP
			insert into "SurchargesConditions" ("IdCondition","IdCustomer", "IdSurcharge", "Value") 
			                           values (r."IdCondition", r."IdCustomer", new."IdSurcharge", 0.00);
    	END LOOP;
		
		return new;
	END;
$$;


ALTER FUNCTION public.function_fill_conditions() OWNER TO "healexuser";

--
-- TOC entry 299 (class 1255 OID 29788)
-- Name: function_fill_surcharges(); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_fill_surcharges() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
		r "Surcharges"%ROWTYPE;
	BEGIN
	--Create the default salaries table
	FOR r IN select "IdSurcharge", "IdCustomer"  from "Surcharges" where "Surcharges"."IdCustomer" = new."IdCustomer"
    	LOOP
			insert into "SurchargesConditions" ("IdCondition","IdCustomer", "IdSurcharge", "Value") 
			                          values (new."IdCondition", r."IdCustomer", r."IdSurcharge", 0.00);
    	END LOOP;
		
		return new;
	END;
$$;


ALTER FUNCTION public.function_fill_surcharges() OWNER TO "healexuser";

--
-- TOC entry 294 (class 1255 OID 25235)
-- Name: function_verify_password_changed(character varying); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_verify_password_changed(puser character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE 
		passwordchanged boolean;
	BEGIN
			/*
			Verify if the password was changed
			*/
			select "PasswordChanged" into passwordchanged
			from  "Users"
			where "UserName" = puser;
				  
			return passwordchanged;
	END;																	  
$$;


ALTER FUNCTION public.function_verify_password_changed(puser character varying) OWNER TO "healexuser";

--
-- TOC entry 295 (class 1255 OID 25236)
-- Name: function_verify_studget_users(character varying, character varying); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.function_verify_studget_users(puser character varying, ppassword character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE 
		quantity_user integer;
	BEGIN
			/*
			Fist verify if exist one user with the parameter data
			*/
			select count("UserName") into quantity_user
			from  "Users"
			where "UserName" = puser and
				  "Password" = ppassword;
				  
		    if quantity_user <> 0 then
				     return True;
				else
					return False;
			end if;
	END;																	  
$$;


ALTER FUNCTION public.function_verify_studget_users(puser character varying, ppassword character varying) OWNER TO "healexuser";

--
-- TOC entry 281 (class 1255 OID 25237)
-- Name: verifycaseid(); Type: FUNCTION; Schema: public; Owner: healexuser
--

CREATE FUNCTION public.verifycaseid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
   SELECT COALESCE(max("IdCases")+1, 1) INTO NEW."IdCases"
      FROM "Cases"
      WHERE "IdOrganizationalUnit" = NEW."IdOrganizationalUnit";
   RETURN NEW;
END;$$;


ALTER FUNCTION public.verifycaseid() OWNER TO "healexuser";

SET default_tablespace = '';

--
-- TOC entry 232 (class 1259 OID 28474)
-- Name: Action; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Action" (
    "IdAction" integer NOT NULL,
    "ActionName" character varying
);


ALTER TABLE public."Action" OWNER TO "healexuser";

--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN "Action"."ActionName"; Type: COMMENT; Schema: public; Owner: healexuser
--

COMMENT ON COLUMN public."Action"."ActionName" IS '1.-Open 2.-Closed 3.- View 4.- Reopen 5.-Deleted';


--
-- TOC entry 231 (class 1259 OID 28472)
-- Name: Action_IdAction_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Action_IdAction_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Action_IdAction_seq" OWNER TO "healexuser";

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 231
-- Name: Action_IdAction_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Action_IdAction_seq" OWNED BY public."Action"."IdAction";


--
-- TOC entry 271 (class 1259 OID 35961)
-- Name: CaseTemplatesGeneralSummations; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."CaseTemplatesGeneralSummations" (
    "IdCaseTemplate" integer NOT NULL,
    "IdGeneralSummation" integer NOT NULL,
    "ShowSubcases" boolean NOT NULL,
    "ShowBudget" boolean NOT NULL
);


ALTER TABLE public."CaseTemplatesGeneralSummations" OWNER TO "healexuser";

--
-- TOC entry 263 (class 1259 OID 35124)
-- Name: CaseTemplatesMasterForms; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."CaseTemplatesMasterForms" (
    "IdTemplateRow" integer NOT NULL,
    "IdCaseTemplate" integer NOT NULL,
    "IdMasterForm" integer NOT NULL,
    "Index" smallint NOT NULL,
    "Blocked" boolean NOT NULL,
    "Name" character varying NOT NULL
);


ALTER TABLE public."CaseTemplatesMasterForms" OWNER TO "healexuser";

--
-- TOC entry 262 (class 1259 OID 35122)
-- Name: CaseTemplatesMasterForms_IdTemplateRow_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."CaseTemplatesMasterForms_IdTemplateRow_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CaseTemplatesMasterForms_IdTemplateRow_seq" OWNER TO "healexuser";

--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 262
-- Name: CaseTemplatesMasterForms_IdTemplateRow_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."CaseTemplatesMasterForms_IdTemplateRow_seq" OWNED BY public."CaseTemplatesMasterForms"."IdTemplateRow";


--
-- TOC entry 239 (class 1259 OID 28541)
-- Name: Cases; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Cases" (
    "IdCase" integer NOT NULL,
    "ClosedDate" timestamp without time zone,
    "Owner" character varying NOT NULL,
    "Duration" integer NOT NULL,
    "IdCondition" integer,
    "IdCustomer" integer,
    "ResourcePoolFile" character varying NOT NULL
);


ALTER TABLE public."Cases" OWNER TO "healexuser";

--
-- TOC entry 272 (class 1259 OID 35976)
-- Name: CasesGeneralSummations; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."CasesGeneralSummations" (
    "IdCases" integer NOT NULL,
    "IdGeneralSummation" integer NOT NULL,
    "ShowSubcase" boolean DEFAULT true NOT NULL,
    "ShowBudget" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."CasesGeneralSummations" OWNER TO "healexuser";

--
-- TOC entry 261 (class 1259 OID 35093)
-- Name: CasesTemplates; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."CasesTemplates" (
    "IdCaseTemplate" integer NOT NULL,
    "CaseTemplateName" character varying NOT NULL,
    "IdOrganizationalUnit" integer NOT NULL,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."CasesTemplates" OWNER TO "healexuser";

--
-- TOC entry 260 (class 1259 OID 35091)
-- Name: CasesTemplates_IdCaseTemplate_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."CasesTemplates_IdCaseTemplate_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CasesTemplates_IdCaseTemplate_seq" OWNER TO "healexuser";

--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 260
-- Name: CasesTemplates_IdCaseTemplate_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."CasesTemplates_IdCaseTemplate_seq" OWNED BY public."CasesTemplates"."IdCaseTemplate";


--
-- TOC entry 206 (class 1259 OID 25254)
-- Name: Category; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Category" (
    "IdCategory" integer NOT NULL,
    "IdSalaryType" integer NOT NULL,
    "CategoryName" character varying NOT NULL
);


ALTER TABLE public."Category" OWNER TO "healexuser";

--
-- TOC entry 207 (class 1259 OID 25260)
-- Name: Category_IdCategory_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Category_IdCategory_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Category_IdCategory_seq" OWNER TO "healexuser";

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 207
-- Name: Category_IdCategory_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Category_IdCategory_seq" OWNED BY public."Category"."IdCategory";


--
-- TOC entry 238 (class 1259 OID 28517)
-- Name: ChangeLog; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."ChangeLog" (
    "IdFileLog" integer NOT NULL,
    "IdFile" integer NOT NULL,
    "DateTime" timestamp without time zone NOT NULL,
    "UserName" character varying NOT NULL,
    "IdAction" integer NOT NULL
);


ALTER TABLE public."ChangeLog" OWNER TO "healexuser";

--
-- TOC entry 237 (class 1259 OID 28515)
-- Name: ChangeLog_IdFileLog_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."ChangeLog_IdFileLog_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ChangeLog_IdFileLog_seq" OWNER TO "healexuser";

--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 237
-- Name: ChangeLog_IdFileLog_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."ChangeLog_IdFileLog_seq" OWNED BY public."ChangeLog"."IdFileLog";


--
-- TOC entry 249 (class 1259 OID 29558)
-- Name: Conditions; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Conditions" (
    "IdCondition" integer NOT NULL,
    "IdCustomer" integer NOT NULL,
    "ConditionName" character varying NOT NULL,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."Conditions" OWNER TO "healexuser";

--
-- TOC entry 248 (class 1259 OID 29556)
-- Name: Conditions_IdCondition_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Conditions_IdCondition_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Conditions_IdCondition_seq" OWNER TO "healexuser";

--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 248
-- Name: Conditions_IdCondition_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Conditions_IdCondition_seq" OWNED BY public."Conditions"."IdCondition";


--
-- TOC entry 208 (class 1259 OID 25279)
-- Name: Customers; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Customers" (
    "IdCustomer" integer NOT NULL,
    "NameCustomer" character varying NOT NULL,
    "Enabled" boolean NOT NULL,
    "Default" boolean,
    "IdMasterForm" integer,
    "AverageCostReference" integer NOT NULL,
    "Surcharge" numeric(9,2) NOT NULL
);


ALTER TABLE public."Customers" OWNER TO "healexuser";

--
-- TOC entry 252 (class 1259 OID 33245)
-- Name: CustomersSalaryTypes; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."CustomersSalaryTypes" (
    "IdCustomer" integer NOT NULL,
    "IdSalaryType" integer NOT NULL,
    "YearlyWorkHours" numeric(9,2) NOT NULL
);


ALTER TABLE public."CustomersSalaryTypes" OWNER TO "healexuser";

--
-- TOC entry 209 (class 1259 OID 25285)
-- Name: Customers_IdCustomer; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Customers_IdCustomer"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Customers_IdCustomer" OWNER TO "healexuser";

--
-- TOC entry 210 (class 1259 OID 25287)
-- Name: Customers_IdCustomer_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Customers_IdCustomer_seq"
    AS integer
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Customers_IdCustomer_seq" OWNER TO "healexuser";

--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 210
-- Name: Customers_IdCustomer_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Customers_IdCustomer_seq" OWNED BY public."Customers"."IdCustomer";


--
-- TOC entry 278 (class 1259 OID 36189)
-- Name: FileObjectsStatus; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."FileObjectsStatus" (
    "IdFileObject" integer NOT NULL,
    "IdStatus" integer NOT NULL
);


ALTER TABLE public."FileObjectsStatus" OWNER TO "healexuser";

--
-- TOC entry 236 (class 1259 OID 28496)
-- Name: Files; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Files" (
    "IdFile" integer NOT NULL,
    "IdOrganizationalUnit" integer NOT NULL,
    "Name" character varying NOT NULL,
    "IdStatus" integer NOT NULL,
    "CreatedBy" character varying NOT NULL,
    "LastModified" timestamp without time zone NOT NULL,
    "CreatedDate" timestamp without time zone NOT NULL,
    "File" character varying NOT NULL,
    "CurrentEditor" character varying,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."Files" OWNER TO "healexuser";

--
-- TOC entry 277 (class 1259 OID 36180)
-- Name: FilesObjects; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."FilesObjects" (
    "IdFileObject" integer NOT NULL,
    "ObjectName" character varying NOT NULL
);


ALTER TABLE public."FilesObjects" OWNER TO "healexuser";

--
-- TOC entry 276 (class 1259 OID 36178)
-- Name: FilesObjects_IdFileObject_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."FilesObjects_IdFileObject_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FilesObjects_IdFileObject_seq" OWNER TO "healexuser";

--
-- TOC entry 3407 (class 0 OID 0)
-- Dependencies: 276
-- Name: FilesObjects_IdFileObject_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."FilesObjects_IdFileObject_seq" OWNED BY public."FilesObjects"."IdFileObject";


--
-- TOC entry 235 (class 1259 OID 28494)
-- Name: Files_IdFile_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Files_IdFile_seq"
    AS integer
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Files_IdFile_seq" OWNER TO "healexuser";

--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 235
-- Name: Files_IdFile_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Files_IdFile_seq" OWNED BY public."Files"."IdFile";


--
-- TOC entry 270 (class 1259 OID 35947)
-- Name: GeneralSummations; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."GeneralSummations" (
    "IdGeneralSummation" integer NOT NULL,
    "GeneralSummationName" character varying NOT NULL,
    "IdCustomer" integer NOT NULL,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."GeneralSummations" OWNER TO "healexuser";

--
-- TOC entry 269 (class 1259 OID 35945)
-- Name: GeneralSummations_IdGeneralSummation_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."GeneralSummations_IdGeneralSummation_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."GeneralSummations_IdGeneralSummation_seq" OWNER TO "healexuser";

--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 269
-- Name: GeneralSummations_IdGeneralSummation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."GeneralSummations_IdGeneralSummation_seq" OWNED BY public."GeneralSummations"."IdGeneralSummation";


--
-- TOC entry 254 (class 1259 OID 34545)
-- Name: LogIns; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."LogIns" (
    "UserId" character varying NOT NULL,
    "JwtId" character varying NOT NULL,
    "DateTime" timestamp with time zone NOT NULL,
    "LoggedIn" boolean NOT NULL,
    "Token" character varying NOT NULL
);


ALTER TABLE public."LogIns" OWNER TO "healexuser";

--
-- TOC entry 242 (class 1259 OID 28606)
-- Name: MasterForms; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."MasterForms" (
    "IdMasterForm" integer NOT NULL,
    "SummaryFile" character varying NOT NULL,
    "General" boolean NOT NULL,
    "Parent" integer,
    "AllowPerPatients" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."MasterForms" OWNER TO "healexuser";

--
-- TOC entry 274 (class 1259 OID 36006)
-- Name: MasterFormsGeneralSummations; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."MasterFormsGeneralSummations" (
    "IdMasterForm" integer NOT NULL,
    "IdGeneralSummation" integer NOT NULL
);


ALTER TABLE public."MasterFormsGeneralSummations" OWNER TO "healexuser";

--
-- TOC entry 211 (class 1259 OID 25289)
-- Name: Organizational_Units; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Organizational_Units" (
    "IdOrganizationalunit" integer NOT NULL,
    "NameOrganizationalUnit" character varying NOT NULL,
    "IdCustomer" integer NOT NULL,
    "Enabled" boolean NOT NULL,
    "Default" boolean NOT NULL
);


ALTER TABLE public."Organizational_Units" OWNER TO "healexuser";

--
-- TOC entry 212 (class 1259 OID 25295)
-- Name: Organizational_Units_IdOrganizationalunit_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Organizational_Units_IdOrganizationalunit_seq"
    AS integer
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Organizational_Units_IdOrganizationalunit_seq" OWNER TO "healexuser";

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 212
-- Name: Organizational_Units_IdOrganizationalunit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Organizational_Units_IdOrganizationalunit_seq" OWNED BY public."Organizational_Units"."IdOrganizationalunit";


--
-- TOC entry 259 (class 1259 OID 35077)
-- Name: Parameters; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Parameters" (
    "IdParameter" integer NOT NULL,
    "IdOrganizationalUnit" integer NOT NULL,
    "ParameterName" character varying NOT NULL,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."Parameters" OWNER TO "healexuser";

--
-- TOC entry 267 (class 1259 OID 35366)
-- Name: ParametersCaseTemplates; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."ParametersCaseTemplates" (
    "IdParameter" integer NOT NULL,
    "IdCaseTemplate" integer NOT NULL,
    "DefaultValue" numeric(11,2) NOT NULL
);


ALTER TABLE public."ParametersCaseTemplates" OWNER TO "healexuser";

--
-- TOC entry 264 (class 1259 OID 35143)
-- Name: ParametersCases; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."ParametersCases" (
    "IdParameter" integer NOT NULL,
    "IdCase" integer NOT NULL,
    "Value" numeric(11,2) NOT NULL
);


ALTER TABLE public."ParametersCases" OWNER TO "healexuser";

--
-- TOC entry 265 (class 1259 OID 35158)
-- Name: ParametersMasterForms; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."ParametersMasterForms" (
    "IdParameter" integer NOT NULL,
    "IdMasterForm" integer NOT NULL
);


ALTER TABLE public."ParametersMasterForms" OWNER TO "healexuser";

--
-- TOC entry 266 (class 1259 OID 35351)
-- Name: ParametersSubcases; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."ParametersSubcases" (
    "IdParameter" integer NOT NULL,
    "IdSubcase" integer NOT NULL,
    "Value" numeric(11,2) NOT NULL
);


ALTER TABLE public."ParametersSubcases" OWNER TO "healexuser";

--
-- TOC entry 258 (class 1259 OID 35075)
-- Name: Parameters_IdParameter_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Parameters_IdParameter_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Parameters_IdParameter_seq" OWNER TO "healexuser";

--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 258
-- Name: Parameters_IdParameter_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Parameters_IdParameter_seq" OWNED BY public."Parameters"."IdParameter";


--
-- TOC entry 213 (class 1259 OID 25297)
-- Name: Permission; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Permission" (
    "IdPermission" integer NOT NULL,
    "NamePermission" character varying
);


ALTER TABLE public."Permission" OWNER TO "healexuser";

--
-- TOC entry 214 (class 1259 OID 25303)
-- Name: Permission_IdPermission_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Permission_IdPermission_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Permission_IdPermission_seq" OWNER TO "healexuser";

--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 214
-- Name: Permission_IdPermission_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Permission_IdPermission_seq" OWNED BY public."Permission"."IdPermission";


--
-- TOC entry 257 (class 1259 OID 34569)
-- Name: RefreshToken; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."RefreshToken" (
    "Token" character varying NOT NULL,
    "JwtId" character varying NOT NULL,
    "CreationDate" timestamp with time zone NOT NULL,
    "ExpiryDate" timestamp with time zone NOT NULL,
    "UserId" character varying NOT NULL,
    "IdStatus" smallint NOT NULL
);


ALTER TABLE public."RefreshToken" OWNER TO "healexuser";

--
-- TOC entry 215 (class 1259 OID 25305)
-- Name: Roles; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Roles" (
    "IdRole" integer NOT NULL,
    "NameRole" character varying NOT NULL
);


ALTER TABLE public."Roles" OWNER TO "healexuser";

--
-- TOC entry 216 (class 1259 OID 25311)
-- Name: Roles_IdRole_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Roles_IdRole_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Roles_IdRole_seq" OWNER TO "healexuser";

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 216
-- Name: Roles_IdRole_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Roles_IdRole_seq" OWNED BY public."Roles"."IdRole";


--
-- TOC entry 217 (class 1259 OID 25313)
-- Name: Roles_Permissions; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Roles_Permissions" (
    "IdRole" integer NOT NULL,
    "IdPermission" integer NOT NULL
);


ALTER TABLE public."Roles_Permissions" OWNER TO "healexuser";

--
-- TOC entry 229 (class 1259 OID 25652)
-- Name: Roles_Screens; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Roles_Screens" (
    "IdScreen" integer NOT NULL,
    "IdRole" integer NOT NULL
);


ALTER TABLE public."Roles_Screens" OWNER TO "healexuser";

--
-- TOC entry 245 (class 1259 OID 28772)
-- Name: SalaryCustomers; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."SalaryCustomers" (
    "IdCustomer" integer NOT NULL,
    "IdCategory" integer NOT NULL,
    "IdSalaryType" integer NOT NULL,
    "IdSeniority" smallint NOT NULL,
    "Salary" numeric(9,2)
);


ALTER TABLE public."SalaryCustomers" OWNER TO "healexuser";

--
-- TOC entry 218 (class 1259 OID 25319)
-- Name: SalaryTypes; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."SalaryTypes" (
    "IdSalaryType" integer NOT NULL,
    "SalaryType" character varying NOT NULL
);


ALTER TABLE public."SalaryTypes" OWNER TO "healexuser";

--
-- TOC entry 219 (class 1259 OID 25325)
-- Name: SalaryTypes_IdSalaryType_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."SalaryTypes_IdSalaryType_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SalaryTypes_IdSalaryType_seq" OWNER TO "healexuser";

--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 219
-- Name: SalaryTypes_IdSalaryType_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."SalaryTypes_IdSalaryType_seq" OWNED BY public."SalaryTypes"."IdSalaryType";


--
-- TOC entry 228 (class 1259 OID 25643)
-- Name: Screens; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Screens" (
    "IdScreen" integer NOT NULL,
    "ScreenName" character varying NOT NULL
);


ALTER TABLE public."Screens" OWNER TO "healexuser";

--
-- TOC entry 227 (class 1259 OID 25641)
-- Name: Screens_IdScreen_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Screens_IdScreen_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Screens_IdScreen_seq" OWNER TO "healexuser";

--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 227
-- Name: Screens_IdScreen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Screens_IdScreen_seq" OWNED BY public."Screens"."IdScreen";


--
-- TOC entry 244 (class 1259 OID 28763)
-- Name: Seniority; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Seniority" (
    "IdSeniority" smallint NOT NULL,
    "Description" character varying,
    "Default" boolean NOT NULL,
    "Average" smallint NOT NULL
);


ALTER TABLE public."Seniority" OWNER TO "healexuser";

--
-- TOC entry 243 (class 1259 OID 28761)
-- Name: Seniority_IdSeniority_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Seniority_IdSeniority_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Seniority_IdSeniority_seq" OWNER TO "healexuser";

--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 243
-- Name: Seniority_IdSeniority_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Seniority_IdSeniority_seq" OWNED BY public."Seniority"."IdSeniority";


--
-- TOC entry 234 (class 1259 OID 28485)
-- Name: Status; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Status" (
    "IdStatus" integer NOT NULL,
    "StatusName" character varying NOT NULL
);


ALTER TABLE public."Status" OWNER TO "healexuser";

--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN "Status"."StatusName"; Type: COMMENT; Schema: public; Owner: healexuser
--

COMMENT ON COLUMN public."Status"."StatusName" IS '1.-Open 2.- Closed 3.- Edition';


--
-- TOC entry 233 (class 1259 OID 28483)
-- Name: Status_IdStatus_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Status_IdStatus_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Status_IdStatus_seq" OWNER TO "healexuser";

--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 233
-- Name: Status_IdStatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Status_IdStatus_seq" OWNED BY public."Status"."IdStatus";


--
-- TOC entry 241 (class 1259 OID 28561)
-- Name: Subcases; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Subcases" (
    "IdSubcase" integer NOT NULL,
    "IdCase" integer NOT NULL,
    "Owner" character varying NOT NULL,
    "ClosedDate" timestamp without time zone,
    "SummaryFile" character varying NOT NULL,
    "Patients" integer NOT NULL,
    "PerPatients" boolean NOT NULL,
    "Blocked" boolean NOT NULL,
    "IdMasterForm" integer,
    "AllowPerPatients" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."Subcases" OWNER TO "healexuser";

--
-- TOC entry 273 (class 1259 OID 35991)
-- Name: SubcasesGeneralSummations; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."SubcasesGeneralSummations" (
    "IdSubcase" integer NOT NULL,
    "IdGeneralSummation" integer NOT NULL
);


ALTER TABLE public."SubcasesGeneralSummations" OWNER TO "healexuser";

--
-- TOC entry 240 (class 1259 OID 28559)
-- Name: Subcases_IdSubcase_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Subcases_IdSubcase_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Subcases_IdSubcase_seq" OWNER TO "healexuser";

--
-- TOC entry 3450 (class 0 OID 0)
-- Dependencies: 240
-- Name: Subcases_IdSubcase_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Subcases_IdSubcase_seq" OWNED BY public."Subcases"."IdSubcase";


--
-- TOC entry 220 (class 1259 OID 25335)
-- Name: Surcharges; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Surcharges" (
    "IdSurcharge" integer NOT NULL,
    "IdCustomer" integer NOT NULL,
    "SurchargeName" character varying NOT NULL,
    "Enabled" boolean NOT NULL
);


ALTER TABLE public."Surcharges" OWNER TO "healexuser";

--
-- TOC entry 250 (class 1259 OID 29585)
-- Name: SurchargesConditions; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."SurchargesConditions" (
    "IdCondition" integer NOT NULL,
    "IdCustomer" integer NOT NULL,
    "IdSurcharge" integer NOT NULL,
    "Value" numeric(6,2)
);


ALTER TABLE public."SurchargesConditions" OWNER TO "healexuser";

--
-- TOC entry 221 (class 1259 OID 25338)
-- Name: Surcharges_IdSurcharge_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."Surcharges_IdSurcharge_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Surcharges_IdSurcharge_seq" OWNER TO "healexuser";

--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 221
-- Name: Surcharges_IdSurcharge_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."Surcharges_IdSurcharge_seq" OWNED BY public."Surcharges"."IdSurcharge";


--
-- TOC entry 256 (class 1259 OID 34560)
-- Name: TokenSatus; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."TokenSatus" (
    "IdStauts" smallint NOT NULL,
    "StatusName" character varying NOT NULL
);


ALTER TABLE public."TokenSatus" OWNER TO "healexuser";

--
-- TOC entry 3455 (class 0 OID 0)
-- Dependencies: 256
-- Name: COLUMN "TokenSatus"."StatusName"; Type: COMMENT; Schema: public; Owner: healexuser
--

COMMENT ON COLUMN public."TokenSatus"."StatusName" IS '1 available 2 used 3 invalidated 4 expired ';


--
-- TOC entry 255 (class 1259 OID 34558)
-- Name: TokenSatus_IdStauts_seq; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public."TokenSatus_IdStauts_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."TokenSatus_IdStauts_seq" OWNER TO "healexuser";

--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 255
-- Name: TokenSatus_IdStauts_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: healexuser
--

ALTER SEQUENCE public."TokenSatus_IdStauts_seq" OWNED BY public."TokenSatus"."IdStauts";


--
-- TOC entry 253 (class 1259 OID 33713)
-- Name: UserCases; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."UserCases" (
    "UserName" character varying NOT NULL,
    "IdCase" integer NOT NULL
);


ALTER TABLE public."UserCases" OWNER TO "healexuser";

--
-- TOC entry 223 (class 1259 OID 25354)
-- Name: Users; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Users" (
    "UserName" character varying NOT NULL,
    "Name" character varying NOT NULL,
    "Password" character varying NOT NULL,
    mail character varying NOT NULL,
    "IsStudget" boolean NOT NULL,
    "Enabled" boolean NOT NULL,
    "PasswordChanged" boolean NOT NULL,
    "MailVerified" boolean NOT NULL,
    "IdCustomer" integer NOT NULL,
    "SMSAccount" character varying
);


ALTER TABLE public."Users" OWNER TO "healexuser";

--
-- TOC entry 222 (class 1259 OID 25340)
-- Name: Users_Organizational_Units; Type: TABLE; Schema: public; Owner: healexuser
--

CREATE TABLE public."Users_Organizational_Units" (
    "UserName" character varying NOT NULL,
    "IdOrganizationalunit" integer NOT NULL,
    "IdRole" integer NOT NULL
);


ALTER TABLE public."Users_Organizational_Units" OWNER TO "healexuser";

--
-- TOC entry 246 (class 1259 OID 28792)
-- Name: VCategories; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VCategories" AS
 SELECT DISTINCT "Category"."IdCategory",
    "Category"."CategoryName",
    "SalaryCustomers"."IdCustomer",
    "SalaryCustomers"."IdSalaryType"
   FROM (public."SalaryCustomers"
     LEFT JOIN public."Category" ON ((("Category"."IdCategory" = "SalaryCustomers"."IdCategory") AND ("Category"."IdSalaryType" = "SalaryCustomers"."IdSalaryType"))))
  ORDER BY "Category"."IdCategory";


ALTER TABLE public."VCategories" OWNER TO "healexuser";

--
-- TOC entry 279 (class 1259 OID 36204)
-- Name: VFilesStatus; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VFilesStatus" AS
 SELECT "FilesObjects"."IdFileObject",
    "Status"."IdStatus",
    "Status"."StatusName"
   FROM ((public."FileObjectsStatus"
     LEFT JOIN public."FilesObjects" ON (("FilesObjects"."IdFileObject" = "FileObjectsStatus"."IdFileObject")))
     LEFT JOIN public."Status" ON (("Status"."IdStatus" = "FileObjectsStatus"."IdStatus")))
  ORDER BY "FilesObjects"."IdFileObject", "Status"."StatusName";


ALTER TABLE public."VFilesStatus" OWNER TO "healexuser";

--
-- TOC entry 268 (class 1259 OID 35767)
-- Name: VGeneralMasterForms; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VGeneralMasterForms" AS
 SELECT "Files"."IdFile",
    "Files"."IdOrganizationalUnit",
    "Files"."Name",
    "Files"."IdStatus",
    "Files"."CreatedBy",
    "Files"."LastModified",
    "Files"."CreatedDate",
    "Files"."File",
    "Files"."CurrentEditor",
    "Files"."Enabled",
    "MasterForms"."IdMasterForm",
    "MasterForms"."SummaryFile",
    "MasterForms"."General",
    "MasterForms"."Parent",
    "MasterForms"."AllowPerPatients"
   FROM (public."Files"
     JOIN public."MasterForms" ON (("Files"."IdFile" = "MasterForms"."IdMasterForm")))
  WHERE (("MasterForms"."General" = true) AND ("Files"."Enabled" = true));


ALTER TABLE public."VGeneralMasterForms" OWNER TO "healexuser";

--
-- TOC entry 225 (class 1259 OID 25623)
-- Name: VGetCustomer; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VGetCustomer" AS
 SELECT c."IdCustomer",
    u."UserName"
   FROM (((public."Customers" c
     JOIN public."Organizational_Units" ou ON ((c."IdCustomer" = ou."IdCustomer")))
     JOIN public."Users_Organizational_Units" uou ON ((ou."IdOrganizationalunit" = uou."IdOrganizationalunit")))
     JOIN public."Users" u ON (((uou."UserName")::text = (u."UserName")::text)));


ALTER TABLE public."VGetCustomer" OWNER TO "healexuser";

--
-- TOC entry 247 (class 1259 OID 28946)
-- Name: VSeniority; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VSeniority" AS
 SELECT "Seniority"."IdSeniority",
    "Seniority"."Description",
    "SalaryCustomers"."IdCustomer",
    "SalaryCustomers"."IdSalaryType",
    "SalaryCustomers"."IdCategory",
    "Seniority"."Average"
   FROM (public."SalaryCustomers"
     LEFT JOIN public."Seniority" ON (("Seniority"."IdSeniority" = "SalaryCustomers"."IdSeniority")))
  ORDER BY "Seniority"."IdSeniority";


ALTER TABLE public."VSeniority" OWNER TO "healexuser";

--
-- TOC entry 251 (class 1259 OID 29600)
-- Name: VSurcharges; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VSurcharges" AS
 SELECT "SurchargesConditions"."IdCondition",
    "SurchargesConditions"."IdCustomer",
    "SurchargesConditions"."IdSurcharge",
    "Surcharges"."SurchargeName",
    "SurchargesConditions"."Value"
   FROM ((public."SurchargesConditions"
     JOIN public."Surcharges" ON ((("SurchargesConditions"."IdSurcharge" = "Surcharges"."IdSurcharge") AND ("SurchargesConditions"."IdCustomer" = "Surcharges"."IdCustomer"))))
     JOIN public."Conditions" ON ((("SurchargesConditions"."IdCondition" = "Conditions"."IdCondition") AND ("SurchargesConditions"."IdCustomer" = "Conditions"."IdCustomer"))))
  WHERE (("Conditions"."Enabled" = true) AND ("Surcharges"."Enabled" = true))
  ORDER BY "Surcharges"."SurchargeName";


ALTER TABLE public."VSurcharges" OWNER TO "healexuser";

--
-- TOC entry 226 (class 1259 OID 25628)
-- Name: VUserOU; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VUserOU" AS
 SELECT uo."IdOrganizationalunit",
    ou."NameOrganizationalUnit",
    uo."IdRole",
    uo."UserName",
    ou."Default",
    ou."Enabled"
   FROM (public."Users_Organizational_Units" uo
     JOIN public."Organizational_Units" ou ON ((ou."IdOrganizationalunit" = uo."IdOrganizationalunit")));


ALTER TABLE public."VUserOU" OWNER TO "healexuser";

--
-- TOC entry 275 (class 1259 OID 36021)
-- Name: VUsersOrganizationalUnitsRoles; Type: VIEW; Schema: public; Owner: healexuser
--

CREATE VIEW public."VUsersOrganizationalUnitsRoles" AS
 SELECT "Users_Organizational_Units"."UserName",
    "Users_Organizational_Units"."IdOrganizationalunit",
    "Organizational_Units"."NameOrganizationalUnit",
    "Roles"."IdRole",
    "Roles"."NameRole"
   FROM ((public."Users_Organizational_Units"
     LEFT JOIN public."Organizational_Units" ON (("Users_Organizational_Units"."IdOrganizationalunit" = "Organizational_Units"."IdOrganizationalunit")))
     LEFT JOIN public."Roles" ON (("Roles"."IdRole" = "Users_Organizational_Units"."IdRole")));


ALTER TABLE public."VUsersOrganizationalUnitsRoles" OWNER TO "healexuser";

--
-- TOC entry 224 (class 1259 OID 25364)
-- Name: customers_idcustomer; Type: SEQUENCE; Schema: public; Owner: healexuser
--

CREATE SEQUENCE public.customers_idcustomer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_idcustomer OWNER TO "healexuser";

--
-- TOC entry 3075 (class 2604 OID 28477)
-- Name: Action IdAction; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Action" ALTER COLUMN "IdAction" SET DEFAULT nextval('public."Action_IdAction_seq"'::regclass);


--
-- TOC entry 3087 (class 2604 OID 35127)
-- Name: CaseTemplatesMasterForms IdTemplateRow; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesMasterForms" ALTER COLUMN "IdTemplateRow" SET DEFAULT nextval('public."CaseTemplatesMasterForms_IdTemplateRow_seq"'::regclass);


--
-- TOC entry 3086 (class 2604 OID 35096)
-- Name: CasesTemplates IdCaseTemplate; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesTemplates" ALTER COLUMN "IdCaseTemplate" SET DEFAULT nextval('public."CasesTemplates_IdCaseTemplate_seq"'::regclass);


--
-- TOC entry 3066 (class 2604 OID 25376)
-- Name: Category IdCategory; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Category" ALTER COLUMN "IdCategory" SET DEFAULT nextval('public."Category_IdCategory_seq"'::regclass);


--
-- TOC entry 3078 (class 2604 OID 28520)
-- Name: ChangeLog IdFileLog; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ChangeLog" ALTER COLUMN "IdFileLog" SET DEFAULT nextval('public."ChangeLog_IdFileLog_seq"'::regclass);


--
-- TOC entry 3083 (class 2604 OID 29561)
-- Name: Conditions IdCondition; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Conditions" ALTER COLUMN "IdCondition" SET DEFAULT nextval('public."Conditions_IdCondition_seq"'::regclass);


--
-- TOC entry 3067 (class 2604 OID 25378)
-- Name: Customers IdCustomer; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Customers" ALTER COLUMN "IdCustomer" SET DEFAULT nextval('public."Customers_IdCustomer_seq"'::regclass);


--
-- TOC entry 3077 (class 2604 OID 28499)
-- Name: Files IdFile; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Files" ALTER COLUMN "IdFile" SET DEFAULT nextval('public."Files_IdFile_seq"'::regclass);


--
-- TOC entry 3091 (class 2604 OID 36183)
-- Name: FilesObjects IdFileObject; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."FilesObjects" ALTER COLUMN "IdFileObject" SET DEFAULT nextval('public."FilesObjects_IdFileObject_seq"'::regclass);


--
-- TOC entry 3088 (class 2604 OID 35950)
-- Name: GeneralSummations IdGeneralSummation; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."GeneralSummations" ALTER COLUMN "IdGeneralSummation" SET DEFAULT nextval('public."GeneralSummations_IdGeneralSummation_seq"'::regclass);


--
-- TOC entry 3068 (class 2604 OID 25379)
-- Name: Organizational_Units IdOrganizationalunit; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Organizational_Units" ALTER COLUMN "IdOrganizationalunit" SET DEFAULT nextval('public."Organizational_Units_IdOrganizationalunit_seq"'::regclass);


--
-- TOC entry 3085 (class 2604 OID 35080)
-- Name: Parameters IdParameter; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Parameters" ALTER COLUMN "IdParameter" SET DEFAULT nextval('public."Parameters_IdParameter_seq"'::regclass);


--
-- TOC entry 3069 (class 2604 OID 25380)
-- Name: Permission IdPermission; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Permission" ALTER COLUMN "IdPermission" SET DEFAULT nextval('public."Permission_IdPermission_seq"'::regclass);


--
-- TOC entry 3070 (class 2604 OID 25381)
-- Name: Roles IdRole; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles" ALTER COLUMN "IdRole" SET DEFAULT nextval('public."Roles_IdRole_seq"'::regclass);


--
-- TOC entry 3071 (class 2604 OID 25382)
-- Name: SalaryTypes IdSalaryType; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryTypes" ALTER COLUMN "IdSalaryType" SET DEFAULT nextval('public."SalaryTypes_IdSalaryType_seq"'::regclass);


--
-- TOC entry 3073 (class 2604 OID 25646)
-- Name: Screens IdScreen; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Screens" ALTER COLUMN "IdScreen" SET DEFAULT nextval('public."Screens_IdScreen_seq"'::regclass);


--
-- TOC entry 3082 (class 2604 OID 28766)
-- Name: Seniority IdSeniority; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Seniority" ALTER COLUMN "IdSeniority" SET DEFAULT nextval('public."Seniority_IdSeniority_seq"'::regclass);


--
-- TOC entry 3076 (class 2604 OID 28488)
-- Name: Status IdStatus; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Status" ALTER COLUMN "IdStatus" SET DEFAULT nextval('public."Status_IdStatus_seq"'::regclass);


--
-- TOC entry 3079 (class 2604 OID 28564)
-- Name: Subcases IdSubcase; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Subcases" ALTER COLUMN "IdSubcase" SET DEFAULT nextval('public."Subcases_IdSubcase_seq"'::regclass);


--
-- TOC entry 3072 (class 2604 OID 25384)
-- Name: Surcharges IdSurcharge; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Surcharges" ALTER COLUMN "IdSurcharge" SET DEFAULT nextval('public."Surcharges_IdSurcharge_seq"'::regclass);


--
-- TOC entry 3084 (class 2604 OID 34563)
-- Name: TokenSatus IdStauts; Type: DEFAULT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."TokenSatus" ALTER COLUMN "IdStauts" SET DEFAULT nextval('public."TokenSatus_IdStauts_seq"'::regclass);


--
-- TOC entry 3120 (class 2606 OID 28482)
-- Name: Action Action_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Action"
    ADD CONSTRAINT "Action_pkey" PRIMARY KEY ("IdAction");


--
-- TOC entry 3166 (class 2606 OID 35965)
-- Name: CaseTemplatesGeneralSummations CaseTemplatesGeneralSummations_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesGeneralSummations"
    ADD CONSTRAINT "CaseTemplatesGeneralSummations_pkey" PRIMARY KEY ("IdCaseTemplate", "IdGeneralSummation");


--
-- TOC entry 3154 (class 2606 OID 35132)
-- Name: CaseTemplatesMasterForms CaseTemplatesMasterForms_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesMasterForms"
    ADD CONSTRAINT "CaseTemplatesMasterForms_pkey" PRIMARY KEY ("IdTemplateRow");


--
-- TOC entry 3168 (class 2606 OID 35980)
-- Name: CasesGeneralSummations CasesGeneralSummations_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesGeneralSummations"
    ADD CONSTRAINT "CasesGeneralSummations_pkey" PRIMARY KEY ("IdCases", "IdGeneralSummation");


--
-- TOC entry 3152 (class 2606 OID 35101)
-- Name: CasesTemplates CasesTemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesTemplates"
    ADD CONSTRAINT "CasesTemplates_pkey" PRIMARY KEY ("IdCaseTemplate");


--
-- TOC entry 3128 (class 2606 OID 28548)
-- Name: Cases Cases_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Cases"
    ADD CONSTRAINT "Cases_pkey" PRIMARY KEY ("IdCase");


--
-- TOC entry 3093 (class 2606 OID 25390)
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY ("IdCategory", "IdSalaryType");


--
-- TOC entry 3126 (class 2606 OID 28525)
-- Name: ChangeLog ChangeLog_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ChangeLog"
    ADD CONSTRAINT "ChangeLog_pkey" PRIMARY KEY ("IdFileLog");


--
-- TOC entry 3138 (class 2606 OID 29566)
-- Name: Conditions Conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Conditions"
    ADD CONSTRAINT "Conditions_pkey" PRIMARY KEY ("IdCondition", "IdCustomer");


--
-- TOC entry 3095 (class 2606 OID 25398)
-- Name: Customers Customers_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Customers"
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY ("IdCustomer");


--
-- TOC entry 3176 (class 2606 OID 36193)
-- Name: FileObjectsStatus FileObjectsStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."FileObjectsStatus"
    ADD CONSTRAINT "FileObjectsStatus_pkey" PRIMARY KEY ("IdFileObject", "IdStatus");


--
-- TOC entry 3174 (class 2606 OID 36188)
-- Name: FilesObjects FilesObjects_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."FilesObjects"
    ADD CONSTRAINT "FilesObjects_pkey" PRIMARY KEY ("IdFileObject");


--
-- TOC entry 3124 (class 2606 OID 28504)
-- Name: Files Files_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_pkey" PRIMARY KEY ("IdFile");


--
-- TOC entry 3164 (class 2606 OID 35955)
-- Name: GeneralSummations GeneralSummations_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."GeneralSummations"
    ADD CONSTRAINT "GeneralSummations_pkey" PRIMARY KEY ("IdGeneralSummation");


--
-- TOC entry 3144 (class 2606 OID 34552)
-- Name: LogIns LogIns_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."LogIns"
    ADD CONSTRAINT "LogIns_pkey" PRIMARY KEY ("JwtId", "UserId");


--
-- TOC entry 3172 (class 2606 OID 36010)
-- Name: MasterFormsGeneralSummations MasterFormsGeneralSummations_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterFormsGeneralSummations"
    ADD CONSTRAINT "MasterFormsGeneralSummations_pkey" PRIMARY KEY ("IdMasterForm", "IdGeneralSummation");


--
-- TOC entry 3132 (class 2606 OID 28613)
-- Name: MasterForms MasterForms_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterForms"
    ADD CONSTRAINT "MasterForms_pkey" PRIMARY KEY ("IdMasterForm");


--
-- TOC entry 3097 (class 2606 OID 25400)
-- Name: Organizational_Units Organizational_Units_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Organizational_Units"
    ADD CONSTRAINT "Organizational_Units_pkey" PRIMARY KEY ("IdOrganizationalunit");


--
-- TOC entry 3162 (class 2606 OID 35370)
-- Name: ParametersCaseTemplates ParametersCaseTemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCaseTemplates"
    ADD CONSTRAINT "ParametersCaseTemplates_pkey" PRIMARY KEY ("IdParameter", "IdCaseTemplate");


--
-- TOC entry 3156 (class 2606 OID 35147)
-- Name: ParametersCases ParametersCases_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCases"
    ADD CONSTRAINT "ParametersCases_pkey" PRIMARY KEY ("IdParameter", "IdCase");


--
-- TOC entry 3158 (class 2606 OID 35162)
-- Name: ParametersMasterForms ParametersMasterForms_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersMasterForms"
    ADD CONSTRAINT "ParametersMasterForms_pkey" PRIMARY KEY ("IdParameter", "IdMasterForm");


--
-- TOC entry 3160 (class 2606 OID 35355)
-- Name: ParametersSubcases ParametersSubcases_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersSubcases"
    ADD CONSTRAINT "ParametersSubcases_pkey" PRIMARY KEY ("IdParameter", "IdSubcase");


--
-- TOC entry 3150 (class 2606 OID 35085)
-- Name: Parameters Parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Parameters"
    ADD CONSTRAINT "Parameters_pkey" PRIMARY KEY ("IdParameter");


--
-- TOC entry 3099 (class 2606 OID 25402)
-- Name: Permission Permission_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Permission"
    ADD CONSTRAINT "Permission_pkey" PRIMARY KEY ("IdPermission");


--
-- TOC entry 3148 (class 2606 OID 34576)
-- Name: RefreshToken RefreshToken_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("Token");


--
-- TOC entry 3103 (class 2606 OID 25404)
-- Name: Roles_Permissions Roles_Permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Permissions"
    ADD CONSTRAINT "Roles_Permissions_pkey" PRIMARY KEY ("IdRole", "IdPermission");


--
-- TOC entry 3115 (class 2606 OID 25656)
-- Name: Roles_Screens Roles_Screens_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Screens"
    ADD CONSTRAINT "Roles_Screens_pkey" PRIMARY KEY ("IdScreen", "IdRole");


--
-- TOC entry 3101 (class 2606 OID 25406)
-- Name: Roles Roles_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY ("IdRole");


--
-- TOC entry 3136 (class 2606 OID 28776)
-- Name: SalaryCustomers SalaryCustomers_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryCustomers"
    ADD CONSTRAINT "SalaryCustomers_pkey" PRIMARY KEY ("IdCustomer", "IdCategory", "IdSalaryType", "IdSeniority");


--
-- TOC entry 3105 (class 2606 OID 25408)
-- Name: SalaryTypes SalaryTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryTypes"
    ADD CONSTRAINT "SalaryTypes_pkey" PRIMARY KEY ("IdSalaryType");


--
-- TOC entry 3113 (class 2606 OID 25651)
-- Name: Screens Screens_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Screens"
    ADD CONSTRAINT "Screens_pkey" PRIMARY KEY ("IdScreen");


--
-- TOC entry 3134 (class 2606 OID 28771)
-- Name: Seniority Seniority_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Seniority"
    ADD CONSTRAINT "Seniority_pkey" PRIMARY KEY ("IdSeniority");


--
-- TOC entry 3122 (class 2606 OID 28493)
-- Name: Status Status_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Status"
    ADD CONSTRAINT "Status_pkey" PRIMARY KEY ("IdStatus");


--
-- TOC entry 3170 (class 2606 OID 35995)
-- Name: SubcasesGeneralSummations SubcasesGeneralSummations_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SubcasesGeneralSummations"
    ADD CONSTRAINT "SubcasesGeneralSummations_pkey" PRIMARY KEY ("IdSubcase", "IdGeneralSummation");


--
-- TOC entry 3130 (class 2606 OID 28569)
-- Name: Subcases Subcases_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Subcases"
    ADD CONSTRAINT "Subcases_pkey" PRIMARY KEY ("IdSubcase");


--
-- TOC entry 3140 (class 2606 OID 29589)
-- Name: SurchargesConditions SurchargesConditions_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SurchargesConditions"
    ADD CONSTRAINT "SurchargesConditions_pkey" PRIMARY KEY ("IdCondition", "IdCustomer", "IdSurcharge");


--
-- TOC entry 3107 (class 2606 OID 25412)
-- Name: Surcharges Surcharges_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Surcharges"
    ADD CONSTRAINT "Surcharges_pkey" PRIMARY KEY ("IdSurcharge", "IdCustomer");


--
-- TOC entry 3146 (class 2606 OID 34568)
-- Name: TokenSatus TokenSatus_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."TokenSatus"
    ADD CONSTRAINT "TokenSatus_pkey" PRIMARY KEY ("IdStauts");


--
-- TOC entry 3142 (class 2606 OID 33720)
-- Name: UserCases UserCases_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."UserCases"
    ADD CONSTRAINT "UserCases_pkey" PRIMARY KEY ("IdCase", "UserName");


--
-- TOC entry 3109 (class 2606 OID 25414)
-- Name: Users_Organizational_Units Users_Organizational_Units_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users_Organizational_Units"
    ADD CONSTRAINT "Users_Organizational_Units_pkey" PRIMARY KEY ("UserName", "IdOrganizationalunit");


--
-- TOC entry 3111 (class 2606 OID 25416)
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("UserName");


--
-- TOC entry 3237 (class 2620 OID 35429)
-- Name: Customers TFillCustomerSalaryTypes; Type: TRIGGER; Schema: public; Owner: healexuser
--

CREATE TRIGGER "TFillCustomerSalaryTypes" AFTER INSERT ON public."Customers" FOR EACH ROW EXECUTE PROCEDURE public.function_add_customer_salary_types();


--
-- TOC entry 3239 (class 2620 OID 29789)
-- Name: Conditions trsurchargescondition; Type: TRIGGER; Schema: public; Owner: healexuser
--

CREATE TRIGGER trsurchargescondition AFTER INSERT ON public."Conditions" FOR EACH ROW EXECUTE PROCEDURE public.function_fill_surcharges();


--
-- TOC entry 3238 (class 2620 OID 29605)
-- Name: Surcharges trsurchargesdefinition; Type: TRIGGER; Schema: public; Owner: healexuser
--

CREATE TRIGGER trsurchargesdefinition AFTER INSERT ON public."Surcharges" FOR EACH ROW EXECUTE PROCEDURE public.function_fill_conditions();


--
-- TOC entry 3216 (class 2606 OID 35133)
-- Name: CaseTemplatesMasterForms FK_CaseTemplates; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesMasterForms"
    ADD CONSTRAINT "FK_CaseTemplates" FOREIGN KEY ("IdCaseTemplate") REFERENCES public."CasesTemplates"("IdCaseTemplate");


--
-- TOC entry 3202 (class 2606 OID 28782)
-- Name: SalaryCustomers FK_CategorySalary; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryCustomers"
    ADD CONSTRAINT "FK_CategorySalary" FOREIGN KEY ("IdCategory", "IdSalaryType") REFERENCES public."Category"("IdCategory", "IdSalaryType");


--
-- TOC entry 3189 (class 2606 OID 31685)
-- Name: Files FK_CreatedBy; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "FK_CreatedBy" FOREIGN KEY ("CreatedBy") REFERENCES public."Users"("UserName") ON DELETE CASCADE;


--
-- TOC entry 3235 (class 2606 OID 36194)
-- Name: FileObjectsStatus FK_FileObject; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."FileObjectsStatus"
    ADD CONSTRAINT "FK_FileObject" FOREIGN KEY ("IdFileObject") REFERENCES public."FilesObjects"("IdFileObject");


--
-- TOC entry 3191 (class 2606 OID 28526)
-- Name: ChangeLog FK_IdAction; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ChangeLog"
    ADD CONSTRAINT "FK_IdAction" FOREIGN KEY ("IdAction") REFERENCES public."Action"("IdAction");


--
-- TOC entry 3195 (class 2606 OID 28554)
-- Name: Cases FK_IdCase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Cases"
    ADD CONSTRAINT "FK_IdCase" FOREIGN KEY ("IdCase") REFERENCES public."Files"("IdFile") ON DELETE CASCADE;


--
-- TOC entry 3197 (class 2606 OID 31690)
-- Name: Subcases FK_IdCase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Subcases"
    ADD CONSTRAINT "FK_IdCase" FOREIGN KEY ("IdCase") REFERENCES public."Files"("IdFile");


--
-- TOC entry 3210 (class 2606 OID 33726)
-- Name: UserCases FK_IdCase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."UserCases"
    ADD CONSTRAINT "FK_IdCase" FOREIGN KEY ("IdCase") REFERENCES public."Cases"("IdCase") ON DELETE CASCADE;


--
-- TOC entry 3225 (class 2606 OID 35376)
-- Name: ParametersCaseTemplates FK_IdCaseTemplate; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCaseTemplates"
    ADD CONSTRAINT "FK_IdCaseTemplate" FOREIGN KEY ("IdCaseTemplate") REFERENCES public."CasesTemplates"("IdCaseTemplate");


--
-- TOC entry 3219 (class 2606 OID 35153)
-- Name: ParametersCases FK_IdCases; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCases"
    ADD CONSTRAINT "FK_IdCases" FOREIGN KEY ("IdCase") REFERENCES public."Cases"("IdCase");


--
-- TOC entry 3196 (class 2606 OID 33258)
-- Name: Cases FK_IdCondition; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Cases"
    ADD CONSTRAINT "FK_IdCondition" FOREIGN KEY ("IdCondition", "IdCustomer") REFERENCES public."Conditions"("IdCondition", "IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3205 (class 2606 OID 31715)
-- Name: SurchargesConditions FK_IdConditionCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SurchargesConditions"
    ADD CONSTRAINT "FK_IdConditionCustomer" FOREIGN KEY ("IdCondition", "IdCustomer") REFERENCES public."Conditions"("IdCondition", "IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3185 (class 2606 OID 28580)
-- Name: Users FK_IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3201 (class 2606 OID 28777)
-- Name: SalaryCustomers FK_IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryCustomers"
    ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3204 (class 2606 OID 31670)
-- Name: Conditions FK_IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Conditions"
    ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3181 (class 2606 OID 31675)
-- Name: Surcharges FK_IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Surcharges"
    ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3208 (class 2606 OID 33253)
-- Name: CustomersSalaryTypes FK_IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CustomersSalaryTypes"
    ADD CONSTRAINT "FK_IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3192 (class 2606 OID 31700)
-- Name: ChangeLog FK_IdFile; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ChangeLog"
    ADD CONSTRAINT "FK_IdFile" FOREIGN KEY ("IdFile") REFERENCES public."Files"("IdFile");


--
-- TOC entry 3199 (class 2606 OID 28614)
-- Name: MasterForms FK_IdFiles; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterForms"
    ADD CONSTRAINT "FK_IdFiles" FOREIGN KEY ("IdMasterForm") REFERENCES public."Files"("IdFile") ON DELETE CASCADE;


--
-- TOC entry 3183 (class 2606 OID 28590)
-- Name: Users_Organizational_Units FK_IdOrganizationalUnit; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users_Organizational_Units"
    ADD CONSTRAINT "FK_IdOrganizationalUnit" FOREIGN KEY ("IdOrganizationalunit") REFERENCES public."Organizational_Units"("IdOrganizationalunit") ON DELETE CASCADE;


--
-- TOC entry 3214 (class 2606 OID 35086)
-- Name: Parameters FK_IdOrganizationalUnit; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Parameters"
    ADD CONSTRAINT "FK_IdOrganizationalUnit" FOREIGN KEY ("IdOrganizationalUnit") REFERENCES public."Organizational_Units"("IdOrganizationalunit");


--
-- TOC entry 3215 (class 2606 OID 35102)
-- Name: CasesTemplates FK_IdOrganizationalUnit; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesTemplates"
    ADD CONSTRAINT "FK_IdOrganizationalUnit" FOREIGN KEY ("IdOrganizationalUnit") REFERENCES public."Organizational_Units"("IdOrganizationalunit");


--
-- TOC entry 3190 (class 2606 OID 31710)
-- Name: Files FK_IdOrganizationalUnits; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "FK_IdOrganizationalUnits" FOREIGN KEY ("IdOrganizationalUnit") REFERENCES public."Organizational_Units"("IdOrganizationalunit") ON DELETE CASCADE;


--
-- TOC entry 3218 (class 2606 OID 35148)
-- Name: ParametersCases FK_IdParameter; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCases"
    ADD CONSTRAINT "FK_IdParameter" FOREIGN KEY ("IdParameter") REFERENCES public."Parameters"("IdParameter");


--
-- TOC entry 3220 (class 2606 OID 35163)
-- Name: ParametersMasterForms FK_IdParameter; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersMasterForms"
    ADD CONSTRAINT "FK_IdParameter" FOREIGN KEY ("IdParameter") REFERENCES public."Parameters"("IdParameter");


--
-- TOC entry 3222 (class 2606 OID 35356)
-- Name: ParametersSubcases FK_IdParameter; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersSubcases"
    ADD CONSTRAINT "FK_IdParameter" FOREIGN KEY ("IdParameter") REFERENCES public."Parameters"("IdParameter");


--
-- TOC entry 3224 (class 2606 OID 35371)
-- Name: ParametersCaseTemplates FK_IdParameters; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersCaseTemplates"
    ADD CONSTRAINT "FK_IdParameters" FOREIGN KEY ("IdParameter") REFERENCES public."Parameters"("IdParameter");


--
-- TOC entry 3184 (class 2606 OID 28595)
-- Name: Users_Organizational_Units FK_IdRole; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users_Organizational_Units"
    ADD CONSTRAINT "FK_IdRole" FOREIGN KEY ("IdRole") REFERENCES public."Roles"("IdRole");


--
-- TOC entry 3207 (class 2606 OID 33248)
-- Name: CustomersSalaryTypes FK_IdSalaryType; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CustomersSalaryTypes"
    ADD CONSTRAINT "FK_IdSalaryType" FOREIGN KEY ("IdSalaryType") REFERENCES public."SalaryTypes"("IdSalaryType");


--
-- TOC entry 3188 (class 2606 OID 28601)
-- Name: Files FK_IdStatus; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "FK_IdStatus" FOREIGN KEY ("IdStatus") REFERENCES public."Status"("IdStatus");


--
-- TOC entry 3213 (class 2606 OID 34582)
-- Name: RefreshToken FK_IdStatus; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "FK_IdStatus" FOREIGN KEY ("IdStatus") REFERENCES public."TokenSatus"("IdStauts");


--
-- TOC entry 3223 (class 2606 OID 35361)
-- Name: ParametersSubcases FK_IdSubcase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersSubcases"
    ADD CONSTRAINT "FK_IdSubcase" FOREIGN KEY ("IdSubcase") REFERENCES public."Subcases"("IdSubcase");


--
-- TOC entry 3206 (class 2606 OID 31720)
-- Name: SurchargesConditions FK_IdSurchargeCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SurchargesConditions"
    ADD CONSTRAINT "FK_IdSurchargeCustomer" FOREIGN KEY ("IdCustomer", "IdSurcharge") REFERENCES public."Surcharges"("IdCustomer", "IdSurcharge") ON DELETE CASCADE;


--
-- TOC entry 3211 (class 2606 OID 34553)
-- Name: LogIns FK_IdUser; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."LogIns"
    ADD CONSTRAINT "FK_IdUser" FOREIGN KEY ("UserId") REFERENCES public."Users"("UserName");


--
-- TOC entry 3178 (class 2606 OID 26956)
-- Name: Organizational_Units FK_Id_Customer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Organizational_Units"
    ADD CONSTRAINT "FK_Id_Customer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer") ON DELETE CASCADE;


--
-- TOC entry 3212 (class 2606 OID 34577)
-- Name: RefreshToken FK_JwtId; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "FK_JwtId" FOREIGN KEY ("JwtId", "UserId") REFERENCES public."LogIns"("JwtId", "UserId");


--
-- TOC entry 3221 (class 2606 OID 35168)
-- Name: ParametersMasterForms FK_MasterForm; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ParametersMasterForms"
    ADD CONSTRAINT "FK_MasterForm" FOREIGN KEY ("IdMasterForm") REFERENCES public."MasterForms"("IdMasterForm");


--
-- TOC entry 3217 (class 2606 OID 35138)
-- Name: CaseTemplatesMasterForms FK_MasterForms; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesMasterForms"
    ADD CONSTRAINT "FK_MasterForms" FOREIGN KEY ("IdMasterForm") REFERENCES public."MasterForms"("IdMasterForm");


--
-- TOC entry 3194 (class 2606 OID 28549)
-- Name: Cases FK_Owner; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Cases"
    ADD CONSTRAINT "FK_Owner" FOREIGN KEY ("Owner") REFERENCES public."Users"("UserName");


--
-- TOC entry 3198 (class 2606 OID 31695)
-- Name: Subcases FK_Owner; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Subcases"
    ADD CONSTRAINT "FK_Owner" FOREIGN KEY ("Owner") REFERENCES public."Users"("UserName") ON DELETE CASCADE;


--
-- TOC entry 3200 (class 2606 OID 33422)
-- Name: MasterForms FK_Parent; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterForms"
    ADD CONSTRAINT "FK_Parent" FOREIGN KEY ("Parent") REFERENCES public."MasterForms"("IdMasterForm") ON DELETE CASCADE;


--
-- TOC entry 3203 (class 2606 OID 28787)
-- Name: SalaryCustomers FK_SalaryTime; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SalaryCustomers"
    ADD CONSTRAINT "FK_SalaryTime" FOREIGN KEY ("IdSeniority") REFERENCES public."Seniority"("IdSeniority");


--
-- TOC entry 3236 (class 2606 OID 36199)
-- Name: FileObjectsStatus FK_Status; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."FileObjectsStatus"
    ADD CONSTRAINT "FK_Status" FOREIGN KEY ("IdStatus") REFERENCES public."Status"("IdStatus");


--
-- TOC entry 3182 (class 2606 OID 28585)
-- Name: Users_Organizational_Units FK_UserName; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Users_Organizational_Units"
    ADD CONSTRAINT "FK_UserName" FOREIGN KEY ("UserName") REFERENCES public."Users"("UserName") ON DELETE CASCADE;


--
-- TOC entry 3193 (class 2606 OID 31705)
-- Name: ChangeLog FK_UserName; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."ChangeLog"
    ADD CONSTRAINT "FK_UserName" FOREIGN KEY ("UserName") REFERENCES public."Users"("UserName") ON DELETE CASCADE;


--
-- TOC entry 3209 (class 2606 OID 33721)
-- Name: UserCases FK_UserName; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."UserCases"
    ADD CONSTRAINT "FK_UserName" FOREIGN KEY ("UserName") REFERENCES public."Users"("UserName") ON DELETE CASCADE;


--
-- TOC entry 3229 (class 2606 OID 35981)
-- Name: CasesGeneralSummations IdCase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesGeneralSummations"
    ADD CONSTRAINT "IdCase" FOREIGN KEY ("IdCases") REFERENCES public."Cases"("IdCase");


--
-- TOC entry 3227 (class 2606 OID 35966)
-- Name: CaseTemplatesGeneralSummations IdCaseTemnplate; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesGeneralSummations"
    ADD CONSTRAINT "IdCaseTemnplate" FOREIGN KEY ("IdCaseTemplate") REFERENCES public."CasesTemplates"("IdCaseTemplate");


--
-- TOC entry 3226 (class 2606 OID 35956)
-- Name: GeneralSummations IdCustomer; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."GeneralSummations"
    ADD CONSTRAINT "IdCustomer" FOREIGN KEY ("IdCustomer") REFERENCES public."Customers"("IdCustomer");


--
-- TOC entry 3228 (class 2606 OID 35971)
-- Name: CaseTemplatesGeneralSummations IdGeneralSummation; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CaseTemplatesGeneralSummations"
    ADD CONSTRAINT "IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES public."GeneralSummations"("IdGeneralSummation");


--
-- TOC entry 3230 (class 2606 OID 35986)
-- Name: CasesGeneralSummations IdGeneralSummation; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."CasesGeneralSummations"
    ADD CONSTRAINT "IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES public."GeneralSummations"("IdGeneralSummation");


--
-- TOC entry 3232 (class 2606 OID 36001)
-- Name: SubcasesGeneralSummations IdGeneralSummation; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SubcasesGeneralSummations"
    ADD CONSTRAINT "IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES public."GeneralSummations"("IdGeneralSummation");


--
-- TOC entry 3233 (class 2606 OID 36011)
-- Name: MasterFormsGeneralSummations IdGeneralSummation; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterFormsGeneralSummations"
    ADD CONSTRAINT "IdGeneralSummation" FOREIGN KEY ("IdGeneralSummation") REFERENCES public."GeneralSummations"("IdGeneralSummation");


--
-- TOC entry 3234 (class 2606 OID 36016)
-- Name: MasterFormsGeneralSummations IdMasterForm; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."MasterFormsGeneralSummations"
    ADD CONSTRAINT "IdMasterForm" FOREIGN KEY ("IdMasterForm") REFERENCES public."MasterForms"("IdMasterForm");


--
-- TOC entry 3179 (class 2606 OID 25448)
-- Name: Roles_Permissions IdPermission; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Permissions"
    ADD CONSTRAINT "IdPermission" FOREIGN KEY ("IdPermission") REFERENCES public."Permission"("IdPermission");


--
-- TOC entry 3180 (class 2606 OID 25453)
-- Name: Roles_Permissions IdRole; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Permissions"
    ADD CONSTRAINT "IdRole" FOREIGN KEY ("IdRole") REFERENCES public."Roles"("IdRole");


--
-- TOC entry 3186 (class 2606 OID 25657)
-- Name: Roles_Screens IdRole; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Screens"
    ADD CONSTRAINT "IdRole" FOREIGN KEY ("IdRole") REFERENCES public."Roles"("IdRole");


--
-- TOC entry 3177 (class 2606 OID 25458)
-- Name: Category IdSalaryType; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "IdSalaryType" FOREIGN KEY ("IdSalaryType") REFERENCES public."SalaryTypes"("IdSalaryType");


--
-- TOC entry 3187 (class 2606 OID 25662)
-- Name: Roles_Screens IdScreen; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."Roles_Screens"
    ADD CONSTRAINT "IdScreen" FOREIGN KEY ("IdScreen") REFERENCES public."Screens"("IdScreen");


--
-- TOC entry 3231 (class 2606 OID 35996)
-- Name: SubcasesGeneralSummations IdSubcase; Type: FK CONSTRAINT; Schema: public; Owner: healexuser
--

ALTER TABLE ONLY public."SubcasesGeneralSummations"
    ADD CONSTRAINT "IdSubcase" FOREIGN KEY ("IdSubcase") REFERENCES public."Subcases"("IdSubcase");


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 297
-- Name: FUNCTION function_default_salaries(pidcustomer integer); Type: ACL; Schema: public; Owner: healexuser
--

GRANT ALL ON FUNCTION public.function_default_salaries(pidcustomer integer) TO healexuser;


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 296
-- Name: FUNCTION function_drop_customer(pidcustomer integer); Type: ACL; Schema: public; Owner: healexuser
--

GRANT ALL ON FUNCTION public.function_drop_customer(pidcustomer integer) TO healexuser;


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 294
-- Name: FUNCTION function_verify_password_changed(puser character varying); Type: ACL; Schema: public; Owner: healexuser
--

GRANT ALL ON FUNCTION public.function_verify_password_changed(puser character varying) TO healexuser;


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 295
-- Name: FUNCTION function_verify_studget_users(puser character varying, ppassword character varying); Type: ACL; Schema: public; Owner: healexuser
--

GRANT ALL ON FUNCTION public.function_verify_studget_users(puser character varying, ppassword character varying) TO healexuser;


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 281
-- Name: FUNCTION verifycaseid(); Type: ACL; Schema: public; Owner: healexuser
--

GRANT ALL ON FUNCTION public.verifycaseid() TO healexuser;


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "Action"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Action" TO healexuser;


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE "Action_IdAction_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Action_IdAction_seq" TO healexuser;


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE "CaseTemplatesGeneralSummations"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."CaseTemplatesGeneralSummations" TO healexuser;


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE "CaseTemplatesMasterForms"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."CaseTemplatesMasterForms" TO healexuser;


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 262
-- Name: SEQUENCE "CaseTemplatesMasterForms_IdTemplateRow_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."CaseTemplatesMasterForms_IdTemplateRow_seq" TO healexuser;


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE "Cases"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Cases" TO healexuser;


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE "CasesGeneralSummations"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."CasesGeneralSummations" TO healexuser;


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE "CasesTemplates"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."CasesTemplates" TO healexuser;


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 260
-- Name: SEQUENCE "CasesTemplates_IdCaseTemplate_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."CasesTemplates_IdCaseTemplate_seq" TO healexuser;


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE "Category"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Category" TO healexuser;


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 207
-- Name: SEQUENCE "Category_IdCategory_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Category_IdCategory_seq" TO healexuser;


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE "ChangeLog"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."ChangeLog" TO healexuser;


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 237
-- Name: SEQUENCE "ChangeLog_IdFileLog_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."ChangeLog_IdFileLog_seq" TO healexuser;


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE "Conditions"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Conditions" TO healexuser;


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE "Customers"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Customers" TO healexuser;


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE "CustomersSalaryTypes"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."CustomersSalaryTypes" TO healexuser;


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 209
-- Name: SEQUENCE "Customers_IdCustomer"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Customers_IdCustomer" TO healexuser;


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 210
-- Name: SEQUENCE "Customers_IdCustomer_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Customers_IdCustomer_seq" TO healexuser;


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE "Files"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Files" TO healexuser;


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 235
-- Name: SEQUENCE "Files_IdFile_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Files_IdFile_seq" TO healexuser;


--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE "GeneralSummations"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."GeneralSummations" TO healexuser;


--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE "GeneralSummations_IdGeneralSummation_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."GeneralSummations_IdGeneralSummation_seq" TO healexuser;


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE "LogIns"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."LogIns" TO healexuser;


--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE "MasterForms"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."MasterForms" TO healexuser;


--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE "MasterFormsGeneralSummations"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."MasterFormsGeneralSummations" TO healexuser;


--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE "Organizational_Units"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Organizational_Units" TO healexuser;


--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 212
-- Name: SEQUENCE "Organizational_Units_IdOrganizationalunit_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Organizational_Units_IdOrganizationalunit_seq" TO healexuser;


--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE "Parameters"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Parameters" TO healexuser;


--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE "ParametersCaseTemplates"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."ParametersCaseTemplates" TO healexuser;


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE "ParametersCases"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."ParametersCases" TO healexuser;


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE "ParametersMasterForms"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."ParametersMasterForms" TO healexuser;


--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE "ParametersSubcases"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."ParametersSubcases" TO healexuser;


--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE "Parameters_IdParameter_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Parameters_IdParameter_seq" TO healexuser;


--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE "Permission"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Permission" TO healexuser;


--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 214
-- Name: SEQUENCE "Permission_IdPermission_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Permission_IdPermission_seq" TO healexuser;


--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE "RefreshToken"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."RefreshToken" TO healexuser;


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "Roles"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Roles" TO healexuser;


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE "Roles_IdRole_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Roles_IdRole_seq" TO healexuser;


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "Roles_Permissions"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Roles_Permissions" TO healexuser;


--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "Roles_Screens"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."Roles_Screens" TO healexuser;


--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE "SalaryCustomers"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."SalaryCustomers" TO healexuser;


--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "SalaryTypes"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."SalaryTypes" TO healexuser;


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE "SalaryTypes_IdSalaryType_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."SalaryTypes_IdSalaryType_seq" TO healexuser;


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE "Screens"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."Screens" TO healexuser;


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE "Seniority"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Seniority" TO healexuser;


--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE "Seniority_IdSeniority_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Seniority_IdSeniority_seq" TO healexuser;


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "Status"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Status" TO healexuser;


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE "Status_IdStatus_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Status_IdStatus_seq" TO healexuser;


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE "Subcases"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Subcases" TO healexuser;


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE "SubcasesGeneralSummations"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."SubcasesGeneralSummations" TO healexuser;


--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE "Subcases_IdSubcase_seq"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public."Subcases_IdSubcase_seq" TO healexuser;


--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "Surcharges"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."Surcharges" TO healexuser;


--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE "SurchargesConditions"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."SurchargesConditions" TO healexuser;


--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE "TokenSatus"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,UPDATE ON TABLE public."TokenSatus" TO healexuser;


--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE "UserCases"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."UserCases" TO healexuser;


--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "Users"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Users" TO healexuser;


--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "Users_Organizational_Units"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Users_Organizational_Units" TO healexuser;


--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE "VCategories"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VCategories" TO healexuser;


--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE "VFilesStatus"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VFilesStatus" TO healexuser;


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE "VGeneralMasterForms"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VGeneralMasterForms" TO healexuser;


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "VGetCustomer"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VGetCustomer" TO healexuser;


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE "VSeniority"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VSeniority" TO healexuser;


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE "VSurcharges"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VSurcharges" TO healexuser;


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "VUserOU"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VUserOU" TO healexuser;


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE "VUsersOrganizationalUnitsRoles"; Type: ACL; Schema: public; Owner: healexuser
--

GRANT SELECT ON TABLE public."VUsersOrganizationalUnitsRoles" TO healexuser;


--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE customers_idcustomer; Type: ACL; Schema: public; Owner: healexuser
--

GRANT USAGE ON SEQUENCE public.customers_idcustomer TO healexuser;


-- Completed on 2021-09-27 14:15:19

--
-- PostgreSQL database dump complete
--