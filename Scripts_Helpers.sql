//Reset Identiy to 0
DBCC CHECKIDENT('randomsurnames', RESEED, 0)
//Get Random row
select GIVENNAMES
from PAR_PARTY
order by NEWID()
//Get Rownum 
select row_number()over (order by par.partyid) id,par.partyid  from PAR_PARTY par

//Setting security permisions for a profile  
  declare @profilename  varchar(100)
  declare @positionid int
  declare @objectname varchar(200)
  declare @objectid int
  declare @haseveryauthposition int
  declare objectids_cursor CURSOR FOR 
  select objectid from SEC_OBJECT where REFERENCE in
  (
   'Sbc.Claims.Victoria.Forms.VictoriaClaim.VictoriaClaimTree.VictoriaEarnings',
   'Sbc.Claims.SelfManaged.CGUVictoria.Claims.SM.Forms.CGUVictoriaClaimsSM.CGUVictoriaClaimsSMTree.CGUVictoriaInsurerFileNotes',
   'Sbc.Claims.SelfManaged.CGUVictoria.Claims.SM.Forms.CGUVictoriaClaimsSM.CGUVictoriaClaimsSMTree.CGUVictoriaInsurerEstimates',
   'Sbc.Claims.SelfManaged.CGUVictoria.Claims.SM.Forms.CGUVictoriaClaimsSM.CGUVictoriaClaimsSMTree.CGUVictoriaInsurerCompensationPayments',
   'Sbc.Claims.SelfManaged.CGUVictoria.Claims.SM.Forms.CGUVictoriaClaimsSM.CGUVictoriaClaimsSMTree.CGUVictoriaInsurerMedicalCertificates',
   'Sbc.Claims.Victoria.Forms.VictoriaClaim.VictoriaClaimTree.VictoriaMedicalCertificate',
   'CFA.Forms.Claim.CFAClaimTree.VictoriaReturnToWorkPlan',
   'CFA.Forms.Claim.CFAClaimTree.VictoriaClaimReview'
  )
    set @haseveryauthposition = 0;
	set @profilename = 'EVERYTH'
	set @objectid = 0

	SELECT @haseveryauthposition = 1  FROM SEC_POSITIONPROFILE where profile = @profilename;
	if	@haseveryauthposition = 1
	begin
	   open objectids_cursor
	  fetch next from objectids_cursor into @objectid
	  while @@FETCH_STATUS = 0
	  begin
		  insert into SEC_PERMISSIONS (OBJECTID, profile, READACCESS,MODIFYACCESS,INSERTACCESS,DELETEACCESS,PROPAGATEACCESS,EXECUTEACCESS)
		  values
		  (@objectid,@profilename,1,1,1,1,1,1);
		  fetch next from objectids_cursor into @objectid
	  end
	  close objectids_cursor
	end
	  DEALLOCATE objectids_cursor

//Scripts to grant select permission on all table-valued functions to a database role 
SELECT 'grant select on ' + schema_Name(schema_id) + '.' + NAME + ' to DB_ROLE'
FROM sys.objects 
WHERE type = 'TF'

//Scripts to grant execute permission on all scalar-valued functions to a database role 
SELECT 'grant execute on ' + schema_Name(schema_id) + '.' + NAME + ' to DB_ROLE'
FROM sys.objects 
WHERE type = 'FN'

//Scripts to grant execute permission on all stored procedures to a database role 
SELECT 'grant execute on ' + schema_Name(schema_id) + '.' + NAME + ' to DB_ROLE'
FROM sys.procedures
WHERE [TYPE] = 'P'
ORDER BY NAME

//Scripts to grant select permission on all views to a database role 
SELECT 'grant select on ' + table_schema + '.' + TABLE_NAME + ' to tnt_role'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'VIEW'
ORDER BY TABLE_NAME

//Scripts to grant select permission on all user tables to a database role 
SELECT 'grant select on ' + TABLE_NAME + ' to DB_ROLE'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME



