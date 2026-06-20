/*
Project: Metadata Driven Incremental ETL Framework
Author: Preety Rai
Purpose:
Generic ETL framework for loading data from source to target
using a watermark column and audit logging.

Features:
- Incremental loading
- Dynamic SQL
- Audit logging
- Error handling
- Reusable across multiple tables

Tables Required:
dbo.ETL_Audit
*/

---

## -- Audit Table

IF OBJECT_ID('dbo.ETL_Audit') IS NULL
BEGIN

```
CREATE TABLE dbo.ETL_Audit
(
      AuditID        INT IDENTITY(1,1)
    , TableName      VARCHAR(100)
    , LoadStartTime  DATETIME
    , LoadEndTime    DATETIME
    , RowsInserted   INT
    , Status         VARCHAR(50)
    , ErrorMessage   VARCHAR(MAX)
    , LastLoadDate   DATETIME
);
```

END
GO

---

## -- Stored Procedure

CREATE OR ALTER PROCEDURE dbo.usp_IncrementalLoad
(
@SourceTable      VARCHAR(200)
, @TargetTable      VARCHAR(200)
, @WatermarkColumn  VARCHAR(100)
)
AS
BEGIN

```
SET NOCOUNT ON;

DECLARE @LastLoadDate DATETIME;
DECLARE @SQL NVARCHAR(MAX);
DECLARE @RowsInserted INT = 0;

BEGIN TRY

    SELECT @LastLoadDate =
           MAX(LastLoadDate)
    FROM dbo.ETL_Audit
    WHERE TableName = @TargetTable
    AND Status = 'SUCCESS';

    IF @LastLoadDate IS NULL
        SET @LastLoadDate = '19000101';

    INSERT INTO dbo.ETL_Audit
    (
          TableName
        , LoadStartTime
        , Status
    )
    VALUES
    (
          @TargetTable
        , GETDATE()
        , 'STARTED'
    );

    SET @SQL = '
    INSERT INTO ' + @TargetTable + '
    SELECT *
    FROM ' + @SourceTable + '
    WHERE ' + @WatermarkColumn + ' > @LastLoadDate';

    EXEC sp_executesql
         @SQL,
         N'@LastLoadDate DATETIME',
         @LastLoadDate;

    SET @RowsInserted = @@ROWCOUNT;

    UPDATE dbo.ETL_Audit
    SET
          LoadEndTime = GETDATE()
        , RowsInserted = @RowsInserted
        , Status = ''SUCCESS''
        , LastLoadDate = GETDATE()
    WHERE AuditID =
    (
        SELECT MAX(AuditID)
        FROM dbo.ETL_Audit
        WHERE TableName = @TargetTable
    );

END TRY

BEGIN CATCH

    UPDATE dbo.ETL_Audit
    SET
          LoadEndTime = GETDATE()
        , Status = 'FAILED'
        , ErrorMessage = ERROR_MESSAGE()
    WHERE AuditID =
    (
        SELECT MAX(AuditID)
        FROM dbo.ETL_Audit
        WHERE TableName = @TargetTable
    );

    THROW;

END CATCH
```

END
GO

---

## -- Example Execution

EXEC dbo.usp_IncrementalLoad
@SourceTable = 'dbo.Customer_Stage',
@TargetTable = 'dbo.Customer',
@WatermarkColumn = 'LastModifiedDate';
