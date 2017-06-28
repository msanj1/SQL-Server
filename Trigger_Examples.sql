USE [BoralDevl]
GO

/****** Object:  Trigger [dbo].[auddel_SEC_USER]    Script Date: 6/28/2017 12:40:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[auddel_SEC_USER] on [dbo].[SEC_USER]
after delete
as
declare @_count int
select @_count = count(*) from master.dbo.sysprocesses where spid=@@spid and context_info <> 0x0
if @_count > 0
	return
declare @TableName varchar(100)
declare @AuditId int
declare @AudTimestamp varbinary(8)
set @tablename = 'SEC_USER'


insert into aud_audit (aud_datetime, userlogon, tablename, idcol,SourceTimestamp,Activity)
select getdate(),dbo.GetUser(), @tablename,d.USERID,timestamp,'d' from deleted d

set @AuditId = scope_identity()
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'USERID',cast(d.[USERID] as varchar(20)),null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'ACTIVE',cast(d.[ACTIVE] as varchar(20)),null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'LOGONID',d.[LOGONID],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'FIRSTNAME',d.[FIRSTNAME],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'LASTNAME',d.[LASTNAME],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'PHONE',d.[PHONE],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'FAX',d.[FAX],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'EMAIL',d.[EMAIL],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'LDAPNAME',d.[LDAPNAME],null,1
from	deleted d
insert into aud_auditdata(AuditId,ColName,OldValue,NewValue,Changed)
select @AuditId,'FIRSTANDLASTNAME',d.[FIRSTANDLASTNAME],null,1
from	deleted d



GO