//Grant all security objects to every profile of secprof
  declare @profilename  varchar(100)
  declare @positionid int
  declare @objectname varchar(200)
  declare @objectid int
  declare @haseveryauthposition int
  declare @objecttype int
  declare secprofilenames_cursor cursor for
  select codevalue from ZPRIMARYCODE where codetype = 'SECPROF' and userflag = 1
  declare objectids_cursor CURSOR FOR 
  select objectid from SEC_OBJECT
    set @haseveryauthposition = 0;
	set @profilename = 'EVERYTH';
	set @objectid = 0;
	set @objecttype = 0;
	begin
		open secprofilenames_cursor
		    fetch next from secprofilenames_cursor into @profilename
			while @@FETCH_STATUS = 0
			BEGIN
		
			   SELECT @haseveryauthposition = 1  FROM SEC_POSITIONPROFILE where profile = @profilename;
				if	@haseveryauthposition = 1
					begin
					  open objectids_cursor
					  fetch next from objectids_cursor into @objectid
					  while @@FETCH_STATUS = 0
						  begin
							  select @objecttype = type from SEC_OBJECT where objectid = @objectid
							  if @objecttype = 11
								  insert into SEC_PERMISSIONS (OBJECTID, profile, READACCESS,MODIFYACCESS,INSERTACCESS,DELETEACCESS,PROPAGATEACCESS,EXECUTEACCESS)
								  values
								  (@objectid,@profilename,0,0,0,0,0,1);
							  else
								  insert into SEC_PERMISSIONS (OBJECTID, profile, READACCESS,MODIFYACCESS,INSERTACCESS,DELETEACCESS,PROPAGATEACCESS,EXECUTEACCESS)
								  values
								  (@objectid,@profilename,1,1,1,1,1,1);

							  fetch next from objectids_cursor into @objectid
						  end
				      close objectids_cursor
			     end
			fetch next from secprofilenames_cursor into @profilename
			END
		close secprofilenames_cursor
	end
	DEALLOCATE objectids_cursor
	DEALLOCATE secprofilenames_cursor


  declare @profilename  varchar(100)
  declare @positionid int
  declare @objectname varchar(200)
  declare @objectid int
  declare @haseveryauthposition int
  declare @objecttype int
  declare secprofilenames_cursor cursor for
  select codevalue from ZPRIMARYCODE where codetype = 'SECPROF' and codevalue = 'EVERYTH' and userflag = 1
  declare objectids_cursor CURSOR FOR 
  select objectid from SEC_OBJECT where REFERENCE in
  (
  'Sbc.Claims.Victoria.Common.VictoriaSecureField.VictoriaCompensationOverrideCalculation',
  'Sbc.Claims.Victoria.Common.VictoriaSecureField.VictoriaCompensationRecurringPayment',
  'Insurer Unlinked Claims','Sbc.Claims.SelfManaged.Common.Claims.SM.Common.CommonClaimsSMCommands.UnlinkedClaims'
  )
    set @haseveryauthposition = 0;
	set @profilename = '';
	set @objectid = 0;
	set @objecttype = 0;
	begin
		open secprofilenames_cursor
		    fetch next from secprofilenames_cursor into @profilename
			while @@FETCH_STATUS = 0
			BEGIN
		
			   SELECT @haseveryauthposition = 1  FROM SEC_POSITIONPROFILE where profile = @profilename;
				if	@haseveryauthposition = 1
					begin
					  open objectids_cursor
					  fetch next from objectids_cursor into @objectid
					  while @@FETCH_STATUS = 0
						  begin
							  select @objecttype = type from SEC_OBJECT where objectid = @objectid
							  if @objecttype = 11
								  insert into SEC_PERMISSIONS (OBJECTID, profile, READACCESS,MODIFYACCESS,INSERTACCESS,DELETEACCESS,PROPAGATEACCESS,EXECUTEACCESS)
								  values
								  (@objectid,@profilename,0,0,0,0,0,1);
							  else
								  insert into SEC_PERMISSIONS (OBJECTID, profile, READACCESS,MODIFYACCESS,INSERTACCESS,DELETEACCESS,PROPAGATEACCESS,EXECUTEACCESS)
								  values
								  (@objectid,@profilename,1,1,1,1,1,1);

							  fetch next from objectids_cursor into @objectid
						  end
				      close objectids_cursor
			     end
			fetch next from secprofilenames_cursor into @profilename
			END
		close secprofilenames_cursor
	end
	DEALLOCATE objectids_cursor
	DEALLOCATE secprofilenames_cursor

//Find tables by foreign key
select 'DELETE FROM '+ t.name
from sys.foreign_key_columns as fk
inner join sys.tables as t on fk.parent_object_id = t.object_id
inner join sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
where fk.referenced_object_id = (select object_id from sys.tables where name = 'WFX_TRIGGERDATA')
order by t.name, fk.constraint_column_id

//Find tables by foreign key for multiple tables
select 'DELETE FROM '+ t.name
from sys.foreign_key_columns as fk
inner join sys.tables as t on fk.parent_object_id = t.object_id
inner join sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
where fk.referenced_object_id in( (select object_id from sys.tables where name in( 'CLM_INJURY_NZ','clm_claim')))
order by t.name, fk.constraint_column_id

