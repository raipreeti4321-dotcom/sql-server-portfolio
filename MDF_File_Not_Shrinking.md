# MDF File Not Shrinking After Data Deletion

## Business Problem

A large volume of historical data was deleted from a SQL Server database to reclaim disk space. Despite deleting millions of records, the MDF file size remained unchanged.

## Investigation

Verified current database file sizes:

```sql
EXEC sp_helpfile;
