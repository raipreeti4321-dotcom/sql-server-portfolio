# Metadata Driven Incremental ETL Framework

## Business Problem

Multiple source tables required daily loading into reporting tables.
Maintaining separate ETL logic for each table increased development and support effort.

## Solution

Developed a metadata-driven ETL framework using SQL Server.

Features:
- Incremental loading
- Dynamic SQL
- Audit logging
- Error handling
- Reusable framework

## Technical Components

- Stored Procedure
- ETL_Audit table
- Dynamic SQL
- TRY/CATCH
- Watermark-based loading

## Benefits

- Reduced code duplication
- Simplified onboarding of new tables
- Improved monitoring and supportability
- Standardized ETL process

## Technologies

- SQL Server
- T-SQL
- Stored Procedures
- Dynamic SQL
