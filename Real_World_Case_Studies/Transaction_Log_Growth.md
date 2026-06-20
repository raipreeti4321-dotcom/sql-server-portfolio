# Transaction Log Growth Investigation

## Overview

A production SQL Server database experienced continuous transaction log (LDF) growth, eventually consuming a significant portion of the available disk space. The issue required immediate investigation to prevent application downtime and database outages.

## Business Problem

The transaction log file was growing rapidly despite no significant increase in business activity. Operations teams reported low disk space alerts, and database maintenance jobs were at risk of failing.

## Investigation

### Step 1: Check Log Space Usage

Reviewed current log utilization:

```sql
DBCC SQLPERF(LOGSPACE);
```

### Step 2: Verify Recovery Model

Checked database recovery configuration:

```sql
SELECT
    name,
    recovery_model_desc
FROM sys.databases
WHERE name = 'DatabaseName';
```

### Step 3: Check Open Transactions

Investigated long-running transactions:

```sql
DBCC OPENTRAN;
```

### Step 4: Review Backup History

Verified transaction log backup frequency:

```sql
SELECT
    database_name,
    backup_start_date,
    backup_finish_date
FROM msdb.dbo.backupset
WHERE type = 'L'
ORDER BY backup_finish_date DESC;
```

## Root Cause

The database was operating in FULL recovery mode, but transaction log backups were either not running or failing.

As a result, SQL Server could not truncate inactive log records, causing the LDF file to continue growing.

Additional investigation revealed a long-running transaction that further delayed log truncation.

## Resolution

Performed a transaction log backup:

```sql
BACKUP LOG DatabaseName
TO DISK = 'D:\SQLBackups\DatabaseName_Log.trn';
```

Validated successful backup completion.

Reviewed SQL Agent jobs responsible for log backups and corrected scheduling issues.

Implemented monitoring for log space usage and backup failures.

## Results

* Transaction log growth stabilized.
* Disk space pressure was eliminated.
* Backup process reliability improved.
* Prevented future storage-related incidents.

## Lessons Learned

* FULL recovery mode requires regular transaction log backups.
* Long-running transactions can prevent log truncation.
* Log growth should be monitored proactively.
* Backup failures should generate alerts immediately.

## Skills Demonstrated

* SQL Server Administration
* Backup & Recovery
* Recovery Models
* Transaction Log Management
* Production Support
* Performance Monitoring
