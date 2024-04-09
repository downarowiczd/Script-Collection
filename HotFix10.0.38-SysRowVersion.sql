DECLARE @KernelTables TABLE (
        TableName NVARCHAR(200),
        TableNumber Int);

DECLARE @ResultKernelTables TABLE (
        TableNumber Int);

-- List of all Kernel Tables, with a unique TableNumber
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('SQLDICTIONARY',1)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('SYSCONFIG',2)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('USERINFO',3)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('SECURITYROLE',4)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('DATABASELOG',5)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('AOSDUPLICATEKEYEXCEPTIONMESSAGE',6)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('TIMEZONESLIST',7)
INSERT INTO @KernelTables(TableName, TableNumber) VALUES('TIMEZONESRULESDATA',8)

-- get the KernelTable names
DECLARE KernelTableName_cursor CURSOR LOCAL FOR
SELECT TableName, TableNumber
FROM @KernelTables

-- (-1) : Exception happened
-- 0  : Dropped no column
-- 1  : Dropped atleast one Kernel Table column

DECLARE @Result INT = 0;
DECLARE @KernelTableName NVARCHAR(200);
DECLARE @KernelTableNumber INT;
DECLARE @SqlCmd NVARCHAR(500);

BEGIN TRY
    BEGIN TRANSACTION T1

       OPEN KernelTableName_cursor;

       FETCH NEXT FROM KernelTableName_cursor INTO @KernelTableName, @KernelTableNumber;

       WHILE @@FETCH_STATUS = 0
            BEGIN

                IF COL_LENGTH(@KernelTableName, 'SYSROWVERSIONNUMBER') IS NOT NULL
                    BEGIN
            SET @SqlCmd = 'ALTER TABLE dbo.' + @KernelTableName + ' DROP COLUMN SYSROWVERSIONNUMBER';
                        EXEC sp_executesql @SqlCmd;
                        SET @Result = 1;
                        INSERT INTO @ResultKernelTables(TableNumber) VALUES(@KernelTableNumber);
                    END

                FETCH NEXT FROM KernelTableName_cursor INTO @KernelTableName, @KernelTableNumber;

            END


    COMMIT TRANSACTION T1

    SELECT @Result AS Result, TableNumber AS KernelTableNumber, 0 AS Error, '' AS ErrorMessage
    FROM @ResultKernelTables;

END TRY

BEGIN CATCH
    SELECT -1 AS Result, -1 AS KernelTableNumber, ERROR_NUMBER() as Error, ERROR_MESSAGE() as ErrorMessage
    ROLLBACK TRANSACTION T1
END CATCH