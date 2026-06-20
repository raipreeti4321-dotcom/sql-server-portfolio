# MDF File Not Shrinking After Data Deletion

## Overview

During routine database maintenance, a large volume of historical data was deleted from multiple tables to reclaim storage space. Although millions of records were removed, the MDF file size did not decrease at the operating system level.

## Business Problem

The database server was experiencing disk space pressure, and the expectation was that deleting old data would immediately reduce the MDF file size. However, even after successful data deletion, the physical database file remained the same size.

## Investigation

### Step 1: Verify Data Deletion

Confirmed that the records were successfully removed from the target tables.

```sql
SELECT COUNT(*)
FROM dbo.TableName;
```

### Step 2: Check Database Space Usage

```sql
EXEC sp_spaceused;
```

Analysis showed that a significant amount of free space existed inside the database.

### Step 3: Check Data and Log File Sizes

```sql
EXEC sp_helpfile;
```

Verified the current MDF and LDF file sizes.

### Step 4: Review Index Fragmentation

Large delete operations had introduced fragmentation and unused pages.

```sql
SELECT *
FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'DETAILED'
);
```

## Root Cause

Deleting records frees pages within the database but does not automatically reduce the physical MDF file size.

SQL Server retains the freed space for future growth, which is normal behavior and helps avoid repeated file growth operations.

## Resolution

Performed a controlled shrink operation after validating that the free space was no longer required.

```sql
DBCC SHRINKFILE
(
    N'Database_Data',
    10240
);
```

After shrinking, rebuilt indexes to address fragmentation caused by page movement.

```sql
ALTER INDEX ALL
ON dbo.TableName
REBUILD;
```

## Results

* Successfully reclaimed disk space.
* Reduced MDF file size.
* Improved storage utilization.
* Restored index health after shrink operation.

## Lessons Learned

* Data deletion does not automatically reduce MDF file size.
* Shrink operations should only be performed when space must be returned to the operating system.
* Frequent shrinking can cause severe index fragmentation.
* Always rebuild or reorganize indexes after large shrink operations.

## Skills Demonstrated

* SQL Server Administration
* Database Storage Management
* Capacity Planning
* Performance Optimization
* Index Maintenance
* Production Support