//GRANT SELECT ON ALL VIEW OTHER THAn the ones that start with BASE
SELECT 'grant select on ' + B.TABLE_NAME + ' to FHNZ_Role'
FROM INFORMATION_SCHEMA.TABLES B
WHERE B.TABLE_TYPE = 'VIEW' and
NOT exists (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLES a
	WHERE a.TABLE_TYPE = 'VIEW' and a.TABLE_NAME = B.TABLE_NAME and a.TABLE_NAME like 'BASE%'
)

//Update with Joins
  update b  
  set b.emlid = e.new_id
  from
  EML_ATTACHMENT b inner join EML_INBOUNDEMAIL e on b.emlid = e.emlid;

//renaming of a Table's column
Exec sp_rename 'EML_INBOUNDEMAIL.Id_new', 'EMLID', 'Column';


//Find tables that do not have triggers
SELECT  distinct
    OBJECT_NAME(parent_obj) AS table_name 
FROM sysobjects 

INNER JOIN sysusers 
    ON sysobjects.uid = sysusers.uid 

INNER JOIN sys.tables t 
    ON sysobjects.parent_obj = t.object_id 

INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id 

where parent_obj not in 
(
SELECT 
 parent_obj
FROM sysobjects 

INNER JOIN sysusers 
    ON sysobjects.uid = sysusers.uid 

INNER JOIN sys.tables t 
    ON sysobjects.parent_obj = t.object_id 

INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id 

WHERE sysobjects.type = 'TR' and sysobjects.name like 'aud%'
)

//Dynamically loop through all nvarchar columns

