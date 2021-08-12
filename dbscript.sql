--DROP TABLE [dbo].[Customer];
--DROP TABLE [dbo].[CustomerLog];

CREATE TABLE [dbo].[Customer] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [Surname]          VARCHAR (50)  NOT NULL,
    [PhoneNumber]      VARCHAR (15)  NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [CreatedDate]      DATETIME2 (7) CONSTRAINT [CreatedDateDefault] DEFAULT (getdate()) NOT NULL,
    [LastModifiedBy]   VARCHAR (50)  NULL,
    [LastModifiedDate] DATETIME2 (7) NULL,
    [IsDeleted]        BIT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[CustomerLog] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [CustomerId]       INT           NULL,
    [Name]             VARCHAR (50)  NULL,
    [Surname]          VARCHAR (50)  NULL,
    [PhoneNumber]      VARCHAR (15)  NULL,
    [CreatedBy]        VARCHAR (50)  NULL,
    [CreatedDate]      DATETIME2 (7) NULL,
    [LastModifiedBy]   VARCHAR (50)  NULL,
    [LastModifiedDate] DATETIME2 (7) NULL,
    [IsDeleted]        BIT           NULL,
    [ProcessName]      VARCHAR (50)  NULL,
    [ProcessDate]      DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO
CREATE TRIGGER [dbo].[Customer_UPDATE] ON [dbo].[Customer]
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF ((SELECT TRIGGER_NESTLEVEL()) > 1) RETURN;

    DECLARE @Id INT

    SELECT @Id = INSERTED.Id
    FROM INSERTED

    UPDATE dbo.Customer
    SET LastModifiedDate = GETDATE()
    WHERE Id = @Id
END

GO
CREATE TRIGGER [dbo].[Customer_Log]
ON [dbo].[Customer]
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
            INSERT INTO [dbo].[CustomerLog] ([CustomerId], [Name], [Surname], [PhoneNumber], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate], [IsDeleted], [ProcessName], [ProcessDate])
 			SELECT d.Id, d.Name, d.Surname, d.PhoneNumber, d.CreatedBy, d.CreatedDate, d.LastModifiedBy, d.LastModifiedDate, d.IsDeleted, @operation, GETDATE()
			FROM deleted d;

	IF @operation = 'Insert' OR @operation = 'Update'
            INSERT INTO [dbo].[CustomerLog] ([CustomerId], [Name], [Surname], [PhoneNumber], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate], [IsDeleted], [ProcessName], [ProcessDate])
 			SELECT d.Id, d.Name, d.Surname, d.PhoneNumber, d.CreatedBy, d.CreatedDate, d.LastModifiedBy, d.LastModifiedDate, d.IsDeleted, @operation, GETDATE()
			FROM inserted d
END