IF OBJECT_ID(N'dbo.customer', N'U') IS NOT NULL  
   DROP TABLE [dbo].[customer];
GO

IF OBJECT_ID(N'dbo.customer_log', N'U') IS NOT NULL  
   DROP TABLE [dbo].[customer_log];
GO

CREATE TABLE [dbo].[customer] (
    [id]             	 INT           IDENTITY (1, 1) NOT NULL,
    [name]           	 VARCHAR (50)  NOT NULL,
    [surname]         	 VARCHAR (50)  NOT NULL,
    [phone_number]     	 VARCHAR (15)  NULL,
    [created_by]       	 VARCHAR (50)  NOT NULL,
    [created_date]     	 DATETIME2 (7) CONSTRAINT [[created_date_default] DEFAULT (getdate()) NOT NULL,
    [last_modified_by]   VARCHAR (50)  NULL,
    [last_modified_date] DATETIME2 (7) NULL,
    [is_deleted]       	 BIT           NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

CREATE TABLE [dbo].[customer_log] (
    [id]               		INT           IDENTITY (1, 1) NOT NULL,
    [customer_id]       	INT           NULL,
    [name]             		VARCHAR (50)  NULL,
    [surname]          		VARCHAR (50)  NULL,
    [phone_number]      	VARCHAR (15)  NULL,
    [created_by]        	VARCHAR (50)  NULL,
    [created_date]     	 	DATETIME2 (7) NULL,
    [last_modified_by]   	VARCHAR (50)  NULL,
    [last_modified_date] 	DATETIME2 (7) NULL,
    [is_deleted]        	BIT           NULL,
    [process_name]      	VARCHAR (50)  NULL,
    [process_date]      	DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

GO
CREATE TRIGGER [dbo].[customer_update_trigger] ON [dbo].[customer]
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF ((SELECT TRIGGER_NESTLEVEL()) > 1) RETURN;

    DECLARE @Id INT

    SELECT @Id = INSERTED.id
    FROM INSERTED

    UPDATE dbo.customer
    SET last_modified_date = GETDATE()
    WHERE id = @Id
END

GO
CREATE TRIGGER [dbo].[customer_log_trigger]
ON [dbo].[customer]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @operation CHAR(6)
		SET @operation = CASE
				WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
					THEN 'Update'
				WHEN EXISTS(SELECT * FROM inserted)
					THEN 'Insert'
				WHEN EXISTS(SELECT * FROM deleted)
					THEN 'Delete'
				ELSE NULL
		END
	IF @operation = 'Delete'
            INSERT INTO [dbo].[customer_log] ([customer_id], [name], [surname], [phone_number], [created_by], [created_date], [last_modified_by], [last_modified_date], [is_deleted], [process_name], [process_date])
 			SELECT d.Id, d.name, d.surname, d.phone_number, d.created_by, d.created_date, d.last_modified_by, d.last_modified_date, d.is_deleted, @operation, GETDATE()
			FROM deleted d;

	IF @operation = 'Insert' OR @operation = 'Update'
            INSERT INTO [dbo].[customer_log] ([customer_id], [name], [surname], [phone_number], [created_by], [created_date], [last_modified_by], [last_modified_date], [is_deleted], [process_name], [process_date])
 			SELECT d.Id, d.name, d.surname, d.phone_number, d.created_by, d.created_date, d.last_modified_by, d.last_modified_date, d.is_deleted, @operation, GETDATE()
			FROM inserted d
END

GO
CREATE NONCLUSTERED INDEX [customer_index] ON [dbo].[customer]([name] ASC, [surname] ASC);

GO
CREATE NONCLUSTERED INDEX [customer_log_index] ON [dbo].[customer_log]([customer_id] ASC);