SELECT ',' + c.name + '= nullif(rtrim(' + c.name + '),'''')'  FROM sys.tables t 
JOIN sys.columns c ON t.Object_ID = c.Object_ID 
WHERE t.Name = 'acc_cl$' and TYPE_NAME(c.system_type_id) = 'nvarchar'

//CHECK CURRENT seed
select IDENT_CURRENT('ADM_RATES')


//adding carriage return in a string
char(13) +char(10)

//List all services and service ids
sp_who

//Kill a process
kill 130

//Get all the tables and procedures that have been modified recently
select * from sys.objects where type in  ('U','P')
ORDER BY modify_date desc

//Used to shrink a file. Ie a Transaction Log getting too big because of its recovery mode.
DBCC SHRINKFILE

//Get the list of codes from zprimarycode that do not have an AggregatedBy in Zprimarycodedef
select z1.CodeType,z2.AggregatedBy from ZPRIMARYCODE z1
inner join ZPRIMARYCODEDEF z2 on z1.CodeType = z2.CodeType
where nullif(rtrim(z1.aggregatetype),'') is not null and nullif(rtrim(z2.aggregatedby),'') is null

-- Disable all table constraints

EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

-- Enable all table constraints

EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'	

//getting a list of disabled foreign keys
select * from sys.foreign_keys where is_disabled=1

//Run transaction with error checks for rollback

DECLARE @intErrorCode INT
begin transaction t1

SELECT @intErrorCode = @@ERROR
   IF (@intErrorCode <> 0) GOTO PROBLEM

commit transaction t1

PROBLEM:
IF (@intErrorCode <> 0) BEGIN
PRINT 'Unexpected error occurred!'
    ROLLBACK transaction t1
END



//Clear main tables
	declare @ErrorMessage nvarchar(500);
	declare @statement nvarchar(255);



	--disable constraints
	EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

	--clear tables
	declare @tablename varchar(255)
	
	declare c1 cursor LOCAL FORWARD_ONLY for
	SELECT case when name = 'CLM_CLAIM' then 'secure.CLM_CLAIM' else name end
	FROM sys.Tables
	where 
	(
	name not like 'Z%'
	and name not like 'SEC%'
	and name not like 'SEC%'
	and name not like 'BSB%'
	and name not like 'MIG%'
	and name not like 'FND%'
	and name not like 'SITE%'
	and name not like 'SER%'
	and name <> 'SYSTEMNUMBERS'
	and name <> 'POSTCODES'
	and name <> 'ADM_RATES'
	and name <> 'GL_ACCOUNT'
	and name <> 'GL_PAYMENTTYPE'
	and name <> 'GL_RULE'
	and name <> 'GL_LINKEDCODE'
	and name <> 'HR_DATA'
	and name <> 'ADM_TAXSCALE'
	and name <> 'ADM_ACCREDITEDPROVIDER_NSW'
	--and name <> 'SITE_SITE'
	AND name not like 'WF%'
	)
	or 
	(
	name = 'MIG_ERRORS' or
	name = 'SEC_HISTORY'
	)
	order by name
	
	open c1
	
	fetch next from c1 into @tablename
	
	while @@FETCH_STATUS = 0
	begin
		set @statement = 'delete from ' + @tablename
		EXECUTE sp_executesql @statement
		fetch next from c1 into @tablename
	end
		
	close c1;
	deallocate c1;
		
	
-- enable all constraints
	EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'	
	
	delete from secure.CLM_SECURITY_X

--search for a specific text in SQL Server in Definitions
DECLARE @Search varchar(255)
SET @Search='join ZPRIMARYCODE et on et.zone=0 and et.CodeType='

SELECT DISTINCT
    o.name AS Object_Name,o.type_desc
    FROM sys.sql_modules        m 
        INNER JOIN sys.objects  o ON m.object_id=o.object_id
    WHERE m.definition Like '%'+@Search+'%'
    ORDER BY 2,1
	
	
	
--select all tables that have column 'timestamp'
select * from  sys.tables t
where t.object_id in
(
	select object_id from sys.columns
	where name = 'timestamp'
)

--Register CLR class
sp_configure 'clr enabled', 1
RECONFIGURE WITH OVERRIDE

CREATE ASSEMBLY RegularExpressionFunctions FROM 'C:\temp\RegularExpression.dll'
go
CREATE Function RegExMatch(@Input NVARCHAR(512),@Pattern NVARCHAR(127))
RETURNS BIT
EXTERNAL NAME RegularExpressionFunctions.[RegularExpression.RegularExpression].RegExMatch
GO
CREATE Function RegExReplace(@Input NVARCHAR(512),@Pattern NVARCHAR(127), @Replacement NVARCHAR(512))
RETURNS NVARCHAR(512)
EXTERNAL NAME RegularExpressionFunctions.[RegularExpression.RegularExpression].RegExReplace
GO

--First day of the month
select DATEADD(MM,datediff(MM,0,getdate()),0) 

ALTER DATABASE <<Databasename>> SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;

--Create Customised insert into statements
select 'insert into '+ t.name +'('+ dbo.COMMASEPARATEVALUES(c.name) +')' +
' select ' +  dbo.COMMASEPARATEVALUES(c.name) +' from BoralWebformMigsource.dbo.' + t.name 
from  sys.tables t
inner join sys.columns c on c.object_id = t.object_id
where lower(t.name) = 'SEC_OBJECT' and lower(c.name) <> 'timestamp'
group by t.object_id, t.name

select
'IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID(N''BoralWebformMigsource.dbo.' +t.name +''') is not null and type = (N''U''))' 
+
case
when exists (select 1 from sys.columns c where c.object_id = t.object_id and c.is_identity = 1) 
then 'SET IDENTITY_INSERT ' + t.name + ' on;'
else ''
end  +
 'insert into '+ t.name +'('+ dbo.COMMASEPARATEVALUES(c.name) +')' +
' select ' +  dbo.COMMASEPARATEVALUES( case when c.user_type_id = 61 then 'try_convert(datetime,' +c.name+', 103)'  else c.name end) +' from BoralWebformMigsource.dbo.' + t.name + ';'+
case
when exists (select 1 from sys.columns c where c.object_id = t.object_id and c.is_identity = 1) 
then 'SET IDENTITY_INSERT ' + t.name + ' off;'
else ''
end 
from  sys.tables t
inner join sys.columns c on c.object_id = t.object_id
where lower(c.name) <> 'timestamp'
group by t.object_id, t.name


--test counts between two databases
select
'IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID(N''BoralWebformMigsource.dbo.' +t.name +''') is not null and type = (N''U'')) and 
 (select count (*) from BoralWebformMigsource.dbo.' + t.name + ') <> (select count(*) from ' + t.name + ')'
+
'print ''count_test failed for ' + t.name +''';'
from  sys.tables t




select *
from  sys.tables t
inner join sys.columns c on c.object_id = t.object_id
where lower(t.name) = 'ZZONE' and lower(c.name) <> 'timestamp'
group by t.object_id, t.name


--get a list of all indexes and when last they were updated
SELECT name AS index_name,
STATS_DATE(OBJECT_ID, index_id) AS StatsUpdated
FROM sys.indexes
WHERE OBJECTPROPERTYEX(object_id, 'IsSystemTable') = 0

